import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentinel/features/files/data/file_repository.dart';
import 'package:sentinel/features/files/domain/file_model.dart';
import 'package:sentinel/features/events/domain/event_model.dart';
import 'package:sentinel/features/events/data/event_repository.dart';
import 'package:sentinel/features/events/presentation/event_providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_event_provider.g.dart';
part 'create_event_provider.freezed.dart';

@freezed
class CreateEventState with _$CreateEventState {
  const factory CreateEventState({
    @Default('') String name,
    @Default('') String message,
    // Timer
    @Default(true) bool isDurationMode,
    @Default(0) int durationHours,
    @Default(0) int durationMinutes,
    @Default(0) int durationSeconds,
    DateTime? targetDate,

    // Contacts
    @Default([]) List<Map<String, String>> selectedContacts, // {email, name}
    // Files
    @Default([]) List<FileModel> uploadedFiles,
    @Default(false) bool isUploading,

    @Default(false) bool isSubmitting,
    String? error,
  }) = _CreateEventState;
}

@riverpod
class CreateEventNotifier extends _$CreateEventNotifier {
  @override
  CreateEventState build() {
    return const CreateEventState();
  }

  void setName(String value) {
    state = state.copyWith(name: value, error: null);
  }

  void setMessage(String value) {
    state = state.copyWith(message: value, error: null);
  }

  void setDurationMode(bool isDuration) {
    state = state.copyWith(isDurationMode: isDuration);
  }

  void setDuration({int? h, int? m, int? s}) {
    state = state.copyWith(
      durationHours: h ?? state.durationHours,
      durationMinutes: m ?? state.durationMinutes,
      durationSeconds: s ?? state.durationSeconds,
    );
  }

  void setTargetDate(DateTime? date) {
    state = state.copyWith(targetDate: date);
  }

  void addContact(String email, String name) {
    if (state.selectedContacts.any((c) => c['email'] == email)) return;
    state = state.copyWith(
      selectedContacts: [
        ...state.selectedContacts,
        {'email': email, 'name': name},
      ],
    );
  }

  void removeContact(String email) {
    state = state.copyWith(
      selectedContacts: state.selectedContacts
          .where((c) => c['email'] != email)
          .toList(),
    );
  }

  Future<void> uploadFile(File file) async {
    state = state.copyWith(isUploading: true, error: null);
    try {
      // Client-side size check (10MB)
      final size = await file.length();
      if (size > 10 * 1024 * 1024) {
        throw Exception('File too large (Max 10MB)');
      }

      final uploaded = await ref.read(fileRepositoryProvider).uploadFile(file);
      state = state.copyWith(
        uploadedFiles: [...state.uploadedFiles, uploaded],
        isUploading: false,
      );
    } catch (e) {
      state = state.copyWith(isUploading: false, error: e.toString());
    }
  }

  Future<void> removeFile(String id) async {
    try {
      await ref.read(fileRepositoryProvider).deleteStagedFile(id);
      state = state.copyWith(
        uploadedFiles: state.uploadedFiles.where((f) => f.id != id).toList(),
      );
    } catch (e) {
      // Even if delete fails on server, remove from UI
      state = state.copyWith(
        uploadedFiles: state.uploadedFiles.where((f) => f.id != id).toList(),
        error: "Failed to delete from server: $e",
      );
    }
  }

  int _calculateDurationMs() {
    if (state.isDurationMode) {
      final d = Duration(
        hours: state.durationHours,
        minutes: state.durationMinutes,
        seconds: state.durationSeconds,
      );
      return d.inMilliseconds;
    } else {
      if (state.targetDate == null) return 0;
      final diff = state.targetDate!.difference(DateTime.now());
      return diff.inMilliseconds;
    }
  }

  Future<Event?> createEvent() async {
    if (state.name.isEmpty) {
      state = state.copyWith(error: 'Event name is required');
      return null;
    }

    final durationMs = _calculateDurationMs();
    if (durationMs < 30000) {
      // Min 30 seconds
      state = state.copyWith(error: 'Timer must be at least 30 seconds');
      return null;
    }

    if (state.selectedContacts.isEmpty) {
      state = state.copyWith(error: 'At least one contact is required');
      return null;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final event = await ref
          .read(eventRepositoryProvider)
          .createEvent(
            name: state.name,
            message: state.message,
            durationMs: durationMs,
            contacts: state.selectedContacts,
            fileIds: state.uploadedFiles.map((f) => f.id).toList(),
          );
      state = state.copyWith(isSubmitting: false);
      // Refresh Home Screen
      ref.invalidate(eventListProvider);
      return event;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }
}
