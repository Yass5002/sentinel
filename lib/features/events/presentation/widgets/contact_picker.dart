import 'package:flutter/material.dart';
import 'package:sentinel/core/theme/app_theme.dart';

class ContactPicker extends StatefulWidget {
  final List<Map<String, String>> selectedContacts;
  final Function(String email, String name) onAdd;
  final Function(String email) onRemove;

  const ContactPicker({
    super.key,
    required this.selectedContacts,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<ContactPicker> createState() => _ContactPickerState();
}

class _ContactPickerState extends State<ContactPicker> {
  void _showAddSheet() {
    final emailController = TextEditingController();
    final nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      isScrollControlled: true,
      builder: (context) {
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
              const Text(
                'ADD CONTACT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 24),

              // Email Field
              // Email Field
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
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),

              const SizedBox(height: 16),

              // Name Field
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
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                    widget.onAdd(emailController.text, nameController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('ADD'),
              ),
              const SizedBox(height: 24),
            ],
          ),
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
            ...widget.selectedContacts.map((contact) {
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
                      onTap: () => widget.onRemove(contact['email']!),
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
            InkWell(
              onTap: _showAddSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_sharp,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'ADD CONTACT',
                      style: TextStyle(
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
