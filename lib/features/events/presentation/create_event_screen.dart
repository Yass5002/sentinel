import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/features/events/presentation/create_event_provider.dart';
import 'package:sentinel/features/events/presentation/event_providers.dart';
import 'package:sentinel/features/events/presentation/widgets/contact_picker.dart';
import 'package:sentinel/features/events/presentation/widgets/file_upload_card.dart';
import 'package:sentinel/features/events/presentation/widgets/timer_segment_control.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      ref.read(createEventNotifierProvider.notifier).uploadFile(file);
    }
  }

  void _submit() async {
    final success = await ref
        .read(createEventNotifierProvider.notifier)
        .createEvent();
    if (success && mounted) {
      // Refresh the Home Screen list
      ref.invalidate(eventListProvider);
      context.pop(); // Go back to Home
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createEventNotifierProvider);
    final notifier = ref.read(createEventNotifierProvider.notifier);

    // Listen for errors
    ref.listen(createEventNotifierProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'NEW SENTINEL',
          style: TextStyle(letterSpacing: 2.0, fontSize: 16),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Event Name (Headline)
                  TextField(
                    controller: _nameController,
                    onChanged: notifier.setName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'EVENT NAME',
                      hintStyle: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Timer Section
                  const Text(
                    'TIMER',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TimerSegmentControl(
                    isDurationMode: state.isDurationMode,
                    onModeChanged: notifier.setDurationMode,
                    onDurationChanged: (h, m, s) =>
                        notifier.setDuration(h: h, m: m, s: s),
                    onDateChanged: notifier.setTargetDate,
                    date: state.targetDate,
                  ),
                  const SizedBox(height: 24),

                  // Message Block
                  const Text(
                    'MESSAGE',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    color: AppTheme.darkSurface,
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _messageController,
                      onChanged: notifier.setMessage,
                      maxLines: 5,
                      maxLength: 2000,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter your message...',
                        hintStyle: TextStyle(color: Color(0xFF666666)),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        counterStyle: TextStyle(color: Color(0xFF666666)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Contacts
                  const Text(
                    'CONTACTS',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ContactPicker(
                    selectedContacts: state.selectedContacts,
                    onAdd: notifier.addContact,
                    onRemove: notifier.removeContact,
                  ),

                  const SizedBox(height: 24),

                  // Attachments
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ATTACHMENTS',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      InkWell(
                        onTap: state.isUploading ? null : _pickFile,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add_sharp,
                              color: AppTheme.primaryColor,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'ADD FILE',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (state.isUploading)
                    const FileUploadProgressCard(filename: "Uploading..."),

                  ...state.uploadedFiles.map(
                    (file) => FileUploadCard(
                      file: file,
                      onDelete: () => notifier.removeFile(file.id),
                    ),
                  ),
                  const SizedBox(height: 48), // Spacing before button
                  // Unpinned Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        disabledBackgroundColor: AppTheme.primaryColor
                            .withOpacity(0.5),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'INITIATE SENTINEL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  ),

                  // Bottom viewport padding so button isn't flushed against edge if content is short
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
                ],
              ),
            ),
          ),
        ],
      ),
      // Overlay Gradient for Scroll Hint
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: IgnorePointer(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            ),
          ),
        ),
      ),
    );
  }
}
