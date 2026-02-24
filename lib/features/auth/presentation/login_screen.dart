import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/theme/text_style_helper.dart';
import 'package:sentinel/features/auth/data/auth_repository.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .sendOtp(_emailController.text.trim());
      if (mounted) {
        context.push('/otp', extra: _emailController.text.trim());
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Regex for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left align content
            children: [
              const Spacer(flex: 3),

              // Wordmark (Centered & Responsive)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AppLocalizations.of(context)!.sentinelBrand,
                      style: TextStyle(
                        fontFamily: 'SentinelBrand',
                        fontSize: 56,
                        color: AppTheme.primaryColor,
                        letterSpacing: TextStyleHelper.getLetterSpacing(context, 2.0),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48), // Increased gap from logo to text
              Text(
                AppLocalizations.of(context)!.loginTitle,
                style: const TextStyle(
                  color: AppTheme.lightGreyText,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16), // Small fixed gap to input

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: AppTheme.primaryColor,
                      onChanged: (value) {
                        // Trigger rebuild to update button state
                        setState(() {
                          // Clear error when user types, as they are trying to fix it
                          if (_errorMessage != null) _errorMessage = null;
                        });
                      },
                      decoration: InputDecoration(
                        // Removed labelText to prevent floating label
                        hintText: AppLocalizations.of(context)!.emailHint,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.emailRequired;
                        }
                        if (!emailRegex.hasMatch(value)) {
                          return AppLocalizations.of(context)!.emailInvalid;
                        }
                        return null;
                      },
                    ),

                    // Inline Error Message
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFD32F2F),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        // Disable if loading OR email is invalid
                        onPressed:
                            (_isLoading ||
                                !emailRegex.hasMatch(_emailController.text))
                            ? null
                            : _sendOtp,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(AppLocalizations.of(context)!.getStarted),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
