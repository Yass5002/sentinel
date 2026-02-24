import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/features/auth/data/auth_repository.dart';
import 'package:sentinel/features/auth/presentation/auth_notifier.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  int _resendCountdown = 60;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
  }

  void _startResendTimer() {
    _resendCountdown = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _shakeController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, just unfocus. User must tap verify.
        _focusNodes[index].unfocus();
      }
    } else {
      // Handle backspace
      if (value.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    // Trigger rebuild to update button enabled/disabled state
    setState(() => _errorMessage = null);
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 6) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notifier = ref.read(authNotifierProvider.notifier);
      await notifier.login(otp, widget.email);

      // Success — navigate to home
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      // OTP verification failed — show error locally without redirecting
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
        _shakeController.forward();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendCode() async {
    if (_resendCountdown > 0) return;

    try {
      await ref.read(authRepositoryProvider).sendOtp(widget.email);
      _startResendTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.codeSent)),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward_sharp
                : Icons.arrow_back_sharp,
            color: Colors.white,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.checkEmail,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.codeSentTo(widget.email),
                    style: const TextStyle(
                      color: AppTheme.lightGreyText,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 32),

                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        // Add gap after 3rd digit
                        return Row(
                          children: [
                            if (index == 3) const SizedBox(width: 16),
                            SizedBox(
                              width: 44, // Adjust width to fit 6 + gap
                              height: 56,
                              child: TextFormField(
                                key: ValueKey(
                                  'otp_$index',
                                ), // Maintain identity on rebuilds
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  height:
                                      1.0, // Prevent extra vertical padding from font metrics
                                ),
                                maxLength: 1,
                                onChanged: (value) =>
                                    _onDigitEntered(index, value),
                                decoration: const InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: AppTheme.darkSurface, // #333333
                                  contentPadding: EdgeInsets
                                      .zero, // Prevent clipping in narrow field
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    // Orange bottom border active
                                    borderSide: BorderSide(
                                      color: AppTheme.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Color(0xFFD32F2F)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          (_isLoading ||
                              _controllers.every((c) => c.text.isNotEmpty) ==
                                  false)
                          ? null
                          : _verifyOtp,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(AppLocalizations.of(context)!.verify),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: _resendCountdown > 0 ? null : _resendCode,
                          child: Text(
                            _resendCountdown > 0
                                ? AppLocalizations.of(
                                    context,
                                  )!.resendCodeIn(_resendCountdown)
                                : AppLocalizations.of(context)!.resendCode,
                            style: TextStyle(
                              color: _resendCountdown > 0
                                  ? AppTheme.lightGreyText
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
