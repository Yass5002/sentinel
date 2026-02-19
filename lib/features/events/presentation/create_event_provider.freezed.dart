// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_event_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateEventState {
  String get name => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError; // Timer
  bool get isDurationMode => throw _privateConstructorUsedError;
  int get durationHours => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  DateTime? get targetDate => throw _privateConstructorUsedError; // Contacts
  List<Map<String, String>> get selectedContacts =>
      throw _privateConstructorUsedError; // {email, name}
  // Files
  List<FileModel> get uploadedFiles => throw _privateConstructorUsedError;
  bool get isUploading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateEventState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateEventStateCopyWith<CreateEventState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateEventStateCopyWith<$Res> {
  factory $CreateEventStateCopyWith(
    CreateEventState value,
    $Res Function(CreateEventState) then,
  ) = _$CreateEventStateCopyWithImpl<$Res, CreateEventState>;
  @useResult
  $Res call({
    String name,
    String message,
    bool isDurationMode,
    int durationHours,
    int durationMinutes,
    int durationSeconds,
    DateTime? targetDate,
    List<Map<String, String>> selectedContacts,
    List<FileModel> uploadedFiles,
    bool isUploading,
    bool isSubmitting,
    String? error,
  });
}

/// @nodoc
class _$CreateEventStateCopyWithImpl<$Res, $Val extends CreateEventState>
    implements $CreateEventStateCopyWith<$Res> {
  _$CreateEventStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateEventState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? message = null,
    Object? isDurationMode = null,
    Object? durationHours = null,
    Object? durationMinutes = null,
    Object? durationSeconds = null,
    Object? targetDate = freezed,
    Object? selectedContacts = null,
    Object? uploadedFiles = null,
    Object? isUploading = null,
    Object? isSubmitting = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            isDurationMode: null == isDurationMode
                ? _value.isDurationMode
                : isDurationMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            durationHours: null == durationHours
                ? _value.durationHours
                : durationHours // ignore: cast_nullable_to_non_nullable
                      as int,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            durationSeconds: null == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            targetDate: freezed == targetDate
                ? _value.targetDate
                : targetDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            selectedContacts: null == selectedContacts
                ? _value.selectedContacts
                : selectedContacts // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, String>>,
            uploadedFiles: null == uploadedFiles
                ? _value.uploadedFiles
                : uploadedFiles // ignore: cast_nullable_to_non_nullable
                      as List<FileModel>,
            isUploading: null == isUploading
                ? _value.isUploading
                : isUploading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateEventStateImplCopyWith<$Res>
    implements $CreateEventStateCopyWith<$Res> {
  factory _$$CreateEventStateImplCopyWith(
    _$CreateEventStateImpl value,
    $Res Function(_$CreateEventStateImpl) then,
  ) = __$$CreateEventStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String message,
    bool isDurationMode,
    int durationHours,
    int durationMinutes,
    int durationSeconds,
    DateTime? targetDate,
    List<Map<String, String>> selectedContacts,
    List<FileModel> uploadedFiles,
    bool isUploading,
    bool isSubmitting,
    String? error,
  });
}

