import 'package:flutter/material.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/theme/font_utils.dart';
import 'package:sentinel/core/theme/text_style_helper.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.power_off_sharp, color: Colors.white54, size: 72),
            const SizedBox(height: 24),
            Text(
              (title ?? l10n.somethingWentWrong).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontFamily: FontUtils.getCourierFont(context),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontFamily: FontUtils.getCourierFont(context),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(
                l10n.retry.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: TextStyleHelper.getLetterSpacing(context, 2.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
