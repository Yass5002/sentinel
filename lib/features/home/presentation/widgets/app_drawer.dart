import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/theme/text_style_helper.dart';
import 'package:sentinel/features/auth/presentation/auth_notifier.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _appVersion = 'v${info.version}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authNotifierProvider);
    final user = userAsync.valueOrNull;

    return Drawer(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header — tap to open Profile
          GestureDetector(
            onTap: () {
              context.pop();
              context.push('/profile');
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              color: AppTheme.darkSurface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    color: AppTheme.primaryColor,
                    child: Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : (user?.email.isNotEmpty == true
                                ? user!.email[0].toUpperCase()
                                : 'S'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? AppLocalizations.of(context)!.loading,
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
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home_sharp,
                  label: AppLocalizations.of(context)!.home.toUpperCase(),
                  isActive: true,
                  onTap: () => context.pop(),
                ),
                _buildDrawerItem(
                  icon: Icons.people_sharp,
                  label: AppLocalizations.of(context)!.contacts.toUpperCase(),
                  isActive: false,
                  onTap: () {
                    context.pop();
                    context.push('/contacts');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings_sharp,
                  label: AppLocalizations.of(context)!.settings.toUpperCase(),
                  isActive: false,
                  onTap: () {
                    context.pop();
                    context.push('/settings');
                  },
                ),
              ],
            ),
          ),

          // Footer: Version
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Text(
              _appVersion,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 12,
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
              border: BorderDirectional(
                start: BorderSide(color: AppTheme.primaryColor, width: 4),
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
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.0),
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      ),
    );
  }
}
