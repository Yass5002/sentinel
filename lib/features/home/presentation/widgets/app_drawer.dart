import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/features/auth/presentation/auth_notifier.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authNotifierProvider);
    final user = userAsync.valueOrNull;

    return Drawer(
      // Pure Black Background
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Sharp Drawer
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            color: AppTheme.darkSurface, // Slightly lighter black for header
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sharp Avatar
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  color: AppTheme.primaryColor,
                  child: Text(
                    user?.name.isNotEmpty == true
                        ? user!.name[0].toUpperCase()
                        : 'S',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'Loading...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home_sharp,
                  label: 'HOME',
                  isActive: true, // Currently on Home
                  onTap: () => context.pop(),
                ),
                _buildDrawerItem(
                  icon: Icons.history_sharp,
                  label: 'HISTORY',
                  isActive: false,
                  onTap: () {}, // TODO
                ),
                _buildDrawerItem(
                  icon: Icons.people_sharp,
                  label: 'CONTACTS',
                  isActive: false,
                  onTap: () {}, // TODO
                ),
                _buildDrawerItem(
                  icon: Icons.settings_sharp,
                  label: 'SETTINGS',
                  isActive: false,
                  onTap: () {
                    context.pop();
                    context.push('/settings');
                  },
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextButton.icon(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout_sharp, color: Colors.red),
              label: const Text(
                'LOG OUT',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: isActive
          ? const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppTheme.primaryColor, width: 4),
              ),
              color: AppTheme.darkSurface,
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            letterSpacing: 1.0,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      ),
    );
  }
}
