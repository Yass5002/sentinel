import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/widgets/custom_error_widget.dart';
import 'package:sentinel/features/profile/presentation/profile_provider.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(letterSpacing: 2.0, fontSize: 16),
        ),
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
      body: profileAsync.when(
        data: (user) {
          if (user == null) {
            return CustomErrorWidget(
              message: 'Unable to load profile',
              onRetry: () => ref.invalidate(profileNotifierProvider),
            );
          }

          final initial = user.name.isNotEmpty
              ? user.name[0].toUpperCase()
              : user.email[0].toUpperCase();

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 24),

              // Avatar
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  alignment: Alignment.center,
                  color: AppTheme.primaryColor,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Name row
              InkWell(
                onTap: () => _showEditNameSheet(context, ref, user.name),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name.isNotEmpty ? user.name : 'Set your name',
                      style: TextStyle(
                        color: user.name.isNotEmpty
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.edit_sharp,
                      color: Colors.white.withValues(alpha: 0.4),
                      size: 18,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Center(
                child: Text(
                  'This is the name your contacts see in alert emails',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // Email
              _buildInfoRow(
                AppLocalizations.of(context)!.emailHint.toUpperCase(),
                user.email,
              ),

              const SizedBox(height: 24),

              // Member since
              _buildInfoRow(
                AppLocalizations.of(context)!.memberSince,
                DateFormat('MMMM d, yyyy').format(user.createdAt),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (err, _) => CustomErrorWidget(
          message: 'Failed to load profile',
          onRetry: () => ref.invalidate(profileNotifierProvider),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF666666),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: AppTheme.darkSurface,
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _showEditNameSheet(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      isScrollControlled: true,
      builder: (ctx) => _EditNameSheet(
        currentName: currentName,
        onSave: (name) async {
          return ref.read(profileNotifierProvider.notifier).updateName(name);
        },
      ),
    );
  }
}

class _EditNameSheet extends StatefulWidget {
  final String currentName;
  final Future<String?> Function(String name) onSave;

  const _EditNameSheet({required this.currentName, required this.onSave});

  @override
  State<_EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends State<_EditNameSheet> {
  late final TextEditingController _nameController;
  String? _error;
  bool _isSaving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Name is required');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    final error = await widget.onSave(name);

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _isSaving = false;
        _error = error;
      });
      return;
    }

    setState(() {
      _isSaving = false;
      _saved = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.editNameTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),

          Text(
            AppLocalizations.of(context)!.nameHint.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: AppTheme.darkSurface,
            child: TextField(
              controller: _nameController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.nameHint,
                hintStyle: const TextStyle(color: Color(0xFF666666)),
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                _error!,
                style: const TextStyle(
                  color: AppTheme.errorColor,
                  fontSize: 12,
                ),
              ),
            ),

          const SizedBox(height: 24),

          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: (_isSaving || _saved) ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: _saved
                    ? AppTheme.primaryColor.withValues(alpha: 0.7)
                    : AppTheme.primaryColor.withValues(alpha: 0.5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _saved
                          ? AppLocalizations.of(context)!.save
                          : AppLocalizations.of(context)!.save,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