/// @nodoc
class __$$CreateEventStateImplCopyWithImpl<$Res>
    extends _$CreateEventStateCopyWithImpl<$Res, _$CreateEventStateImpl>
    implements _$$CreateEventStateImplCopyWith<$Res> {
  __$$CreateEventStateImplCopyWithImpl(
    _$CreateEventStateImpl _value,
    $Res Function(_$CreateEventStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateEventState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? message = null,
    Object? isDurationMode = null,
    Object? durationHours = null,
    Object? durationMinutes = null,
    Object? durationSeconds = null,
    Object? targetDate = freezed,
    Object? selectedContacts = null,
    Object? uploadedFiles = null,
    Object? isUploading = null,
    Object? isSubmitting = null,
    Object? error = freezed,
  }) {
    return _then(
      _$CreateEventStateImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        isDurationMode: null == isDurationMode
            ? _value.isDurationMode
            : isDurationMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        durationHours: null == durationHours
            ? _value.durationHours
            : durationHours // ignore: cast_nullable_to_non_nullable
                  as int,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        durationSeconds: null == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        targetDate: freezed == targetDate
            ? _value.targetDate
            : targetDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        selectedContacts: null == selectedContacts
            ? _value._selectedContacts
            : selectedContacts // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, String>>,
        uploadedFiles: null == uploadedFiles
            ? _value._uploadedFiles
            : uploadedFiles // ignore: cast_nullable_to_non_nullable
                  as List<FileModel>,
        isUploading: null == isUploading
            ? _value.isUploading
            : isUploading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CreateEventStateImpl implements _CreateEventState {
  const _$CreateEventStateImpl({
    this.name = '',
    this.message = '',
    this.isDurationMode = true,
    this.durationHours = 0,
    this.durationMinutes = 0,
    this.durationSeconds = 0,
    this.targetDate,
    final List<Map<String, String>> selectedContacts = const [],
    final List<FileModel> uploadedFiles = const [],
    this.isUploading = false,
    this.isSubmitting = false,
    this.error,
  }) : _selectedContacts = selectedContacts,
       _uploadedFiles = uploadedFiles;

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String message;
  // Timer
  @override
  @JsonKey()
  final bool isDurationMode;
  @override
  @JsonKey()
  final int durationHours;
  @override
  @JsonKey()
  final int durationMinutes;
  @override
  @JsonKey()
  final int durationSeconds;
  @override
  final DateTime? targetDate;
  // Contacts
  final List<Map<String, String>> _selectedContacts;
  // Contacts
  @override
  @JsonKey()
  List<Map<String, String>> get selectedContacts {
    if (_selectedContacts is EqualUnmodifiableListView)
      return _selectedContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedContacts);
  }

  // {email, name}
  // Files
  final List<FileModel> _uploadedFiles;
  // {email, name}
  // Files
  @override
  @JsonKey()
  List<FileModel> get uploadedFiles {
    if (_uploadedFiles is EqualUnmodifiableListView) return _uploadedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_uploadedFiles);
  }

  @override
  @JsonKey()
  final bool isUploading;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? error;

  @override
  String toString() {
    return 'CreateEventState(name: $name, message: $message, isDurationMode: $isDurationMode, durationHours: $durationHours, durationMinutes: $durationMinutes, durationSeconds: $durationSeconds, targetDate: $targetDate, selectedContacts: $selectedContacts, uploadedFiles: $uploadedFiles, isUploading: $isUploading, isSubmitting: $isSubmitting, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateEventStateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isDurationMode, isDurationMode) ||
                other.isDurationMode == isDurationMode) &&
            (identical(other.durationHours, durationHours) ||
                other.durationHours == durationHours) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            const DeepCollectionEquality().equals(
              other._selectedContacts,
              _selectedContacts,
            ) &&
            const DeepCollectionEquality().equals(
              other._uploadedFiles,
              _uploadedFiles,
            ) &&
            (identical(other.isUploading, isUploading) ||
                other.isUploading == isUploading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    message,
    isDurationMode,
    durationHours,
    durationMinutes,
    durationSeconds,
    targetDate,
    const DeepCollectionEquality().hash(_selectedContacts),
    const DeepCollectionEquality().hash(_uploadedFiles),
    isUploading,
    isSubmitting,
    error,
  );

  /// Create a copy of CreateEventState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateEventStateImplCopyWith<_$CreateEventStateImpl> get copyWith =>
      __$$CreateEventStateImplCopyWithImpl<_$CreateEventStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateEventState implements CreateEventState {
  const factory _CreateEventState({
    final String name,
    final String message,
    final bool isDurationMode,
    final int durationHours,
    final int durationMinutes,
    final int durationSeconds,
    final DateTime? targetDate,
    final List<Map<String, String>> selectedContacts,
    final List<FileModel> uploadedFiles,
    final bool isUploading,
    final bool isSubmitting,
    final String? error,
  }) = _$CreateEventStateImpl;

  @override
  String get name;
  @override
  String get message; // Timer
  @override
  bool get isDurationMode;
  @override
  int get durationHours;
  @override
  int get durationMinutes;
  @override
  int get durationSeconds;
  @override
  DateTime? get targetDate; // Contacts
  @override
  List<Map<String, String>> get selectedContacts; // {email, name}
  // Files
  @override
  List<FileModel> get uploadedFiles;
  @override
  bool get isUploading;
  @override
  bool get isSubmitting;
  @override
  String? get error;

  /// Create a copy of CreateEventState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateEventStateImplCopyWith<_$CreateEventStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
