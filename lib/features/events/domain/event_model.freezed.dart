// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_ms')
  int get durationMs => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'checked_in')
  bool get checkedIn => throw _privateConstructorUsedError;
  bool get terminated => throw _privateConstructorUsedError;
  bool get fired => throw _privateConstructorUsedError;
  List<EventContact> get contacts => throw _privateConstructorUsedError;
  List<FileModel> get attachments => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String name,
    String? message,
    @JsonKey(name: 'duration_ms') int durationMs,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
    @JsonKey(name: 'checked_in') bool checkedIn,
    bool terminated,
    bool fired,
    List<EventContact> contacts,
    List<FileModel> attachments,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? message = freezed,
    Object? durationMs = null,
    Object? expiresAt = null,
    Object? checkedIn = null,
    Object? terminated = null,
    Object? fired = null,
    Object? contacts = null,
    Object? attachments = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationMs: null == durationMs
                ? _value.durationMs
                : durationMs // ignore: cast_nullable_to_non_nullable
                      as int,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            checkedIn: null == checkedIn
                ? _value.checkedIn
                : checkedIn // ignore: cast_nullable_to_non_nullable
                      as bool,
            terminated: null == terminated
                ? _value.terminated
                : terminated // ignore: cast_nullable_to_non_nullable
                      as bool,
            fired: null == fired
                ? _value.fired
                : fired // ignore: cast_nullable_to_non_nullable
                      as bool,
            contacts: null == contacts
                ? _value.contacts
                : contacts // ignore: cast_nullable_to_non_nullable
                      as List<EventContact>,
            attachments: null == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<FileModel>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
    _$EventImpl value,
    $Res Function(_$EventImpl) then,
  ) = __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String name,
    String? message,
    @JsonKey(name: 'duration_ms') int durationMs,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
    @JsonKey(name: 'checked_in') bool checkedIn,
    bool terminated,
    bool fired,
    List<EventContact> contacts,
    List<FileModel> attachments,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
    _$EventImpl _value,
    $Res Function(_$EventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? message = freezed,
    Object? durationMs = null,
    Object? expiresAt = null,
    Object? checkedIn = null,
    Object? terminated = null,
    Object? fired = null,
    Object? contacts = null,
    Object? attachments = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$EventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMs: null == durationMs
            ? _value.durationMs
            : durationMs // ignore: cast_nullable_to_non_nullable
                  as int,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        checkedIn: null == checkedIn
            ? _value.checkedIn
            : checkedIn // ignore: cast_nullable_to_non_nullable
                  as bool,
        terminated: null == terminated
            ? _value.terminated
            : terminated // ignore: cast_nullable_to_non_nullable
                  as bool,
        fired: null == fired
            ? _value.fired
            : fired // ignore: cast_nullable_to_non_nullable
                  as bool,
        contacts: null == contacts
            ? _value._contacts
            : contacts // ignore: cast_nullable_to_non_nullable
                  as List<EventContact>,
        attachments: null == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<FileModel>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImpl implements _Event {
  const _$EventImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.name,
    this.message,
    @JsonKey(name: 'duration_ms') required this.durationMs,
    @JsonKey(name: 'expires_at') required this.expiresAt,
    @JsonKey(name: 'checked_in') this.checkedIn = false,
    this.terminated = false,
    this.fired = false,
    final List<EventContact> contacts = const [],
    final List<FileModel> attachments = const [],
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _contacts = contacts,
       _attachments = attachments;

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  final String? message;
  @override
  @JsonKey(name: 'duration_ms')
  final int durationMs;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;
  @override
  @JsonKey(name: 'checked_in')
  final bool checkedIn;
  @override
  @JsonKey()
  final bool terminated;
  @override
  @JsonKey()
  final bool fired;
  final List<EventContact> _contacts;
  @override
  @JsonKey()
  List<EventContact> get contacts {
    if (_contacts is EqualUnmodifiableListView) return _contacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contacts);
  }

  final List<FileModel> _attachments;
  @override
  @JsonKey()
  List<FileModel> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Event(id: $id, userId: $userId, name: $name, message: $message, durationMs: $durationMs, expiresAt: $expiresAt, checkedIn: $checkedIn, terminated: $terminated, fired: $fired, contacts: $contacts, attachments: $attachments, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.checkedIn, checkedIn) ||
                other.checkedIn == checkedIn) &&
            (identical(other.terminated, terminated) ||
                other.terminated == terminated) &&
            (identical(other.fired, fired) || other.fired == fired) &&
            const DeepCollectionEquality().equals(other._contacts, _contacts) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    name,
    message,
    durationMs,
    expiresAt,
    checkedIn,
    terminated,
    fired,
    const DeepCollectionEquality().hash(_contacts),
    const DeepCollectionEquality().hash(_attachments),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(this);
  }
}

