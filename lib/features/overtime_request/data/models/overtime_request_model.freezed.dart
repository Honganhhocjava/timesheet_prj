// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overtime_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OvertimeRequestModel _$OvertimeRequestModelFromJson(Map<String, dynamic> json) {
  return _OvertimeRequestModel.fromJson(json);
}

/// @nodoc
mixin _$OvertimeRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get idUser => throw _privateConstructorUsedError;
  String get idManager => throw _privateConstructorUsedError;
  @RequestStatusConverter()
  RequestStatus get status => throw _privateConstructorUsedError;
  DateTime get overtimeDate => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  List<ActivityLogModel> get activitiesLog =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this OvertimeRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OvertimeRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OvertimeRequestModelCopyWith<OvertimeRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OvertimeRequestModelCopyWith<$Res> {
  factory $OvertimeRequestModelCopyWith(OvertimeRequestModel value,
          $Res Function(OvertimeRequestModel) then) =
      _$OvertimeRequestModelCopyWithImpl<$Res, OvertimeRequestModel>;
  @useResult
  $Res call(
      {String id,
      String idUser,
      String idManager,
      @RequestStatusConverter() RequestStatus status,
      DateTime overtimeDate,
      String startTime,
      String endTime,
      String reason,
      List<ActivityLogModel> activitiesLog,
      DateTime createdAt});
}

/// @nodoc
class _$OvertimeRequestModelCopyWithImpl<$Res,
        $Val extends OvertimeRequestModel>
    implements $OvertimeRequestModelCopyWith<$Res> {
  _$OvertimeRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OvertimeRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idUser = null,
    Object? idManager = null,
    Object? status = null,
    Object? overtimeDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? reason = null,
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
      overtimeDate: null == overtimeDate
          ? _value.overtimeDate
          : overtimeDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$OvertimeRequestModelImplCopyWith<$Res>
    implements $OvertimeRequestModelCopyWith<$Res> {
  factory _$$OvertimeRequestModelImplCopyWith(_$OvertimeRequestModelImpl value,
          $Res Function(_$OvertimeRequestModelImpl) then) =
      __$$OvertimeRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String idUser,
      String idManager,
      @RequestStatusConverter() RequestStatus status,
      DateTime overtimeDate,
      String startTime,
      String endTime,
      String reason,
      List<ActivityLogModel> activitiesLog,
      DateTime createdAt});
}

/// @nodoc
class __$$OvertimeRequestModelImplCopyWithImpl<$Res>
    extends _$OvertimeRequestModelCopyWithImpl<$Res, _$OvertimeRequestModelImpl>
    implements _$$OvertimeRequestModelImplCopyWith<$Res> {
  __$$OvertimeRequestModelImplCopyWithImpl(_$OvertimeRequestModelImpl _value,
      $Res Function(_$OvertimeRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OvertimeRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idUser = null,
    Object? idManager = null,
    Object? status = null,
    Object? overtimeDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? reason = null,
    Object? activitiesLog = null,
    Object? createdAt = null,
  }) {
    return _then(_$OvertimeRequestModelImpl(
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
      overtimeDate: null == overtimeDate
          ? _value.overtimeDate
          : overtimeDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$OvertimeRequestModelImpl implements _OvertimeRequestModel {
  const _$OvertimeRequestModelImpl(
      {required this.id,
      required this.idUser,
      required this.idManager,
      @RequestStatusConverter() required this.status,
      required this.overtimeDate,
      required this.startTime,
      required this.endTime,
      required this.reason,
      required final List<ActivityLogModel> activitiesLog,
      required this.createdAt})
      : _activitiesLog = activitiesLog;

  factory _$OvertimeRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OvertimeRequestModelImplFromJson(json);

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
  final DateTime overtimeDate;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final String reason;
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
    return 'OvertimeRequestModel(id: $id, idUser: $idUser, idManager: $idManager, status: $status, overtimeDate: $overtimeDate, startTime: $startTime, endTime: $endTime, reason: $reason, activitiesLog: $activitiesLog, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OvertimeRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idUser, idUser) || other.idUser == idUser) &&
            (identical(other.idManager, idManager) ||
                other.idManager == idManager) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.overtimeDate, overtimeDate) ||
                other.overtimeDate == overtimeDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.reason, reason) || other.reason == reason) &&
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
      overtimeDate,
      startTime,
      endTime,
      reason,
      const DeepCollectionEquality().hash(_activitiesLog),
      createdAt);

  /// Create a copy of OvertimeRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OvertimeRequestModelImplCopyWith<_$OvertimeRequestModelImpl>
      get copyWith =>
          __$$OvertimeRequestModelImplCopyWithImpl<_$OvertimeRequestModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OvertimeRequestModelImplToJson(
      this,
    );
  }
}

abstract class _OvertimeRequestModel implements OvertimeRequestModel {
  const factory _OvertimeRequestModel(
      {required final String id,
      required final String idUser,
      required final String idManager,
      @RequestStatusConverter() required final RequestStatus status,
      required final DateTime overtimeDate,
      required final String startTime,
      required final String endTime,
      required final String reason,
      required final List<ActivityLogModel> activitiesLog,
      required final DateTime createdAt}) = _$OvertimeRequestModelImpl;

  factory _OvertimeRequestModel.fromJson(Map<String, dynamic> json) =
      _$OvertimeRequestModelImpl.fromJson;

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
  DateTime get overtimeDate;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  String get reason;
  @override
  List<ActivityLogModel> get activitiesLog;
  @override
  DateTime get createdAt;

  /// Create a copy of OvertimeRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OvertimeRequestModelImplCopyWith<_$OvertimeRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
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
