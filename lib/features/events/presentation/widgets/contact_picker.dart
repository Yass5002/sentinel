import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/features/contacts/presentation/contacts_provider.dart';
import 'package:sentinel/l10n/app_localizations.dart';

class ContactPicker extends StatelessWidget {
  final List<Map<String, String>> selectedContacts;
  final Function(List<Map<String, String>>) onUpdateContacts;
  final Function(String email) onRemove;

  const ContactPicker({
    super.key,
    required this.selectedContacts,
    required this.onUpdateContacts,
    required this.onRemove,
  });

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return _AddContactSheet(
          initialContacts: selectedContacts,
          onSave: onUpdateContacts,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...selectedContacts.map((contact) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                color: AppTheme.darkSurface,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      contact['name']?.isNotEmpty == true
                          ? contact['name']!
                          : contact['email']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => onRemove(contact['email']!),
                      child: const Icon(
                        Icons.close_sharp,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (selectedContacts.length < 10)
              InkWell(
                onTap: () => _showAddSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_sharp,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.addContact,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _AddContactSheet extends ConsumerStatefulWidget {
  final List<Map<String, String>> initialContacts;
  final Function(List<Map<String, String>>) onSave;

  const _AddContactSheet({required this.initialContacts, required this.onSave});

  @override
  ConsumerState<_AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends ConsumerState<_AddContactSheet> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  String _searchQuery = '';
  String? _localError;

  late final Set<String> _checkedEmails;
  late final Map<String, String> _manualContactsMap;

  @override
  void initState() {
    super.initState();
    _checkedEmails = widget.initialContacts.map((c) => c['email']!).toSet();
    _manualContactsMap = {
      for (var c in widget.initialContacts) c['email']!: c['name'] ?? '',
    };
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedContactsAsync = ref.watch(contactsNotifierProvider);
    final savedContacts = savedContactsAsync.valueOrNull ?? [];

    final queryLower = _searchQuery.toLowerCase();
    final filteredContacts = savedContacts.where((c) {
      return c.email.toLowerCase().contains(queryLower) ||
          c.name.toLowerCase().contains(queryLower);
    }).toList();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 16),
            child: Text(
              AppLocalizations.of(context)!.selectContacts,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          if (savedContacts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.savedContacts,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.contactsSelected(_checkedEmails.length),
                    style: TextStyle(
                      color: _checkedEmails.length > 10
                          ? AppTheme.errorColor
                          : const Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                color: AppTheme.darkSurface,
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!.searchContacts,
                    hintStyle: const TextStyle(color: Color(0xFF666666)),
                    icon: const Icon(
                      Icons.search_sharp,
                      color: Color(0xFF666666),
                      size: 18,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Scrollable checkbox list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = filteredContacts[index];
                  final isSelected = _checkedEmails.contains(contact.email);

                  return CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    activeColor: AppTheme.primaryColor,
                    checkColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF666666)),
                    value: isSelected,
                    onChanged: (bool? val) {
                      setState(() {
                        if (val == true) {
                          _checkedEmails.add(contact.email);
                        } else {
                          _checkedEmails.remove(contact.email);
                        }
                      });
                    },
                    title: Text(
                      contact.name.isNotEmpty ? contact.name : contact.email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: contact.name.isNotEmpty
                        ? Text(
                            contact.email,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          )
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (savedContacts.isNotEmpty) ...[
                  Text(
                    AppLocalizations.of(context)!.orEnterManually,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                ] else ...[
                  Text(
                    AppLocalizations.of(context)!.enterContactManually,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Manual Email field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  color: AppTheme.darkSurface,
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.emailExample,
                      hintStyle: const TextStyle(color: Color(0xFF666666)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Manual Name field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  color: AppTheme.darkSurface,
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(
                        context,
                      )!.contactNameOptional,
                      hintStyle: const TextStyle(color: Color(0xFF666666)),
                    ),
                  ),
                ),

                if (_localError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _localError!,
                      style: const TextStyle(
                        color: AppTheme.errorColor,
                        fontSize: 13,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final List<Map<String, String>> finalContacts = [];

                      // Add all checked emails
                      for (var email in _checkedEmails) {
                        final savedUserIt = savedContacts.where(
                          (c) => c.email == email,
                        );
                        if (savedUserIt.isNotEmpty) {
                          finalContacts.add({
                            'email': email,
                            'name': savedUserIt.first.name,
                          });
                        } else {
                          // It was a manual contact previously selected
                          finalContacts.add({
                            'email': email,
                            'name': _manualContactsMap[email] ?? '',
                          });
                        }
                      }

                      // Check manual entry
                      final manualEmail = _emailController.text.trim();
                      final manualName = _nameController.text.trim();

                      if (manualEmail.isNotEmpty) {
                        if (!RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(manualEmail)) {
                          setState(
                            () => _localError = AppLocalizations.of(
                              context,
                            )!.emailInvalid,
                          );
                          return;
                        }

                        // Deduplicate
                        if (!finalContacts.any(
                          (c) => c['email'] == manualEmail,
                        )) {
                          // If entered manually but exists in savedContacts, grab the name if not provided
                          String resolvedName = manualName;
                          if (resolvedName.isEmpty) {
                            final savedUserIt = savedContacts.where(
                              (c) => c.email == manualEmail,
                            );
                            if (savedUserIt.isNotEmpty) {
                              resolvedName = savedUserIt.first.name;
                            }
                          }

                          finalContacts.add({
                            'email': manualEmail,
                            'name': resolvedName,
                          });
                        }
                      }

                      if (finalContacts.isEmpty) {
                        setState(
                          () => _localError = AppLocalizations.of(
                            context,
                          )!.selectAtLeastOneContact,
                        );
                        return;
                      }
                      if (finalContacts.length > 10) {
                        setState(
                          () => _localError = AppLocalizations.of(
                            context,
                          )!.maxContactsAllowed,
                        );
                        return;
                      }

                      widget.onSave(finalContacts);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.save,
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
          ),
        ],
      ),
    );
  }
}
