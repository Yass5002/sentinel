import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _launchSupportEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@sentinel.yssn.tech',
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Sentinel support request',
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.helpTitle.toUpperCase(),
          style: const TextStyle(letterSpacing: 2.0, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward_sharp
                : Icons.arrow_back_sharp,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ1,
              content: AppLocalizations.of(context)!.helpA1,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ2,
              content: AppLocalizations.of(context)!.helpA2,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ3,
              content: AppLocalizations.of(context)!.helpA3,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ4,
              content: AppLocalizations.of(context)!.helpA4,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ5,
              content: AppLocalizations.of(context)!.helpA5,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ6,
              content: AppLocalizations.of(context)!.helpA6,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ7,
              content: AppLocalizations.of(context)!.helpA7,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ8,
              content: AppLocalizations.of(context)!.helpA8,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ9,
              content: AppLocalizations.of(context)!.helpA9,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ10,
              content: AppLocalizations.of(context)!.helpA10,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ11,
              content: AppLocalizations.of(context)!.helpA11,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ12,
              content: AppLocalizations.of(context)!.helpA12,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ13,
              content: AppLocalizations.of(context)!.helpA13,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ14,
              content: AppLocalizations.of(context)!.helpA14,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.helpQ15,
              content: AppLocalizations.of(context)!.helpA15,
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.contactSupport,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              children: [
                Text(
                  AppLocalizations.of(context)!.contactSupportText,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: _launchSupportEmail,
                  child: const Text(
                    'support@sentinel.yssn.tech',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 15,
                      height: 1.5,
                      decoration: TextDecoration.underline,
                      decorationColor: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const Text(
                  '.',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            height: 1.5,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
