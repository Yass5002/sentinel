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
import 'package:permission_handler/permission_handler.dart';
import 'package:sentinel/core/services/notification_service.dart';
import 'package:sentinel/core/services/native_timer_service.dart';
import 'package:sentinel/core/storage/preferences_service.dart';
import 'package:sentinel/core/time/time_sync_provider.dart';
import 'package:sentinel/features/events/domain/event_model.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isNavigating = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      ref.read(createEventNotifierProvider.notifier).uploadFile(file);
    }
  }

  void _submit() async {
    if (_isNavigating) return;

    final event = await ref
        .read(createEventNotifierProvider.notifier)
        .createEvent();

    if (event != null && mounted) {
      setState(() {
        _isNavigating = true; // Lock the button during primer/OS prompts
      });
      // Refresh the Home Screen list
      ref.invalidate(eventListProvider);

      await _handlePostCreation(event);

      if (mounted) {
        context.go('/'); // Safely route to Home using push replacement
      }
    }
  }

  Future<void> _handlePostCreation(Event event) async {
    final prefs = ref.read(preferencesServiceProvider);
    final status = await Permission.notification.status;

    // Permissions are handled once during onboarding on the Home screen.
    // Here we only schedule if permission is already in place.
    if ((status.isGranted || status.isProvisional) &&
        prefs.notificationsEnabled) {
      final timeSync = ref.read(timeSyncProvider);
      await ref
          .read(notificationServiceProvider)
          .scheduleReminders(
            eventId: event.id,
            eventName: event.name,
            expiresAt: event.expiresAt,
            timeDelta: timeSync,
          );

      // Start native countdown precisely 5 minutes before event expires
      final triggerAt = event.expiresAt.subtract(const Duration(minutes: 5));
      await ref
          .read(nativeTimerServiceProvider)
          .startCountdown(
            eventId: event.id,
            eventName: event.name,
            triggerAt: triggerAt,
            expiresAt: event.expiresAt,
            timeDelta: timeSync,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createEventNotifierProvider);
    final notifier = ref.read(createEventNotifierProvider.notifier);

    // Inline error instead of SnackBar

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
                    onRemove: notifier.removeContact,
                    onUpdateContacts: notifier.updateContacts,
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
                  const SizedBox(height: 24), // Spacing before button
                  // Inline Error Display
                  if (state.error != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withValues(alpha: 0.1),
                        border: Border.all(
                          color: AppTheme.errorColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppTheme.errorColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              state.error!,
                              style: const TextStyle(
                                color: AppTheme.errorColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    const SizedBox(height: 48), // Spacing if no error
                  ],
                  // Unpinned Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (state.isSubmitting || _isNavigating)
                          ? null
                          : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        disabledBackgroundColor: AppTheme.primaryColor
                            .withValues(alpha: 0.5),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: (state.isSubmitting || _isNavigating)
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
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
            ),
          ),
        ),
      ),
    );
  }
}