abstract class _Event implements Event {
  const factory _Event({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    required final String name,
    final String? message,
    @JsonKey(name: 'duration_ms') required final int durationMs,
    @JsonKey(name: 'expires_at') required final DateTime expiresAt,
    @JsonKey(name: 'checked_in') final bool checkedIn,
    final bool terminated,
    final bool fired,
    final List<EventContact> contacts,
    final List<FileModel> attachments,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$EventImpl;

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  String? get message;
  @override
  @JsonKey(name: 'duration_ms')
  int get durationMs;
  @override
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;
  @override
  @JsonKey(name: 'checked_in')
  bool get checkedIn;
  @override
  bool get terminated;
  @override
  bool get fired;
  @override
  List<EventContact> get contacts;
  @override
  List<FileModel> get attachments;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventContact _$EventContactFromJson(Map<String, dynamic> json) {
  return _EventContact.fromJson(json);
}

/// @nodoc
mixin _$EventContact {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  String get eventId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this EventContact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventContactCopyWith<EventContact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventContactCopyWith<$Res> {
  factory $EventContactCopyWith(
    EventContact value,
    $Res Function(EventContact) then,
  ) = _$EventContactCopyWithImpl<$Res, EventContact>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'event_id') String eventId,
    String email,
    String? name,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$EventContactCopyWithImpl<$Res, $Val extends EventContact>
    implements $EventContactCopyWith<$Res> {
  _$EventContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? email = null,
    Object? name = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            eventId: null == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventContactImplCopyWith<$Res>
    implements $EventContactCopyWith<$Res> {
  factory _$$EventContactImplCopyWith(
    _$EventContactImpl value,
    $Res Function(_$EventContactImpl) then,
  ) = __$$EventContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'event_id') String eventId,
    String email,
    String? name,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$EventContactImplCopyWithImpl<$Res>
    extends _$EventContactCopyWithImpl<$Res, _$EventContactImpl>
    implements _$$EventContactImplCopyWith<$Res> {
  __$$EventContactImplCopyWithImpl(
    _$EventContactImpl _value,
    $Res Function(_$EventContactImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? email = null,
    Object? name = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$EventContactImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventContactImpl implements _EventContact {
  const _$EventContactImpl({
    required this.id,
    @JsonKey(name: 'event_id') required this.eventId,
    required this.email,
    this.name,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$EventContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventContactImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'event_id')
  final String eventId;
  @override
  final String email;
  @override
  final String? name;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'EventContact(id: $id, eventId: $eventId, email: $email, name: $name, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, eventId, email, name, createdAt);

  /// Create a copy of EventContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventContactImplCopyWith<_$EventContactImpl> get copyWith =>
      __$$EventContactImplCopyWithImpl<_$EventContactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventContactImplToJson(this);
  }
}

abstract class _EventContact implements EventContact {
  const factory _EventContact({
    required final String id,
    @JsonKey(name: 'event_id') required final String eventId,
    required final String email,
    final String? name,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$EventContactImpl;

  factory _EventContact.fromJson(Map<String, dynamic> json) =
      _$EventContactImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'event_id')
  String get eventId;
  @override
  String get email;
  @override
  String? get name;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of EventContact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventContactImplCopyWith<_$EventContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
