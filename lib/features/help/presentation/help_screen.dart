import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sentinel/core/theme/app_theme.dart';

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
        title: const Text(
          'HELP',
          style: TextStyle(letterSpacing: 2.0, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'What is Sentinel?',
              content:
                  'Sentinel is a personal safety application designed to provide peace of mind in potentially unsafe situations. By setting a countdown timer, Sentinel ensures your trusted contacts are automatically notified with your vital details and last known location if you are unable to check in safely.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Home Screen',
              content:
                  'The home screen displays a list of all your Sentinels. You can view your active, completed, and cancelled Sentinels in one place.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Creating a Sentinel',
              content:
                  'Tap the plus button on the home screen to create a new Sentinel. Give it a name, enter a message, upload any important files, and choose the contacts you want to notify. Finally, set a countdown timer or a specific target time for the Sentinel to expire.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Checking In',
              content:
                  'When a Sentinel is active, a countdown timer is displayed. To let your contacts know you are safe, tap the large "I AM SAFE" button before the timer runs out. This will end the Sentinel without sending any alerts.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Cancelling a Sentinel',
              content:
                  'If you no longer need an active Sentinel, tap "CANCEL EVENT". This will immediately stop the timer and your location tracking. No alerts will be sent to your contacts.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'When a Sentinel Expires',
              content:
                  'If the timer reaches zero and you have not checked in, your Sentinel will expire automatically. Emergency alerts containing your message, attached files, and your last known location will be sent to your selected contacts.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Managing Contacts',
              content:
                  'Access your contacts from the main menu. You can add people by their email address, edit their details, or swipe left on a contact to remove them from your list.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Your Profile',
              content:
                  'Tap your name in the main menu to view your profile. You can change your display name here, which is the name your contacts will see when they receive an alert.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Settings and Permissions',
              content:
                  'Visit the Settings screen to manage your app preferences. You can turn check-in reminders on or off, and manage your location tracking settings. Check-in reminders will notify you 1 hour, 15 minutes, and 5 minutes before a Sentinel is about to expire.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Deleting Event History',
              content:
                  'To remove a past Sentinel from your history, open the past Sentinel from the home screen and tap the delete icon in the top corner.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Deleting Your Account',
              content:
                  'If you wish to permanently delete your account and all your data, you can do so in the Settings screen.',
            ),
            const SizedBox(height: 32),
            const Text(
              'Contact Support',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              children: [
                const Text(
                  'For further assistance, reach out to us at ',
                  style: TextStyle(
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
