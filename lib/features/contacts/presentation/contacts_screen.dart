import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/features/contacts/domain/contact_model.dart';
import 'package:sentinel/features/contacts/presentation/contacts_provider.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'CONTACTS',
          style: TextStyle(letterSpacing: 2.0, fontSize: 16),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_sharp),
            onPressed: () => _showAddEditSheet(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        backgroundColor: AppTheme.darkSurface,
        onRefresh: () async {
          ref.invalidate(contactsNotifierProvider);
          // Wait for the new data to load
          await ref.read(contactsNotifierProvider.future);
        },
        child: contactsAsync.when(
          data: (contacts) {
            if (contacts.isEmpty) {
              return _buildEmptyState(context, ref);
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return _ContactTile(
                  contact: contact,
                  onTap: () =>
                      _showAddEditSheet(context, ref, contact: contact),
                  onDelete: () => _confirmDelete(context, ref, contact),
                );
              },
            );
          },
          loading: () => _buildShimmerLoading(),
          error: (err, _) => ListView(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppTheme.errorColor.withValues(alpha: 0.1),
                child: const Text(
                  'Failed to load contacts',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline_sharp,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved contacts',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 180,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => _showAddEditSheet(context, ref),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryColor),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'Add contact',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppTheme.darkSurface,
      highlightColor: const Color(0xFF444444),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(width: 48, height: 48, color: Colors.white),
            title: Container(height: 14, width: 120, color: Colors.white),
            subtitle: Container(
              height: 12,
              width: 180,
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  void _showAddEditSheet(
    BuildContext context,
    WidgetRef ref, {
    Contact? contact,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      isScrollControlled: true,
      builder: (ctx) => _ContactBottomSheet(
        contact: contact,
        onSave: (email, name) async {
          if (contact != null) {
            return ref
                .read(contactsNotifierProvider.notifier)
                .updateContact(id: contact.id, email: email, name: name);
          } else {
            return ref
                .read(contactsNotifierProvider.notifier)
                .addContact(email: email, name: name);
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Contact contact) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text(
          'Delete this contact?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          contact.name.isNotEmpty
              ? '${contact.name} (${contact.email}) will be removed from your saved contacts.'
              : '${contact.email} will be removed from your saved contacts.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref
                  .read(contactsNotifierProvider.notifier)
                  .deleteContact(contact.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// --- Contact tile with swipe-to-delete ---

class _ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ContactTile({
    required this.contact,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(contact.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false; // We handle deletion in the confirmation dialog
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: AppTheme.errorColor,
        child: const Icon(Icons.delete_sharp, color: Colors.white),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        leading: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          color: AppTheme.darkSurface,
          child: Text(
            contact.name.isNotEmpty
                ? contact.name[0].toUpperCase()
                : contact.email[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          contact.name.isNotEmpty ? contact.name : contact.email,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: contact.name.isNotEmpty
            ? Text(
                contact.email,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              )
            : null,
      ),
    );
  }
}

// --- Bottom sheet for add/edit ---

class _ContactBottomSheet extends StatefulWidget {
  final Contact? contact;
  final Future<String?> Function(String email, String name) onSave;

  const _ContactBottomSheet({this.contact, required this.onSave});

  @override
  State<_ContactBottomSheet> createState() => _ContactBottomSheetState();
}

class _ContactBottomSheetState extends State<_ContactBottomSheet> {
  late final TextEditingController _emailController;
  late final TextEditingController _nameController;
  String? _emailError;
  String? _globalError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  Future<void> _save() async {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();

    setState(() {
      _emailError = null;
      _globalError = null;
    });

    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
      return;
    }
    if (!_isValidEmail(email)) {
      setState(() => _emailError = 'Enter a valid email address');
      return;
    }

    setState(() => _isSaving = true);

    final error = await widget.onSave(email, name);

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _isSaving = false;
        if (error.toLowerCase().contains('duplicate') ||
            error.toLowerCase().contains('already exists')) {
          _emailError = 'A contact with this email already exists';
        } else {
          _globalError = error;
        }
      });
      return;
    }

    // Success — dismiss immediately
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;

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
            isEditing ? 'Edit contact' : 'Add contact',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),

          // Global error banner
          if (_globalError != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: AppTheme.errorColor.withValues(alpha: 0.1),
              child: Text(
                _globalError!,
                style: const TextStyle(
                  color: AppTheme.errorColor,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Email
          const Text(
            'EMAIL',
            style: TextStyle(
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
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'email@example.com',
                hintStyle: TextStyle(color: Color(0xFF666666)),
              ),
            ),
          ),
          if (_emailError != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                _emailError!,
                style: const TextStyle(
                  color: AppTheme.errorColor,
                  fontSize: 12,
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Name
          const Text(
            'NAME (OPTIONAL)',
            style: TextStyle(
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
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Contact name',
                hintStyle: TextStyle(color: Color(0xFF666666)),
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: AppTheme.primaryColor.withValues(
                  alpha: 0.5,
                ),
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
                  : const Text(
                      'Save',
                      style: TextStyle(
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
