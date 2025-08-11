// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkLogModel _$WorkLogModelFromJson(Map<String, dynamic> json) {
  return _WorkLogModel.fromJson(json);
}

/// @nodoc
mixin _$WorkLogModel {
  String get id => throw _privateConstructorUsedError;
  String get idUser => throw _privateConstructorUsedError;
  String get idManager => throw _privateConstructorUsedError;
  @RequestStatusConverter()
  RequestStatus get status => throw _privateConstructorUsedError;
  DateTime get workDate => throw _privateConstructorUsedError;
  String get checkInTime => throw _privateConstructorUsedError;
  String get checkOutTime => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<ActivityLogModel> get activitiesLog =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this WorkLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkLogModelCopyWith<WorkLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkLogModelCopyWith<$Res> {
  factory $WorkLogModelCopyWith(
          WorkLogModel value, $Res Function(WorkLogModel) then) =
      _$WorkLogModelCopyWithImpl<$Res, WorkLogModel>;
  @useResult
  $Res call(
      {String id,
      String idUser,
      String idManager,
      @RequestStatusConverter() RequestStatus status,
      DateTime workDate,
      String checkInTime,
      String checkOutTime,
      String? notes,
      List<ActivityLogModel> activitiesLog,
      DateTime createdAt});
}

/// @nodoc
class _$WorkLogModelCopyWithImpl<$Res, $Val extends WorkLogModel>
    implements $WorkLogModelCopyWith<$Res> {
  _$WorkLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idUser = null,
    Object? idManager = null,
    Object? status = null,
    Object? workDate = null,
    Object? checkInTime = null,
    Object? checkOutTime = null,
    Object? notes = freezed,
    Object? activitiesLog = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      idUser: null == idUser
          ? _value.idUser
          : idUser // ignore: cast_nullable_to_non_nullable
              as String,
      idManager: null == idManager
          ? _value.idManager
          : idManager // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RequestStatus,
      workDate: null == workDate
          ? _value.workDate
          : workDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      checkInTime: null == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as String,
      checkOutTime: null == checkOutTime
          ? _value.checkOutTime
          : checkOutTime // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      activitiesLog: null == activitiesLog
          ? _value.activitiesLog
          : activitiesLog // ignore: cast_nullable_to_non_nullable
              as List<ActivityLogModel>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkLogModelImplCopyWith<$Res>
    implements $WorkLogModelCopyWith<$Res> {
  factory _$$WorkLogModelImplCopyWith(
          _$WorkLogModelImpl value, $Res Function(_$WorkLogModelImpl) then) =
      __$$WorkLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String idUser,
      String idManager,
      @RequestStatusConverter() RequestStatus status,
      DateTime workDate,
      String checkInTime,
      String checkOutTime,
      String? notes,
      List<ActivityLogModel> activitiesLog,
      DateTime createdAt});
}

/// @nodoc
class __$$WorkLogModelImplCopyWithImpl<$Res>
    extends _$WorkLogModelCopyWithImpl<$Res, _$WorkLogModelImpl>
    implements _$$WorkLogModelImplCopyWith<$Res> {
  __$$WorkLogModelImplCopyWithImpl(
      _$WorkLogModelImpl _value, $Res Function(_$WorkLogModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idUser = null,
    Object? idManager = null,
    Object? status = null,
    Object? workDate = null,
    Object? checkInTime = null,
    Object? checkOutTime = null,
    Object? notes = freezed,
    Object? activitiesLog = null,
    Object? createdAt = null,
  }) {
    return _then(_$WorkLogModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      idUser: null == idUser
          ? _value.idUser
          : idUser // ignore: cast_nullable_to_non_nullable
              as String,
      idManager: null == idManager
          ? _value.idManager
          : idManager // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RequestStatus,
      workDate: null == workDate
          ? _value.workDate
          : workDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      checkInTime: null == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as String,
      checkOutTime: null == checkOutTime
          ? _value.checkOutTime
          : checkOutTime // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      activitiesLog: null == activitiesLog
          ? _value._activitiesLog
          : activitiesLog // ignore: cast_nullable_to_non_nullable
              as List<ActivityLogModel>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkLogModelImpl implements _WorkLogModel {
  const _$WorkLogModelImpl(
      {required this.id,
      required this.idUser,
      required this.idManager,
      @RequestStatusConverter() required this.status,
      required this.workDate,
      required this.checkInTime,
      required this.checkOutTime,
      this.notes,
      required final List<ActivityLogModel> activitiesLog,
      required this.createdAt})
      : _activitiesLog = activitiesLog;

  factory _$WorkLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkLogModelImplFromJson(json);

  @override
  final String id;
  @override
  final String idUser;
  @override
  final String idManager;
  @override
  @RequestStatusConverter()
  final RequestStatus status;
  @override
  final DateTime workDate;
  @override
  final String checkInTime;
  @override
  final String checkOutTime;
  @override
  final String? notes;
  final List<ActivityLogModel> _activitiesLog;
  @override
  List<ActivityLogModel> get activitiesLog {
    if (_activitiesLog is EqualUnmodifiableListView) return _activitiesLog;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activitiesLog);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'WorkLogModel(id: $id, idUser: $idUser, idManager: $idManager, status: $status, workDate: $workDate, checkInTime: $checkInTime, checkOutTime: $checkOutTime, notes: $notes, activitiesLog: $activitiesLog, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idUser, idUser) || other.idUser == idUser) &&
            (identical(other.idManager, idManager) ||
                other.idManager == idManager) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.workDate, workDate) ||
                other.workDate == workDate) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._activitiesLog, _activitiesLog) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      idUser,
      idManager,
      status,
      workDate,
      checkInTime,
      checkOutTime,
      notes,
      const DeepCollectionEquality().hash(_activitiesLog),
      createdAt);

  /// Create a copy of WorkLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkLogModelImplCopyWith<_$WorkLogModelImpl> get copyWith =>
      __$$WorkLogModelImplCopyWithImpl<_$WorkLogModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkLogModelImplToJson(
      this,
    );
  }
}

