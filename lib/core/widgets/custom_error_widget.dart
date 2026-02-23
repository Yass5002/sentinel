import 'package:flutter/material.dart';
import 'package:sentinel/core/theme/app_theme.dart';

class CustomErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    this.title = 'SOMETHING WENT WRONG!',
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons
                  .power_off_sharp, // Represents a disconnected plug in Material
              color: Colors.white54,
              size: 72,
            ),
            const SizedBox(height: 24),
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Courier',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontFamily: 'Courier',
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
              child: const Text(
                'RETRY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
