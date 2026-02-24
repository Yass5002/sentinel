import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/core/storage/preferences_service.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/theme/text_style_helper.dart';
import 'package:sentinel/features/settings/locale_provider.dart';
import 'package:flag/flag.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  String _selectedLanguageCode = 'en';

  final List<Map<String, dynamic>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': FlagsCode.US},
    {'code': 'fr', 'name': 'Français', 'flag': FlagsCode.FR},
    {'code': 'es', 'name': 'Español', 'flag': FlagsCode.ES},
    {'code': 'ar', 'name': 'العربية', 'flag': FlagsCode.MA},
    {'code': 'zh', 'name': '中文', 'flag': FlagsCode.CN},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detectInitialLocale();
    });
  }

  void _detectInitialLocale() {
    final deviceLocale = View.of(
      context,
    ).platformDispatcher.locale.languageCode;
    final supportedCodes = _languages.map((e) => e['code']).toList();
    if (supportedCodes.contains(deviceLocale)) {
      setState(() {
        _selectedLanguageCode = deviceLocale;
      });
    }
  }

  String _getPromptText(String deviceLocale) {
    switch (deviceLocale) {
      case 'fr':
        return 'Choisissez votre langue';
      case 'es':
        return 'Selecciona tu idioma';
      case 'ar':
        return 'اختر لغتك';
      case 'zh':
        return '选择你的语言';
      case 'en':
      default:
        return 'Select your language';
    }
  }

  Future<void> _confirmSelection() async {
    final prefs = ref.read(preferencesServiceProvider);
    await ref
        .read(localeNotifierProvider.notifier)
        .setLocale(Locale(_selectedLanguageCode));
    await prefs.setLanguageSelectionShown();

    if (mounted) {
      context.go('/splash');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: TextStyle(
                      fontFamily: 'SentinelBrand',
                      fontSize: 48,
                      color: AppTheme.primaryColor,
                      letterSpacing: TextStyleHelper.getLetterSpacing(context, 4.0),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _getPromptText(
                  View.of(context).platformDispatcher.locale.languageCode,
                ),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _languages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected = _selectedLanguageCode == lang['code'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLanguageCode = lang['code']!;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor.withValues(alpha: 0.1)
                            : AppTheme.darkSurface,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flag.fromCode(
                                lang['flag'],
                                height: 24,
                                width: 32,
                                borderRadius: 4,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                lang['name']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: AppTheme.primaryColor,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _confirmSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.continueText.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
