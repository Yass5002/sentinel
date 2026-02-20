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

    if (!prefs.notificationPermissionDenied &&
        !prefs.notificationPermissionDismissedPermanently) {
      final status = await Permission.notification.status;
      if (status.isDenied) {
        if (!mounted) return;
        final granted = await _showPrimerDialog();
        if (granted) {
          final newStatus = await Permission.notification.request();
          if (newStatus.isPermanentlyDenied) {
            await prefs.setNotificationPermissionDismissedPermanently(true);
            await prefs.setNotificationsEnabled(false);
          } else if (newStatus.isDenied) {
            await prefs.setNotificationPermissionDenied(true);
            await prefs.setNotificationsEnabled(false);
          } else if (newStatus.isGranted || newStatus.isProvisional) {
            await prefs.setNotificationsEnabled(true);
          }
        } else {
          await prefs.incrementDeferralCount();
          if (prefs.deferralCount >= 3) {
            await prefs.setNotificationPermissionDeferred(true);
          }
        }
      }
    }

    final postStatus = await Permission.notification.status;
    if ((postStatus.isGranted || postStatus.isProvisional) &&
        prefs.notificationsEnabled) {
      // F10: Request SCHEDULE_EXACT_ALARM independently of the primer flow.
      // This runs every time notifications are enabled, catching the case where
      // OS notification permission was already granted on a previous event.
      if (Platform.isAndroid) {
        final exactStatus = await Permission.scheduleExactAlarm.status;
        if (!exactStatus.isGranted) {
          await Permission.scheduleExactAlarm.request();
          // Note: On API 33+, this opens a Settings screen. The user may deny it.
          // The notification_service gracefully falls back to inexact scheduling.
        }
      }

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

  Future<bool> _showPrimerDialog() async {
    bool granted = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Sharp dialog box
        ),
        title: const Text(
          'Never Miss a Check-in',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Sentinel needs notification permissions to remind you before your Sentinels expire. '
          'Without this, you won\'t receive the crucial 1hr, 15m, and 5m countdown alerts.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              granted = false;
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Sharp button
              ),
            ),
            child: const Text('Not Now', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              granted = true;
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Sharp button
              ),
            ),
            child: const Text(
              'Enable Notifications',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return granted;
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