abstract class _WorkLogModel implements WorkLogModel {
  const factory _WorkLogModel(
      {required final String id,
      required final String idUser,
      required final String idManager,
      @RequestStatusConverter() required final RequestStatus status,
      required final DateTime workDate,
      required final String checkInTime,
      required final String checkOutTime,
      final String? notes,
      required final List<ActivityLogModel> activitiesLog,
      required final DateTime createdAt}) = _$WorkLogModelImpl;

  factory _WorkLogModel.fromJson(Map<String, dynamic> json) =
      _$WorkLogModelImpl.fromJson;

  @override
  String get id;
  @override
  String get idUser;
  @override
  String get idManager;
  @override
  @RequestStatusConverter()
  RequestStatus get status;
  @override
  DateTime get workDate;
  @override
  String get checkInTime;
  @override
  String get checkOutTime;
  @override
  String? get notes;
  @override
  List<ActivityLogModel> get activitiesLog;
  @override
  DateTime get createdAt;

  /// Create a copy of WorkLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkLogModelImplCopyWith<_$WorkLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityLogModel _$ActivityLogModelFromJson(Map<String, dynamic> json) {
  return _ActivityLogModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityLogModel {
  String get id => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userRole => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  /// Serializes this ActivityLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogModelCopyWith<ActivityLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogModelCopyWith<$Res> {
  factory $ActivityLogModelCopyWith(
          ActivityLogModel value, $Res Function(ActivityLogModel) then) =
      _$ActivityLogModelCopyWithImpl<$Res, ActivityLogModel>;
  @useResult
  $Res call(
      {String id,
      String action,
      String userId,
      String userRole,
      DateTime timestamp,
      String? comment});
}

/// @nodoc
class _$ActivityLogModelCopyWithImpl<$Res, $Val extends ActivityLogModel>
    implements $ActivityLogModelCopyWith<$Res> {
  _$ActivityLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? userId = null,
    Object? userRole = null,
    Object? timestamp = null,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userRole: null == userRole
          ? _value.userRole
          : userRole // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityLogModelImplCopyWith<$Res>
    implements $ActivityLogModelCopyWith<$Res> {
  factory _$$ActivityLogModelImplCopyWith(_$ActivityLogModelImpl value,
          $Res Function(_$ActivityLogModelImpl) then) =
      __$$ActivityLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String action,
      String userId,
      String userRole,
      DateTime timestamp,
      String? comment});
}

/// @nodoc
class __$$ActivityLogModelImplCopyWithImpl<$Res>
    extends _$ActivityLogModelCopyWithImpl<$Res, _$ActivityLogModelImpl>
    implements _$$ActivityLogModelImplCopyWith<$Res> {
  __$$ActivityLogModelImplCopyWithImpl(_$ActivityLogModelImpl _value,
      $Res Function(_$ActivityLogModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? userId = null,
    Object? userRole = null,
    Object? timestamp = null,
    Object? comment = freezed,
  }) {
    return _then(_$ActivityLogModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userRole: null == userRole
          ? _value.userRole
          : userRole // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityLogModelImpl implements _ActivityLogModel {
  const _$ActivityLogModelImpl(
      {required this.id,
      required this.action,
      required this.userId,
      required this.userRole,
      required this.timestamp,
      this.comment});

  factory _$ActivityLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogModelImplFromJson(json);

  @override
  final String id;
  @override
  final String action;
  @override
  final String userId;
  @override
  final String userRole;
  @override
  final DateTime timestamp;
  @override
  final String? comment;

  @override
  String toString() {
    return 'ActivityLogModel(id: $id, action: $action, userId: $userId, userRole: $userRole, timestamp: $timestamp, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userRole, userRole) ||
                other.userRole == userRole) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, action, userId, userRole, timestamp, comment);

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogModelImplCopyWith<_$ActivityLogModelImpl> get copyWith =>
      __$$ActivityLogModelImplCopyWithImpl<_$ActivityLogModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogModelImplToJson(
      this,
    );
  }
}

abstract class _ActivityLogModel implements ActivityLogModel {
  const factory _ActivityLogModel(
      {required final String id,
      required final String action,
      required final String userId,
      required final String userRole,
      required final DateTime timestamp,
      final String? comment}) = _$ActivityLogModelImpl;

  factory _ActivityLogModel.fromJson(Map<String, dynamic> json) =
      _$ActivityLogModelImpl.fromJson;

  @override
  String get id;
  @override
  String get action;
  @override
  String get userId;
  @override
  String get userRole;
  @override
  DateTime get timestamp;
  @override
  String? get comment;

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogModelImplCopyWith<_$ActivityLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
