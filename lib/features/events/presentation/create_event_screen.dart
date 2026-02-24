import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/theme/text_style_helper.dart';
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
import 'package:sentinel/l10n/app_localizations.dart';

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
      final l10n = AppLocalizations.of(context)!;
      final timeSync = ref.read(timeSyncProvider);
      await ref
          .read(notificationServiceProvider)
          .scheduleReminders(
            eventId: event.id,
            eventName: event.name,
            expiresAt: event.expiresAt,
            timeDelta: timeSync,
            title: l10n.notifTitle,
            alertTitle: l10n.notifAlertTitle,
            hourBody: l10n.notifHourBody(event.name),
            fifteenMinBody: l10n.notifFifteenMinBody(event.name),
            fiveMinBody: l10n.notifFiveMinBody(event.name),
            firedBody: l10n.notifFiredBody(event.name),
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
            notificationChannelName: l10n.notifCountdownChannelName,
            notificationChannelDesc: l10n.notifCountdownChannelDesc,
            notificationTitle: event.name,
            notificationBody: l10n.notifCountdownBody,
          );
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
        title: Text(
          AppLocalizations.of(context)!.newSentinel,
          style: TextStyle(letterSpacing: TextStyleHelper.getLetterSpacing(context, 2.0), fontSize: 16),
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
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.eventName,
                      hintStyle: const TextStyle(
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
                  Text(
                    AppLocalizations.of(context)!.timer,
                    style: const TextStyle(
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
                  Text(
                    AppLocalizations.of(context)!.messageTitle,
                    style: const TextStyle(
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
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enterMessage,
                        hintStyle: const TextStyle(color: Color(0xFF666666)),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        counterStyle: const TextStyle(color: Color(0xFF666666)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Contacts
                  Text(
                    AppLocalizations.of(context)!.contacts,
                    style: const TextStyle(
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
                      Text(
                        AppLocalizations.of(context)!.attachments,
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      InkWell(
                        onTap: state.isUploading ? null : _pickFile,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_sharp,
                              color: AppTheme.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(context)!.addFile,
                              style: const TextStyle(
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
                    FileUploadProgressCard(
                      filename: AppLocalizations.of(context)!.uploading,
                    ),

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
                          : Text(
                              AppLocalizations.of(context)!.initiateSentinel,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.5),
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
