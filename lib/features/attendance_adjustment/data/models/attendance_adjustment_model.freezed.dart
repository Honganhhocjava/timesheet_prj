// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_adjustment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AttendanceAdjustmentModel _$AttendanceAdjustmentModelFromJson(
  Map<String, dynamic> json,
) {
  return _AttendanceAdjustmentModel.fromJson(json);
}

/// @nodoc
mixin _$AttendanceAdjustmentModel {
  String get id => throw _privateConstructorUsedError;
  String get idUser => throw _privateConstructorUsedError;
  String get idManager => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get adjustmentDate => throw _privateConstructorUsedError;
  String get originalCheckIn => throw _privateConstructorUsedError;
  String get originalCheckOut => throw _privateConstructorUsedError;
  String get adjustedCheckIn => throw _privateConstructorUsedError;
  String get adjustedCheckOut => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  List<ActivityLogModel> get activitiesLog =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AttendanceAdjustmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceAdjustmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceAdjustmentModelCopyWith<AttendanceAdjustmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceAdjustmentModelCopyWith<$Res> {
  factory $AttendanceAdjustmentModelCopyWith(
    AttendanceAdjustmentModel value,
    $Res Function(AttendanceAdjustmentModel) then,
  ) = _$AttendanceAdjustmentModelCopyWithImpl<$Res, AttendanceAdjustmentModel>;
  @useResult
  $Res call({
    String id,
    String idUser,
    String idManager,
    String status,
    DateTime adjustmentDate,
    String originalCheckIn,
    String originalCheckOut,
    String adjustedCheckIn,
    String adjustedCheckOut,
    String reason,
    List<ActivityLogModel> activitiesLog,
    DateTime createdAt,
  });
}

/// @nodoc
class _$AttendanceAdjustmentModelCopyWithImpl<
  $Res,
  $Val extends AttendanceAdjustmentModel
>
    implements $AttendanceAdjustmentModelCopyWith<$Res> {
  _$AttendanceAdjustmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceAdjustmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idUser = null,
    Object? idManager = null,
    Object? status = null,
    Object? adjustmentDate = null,
    Object? originalCheckIn = null,
    Object? originalCheckOut = null,
    Object? adjustedCheckIn = null,
    Object? adjustedCheckOut = null,
    Object? reason = null,
    Object? activitiesLog = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
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
                      as String,
            adjustmentDate: null == adjustmentDate
                ? _value.adjustmentDate
                : adjustmentDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            originalCheckIn: null == originalCheckIn
                ? _value.originalCheckIn
                : originalCheckIn // ignore: cast_nullable_to_non_nullable
                      as String,
            originalCheckOut: null == originalCheckOut
                ? _value.originalCheckOut
                : originalCheckOut // ignore: cast_nullable_to_non_nullable
                      as String,
            adjustedCheckIn: null == adjustedCheckIn
                ? _value.adjustedCheckIn
                : adjustedCheckIn // ignore: cast_nullable_to_non_nullable
                      as String,
            adjustedCheckOut: null == adjustedCheckOut
                ? _value.adjustedCheckOut
                : adjustedCheckOut // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttendanceAdjustmentModelImplCopyWith<$Res>
    implements $AttendanceAdjustmentModelCopyWith<$Res> {
  factory _$$AttendanceAdjustmentModelImplCopyWith(
    _$AttendanceAdjustmentModelImpl value,
    $Res Function(_$AttendanceAdjustmentModelImpl) then,
  ) = __$$AttendanceAdjustmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String idUser,
    String idManager,
    String status,
    DateTime adjustmentDate,
    String originalCheckIn,
    String originalCheckOut,
    String adjustedCheckIn,
    String adjustedCheckOut,
    String reason,
    List<ActivityLogModel> activitiesLog,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$AttendanceAdjustmentModelImplCopyWithImpl<$Res>
    extends
        _$AttendanceAdjustmentModelCopyWithImpl<
          $Res,
          _$AttendanceAdjustmentModelImpl
        >
    implements _$$AttendanceAdjustmentModelImplCopyWith<$Res> {
  __$$AttendanceAdjustmentModelImplCopyWithImpl(
    _$AttendanceAdjustmentModelImpl _value,
    $Res Function(_$AttendanceAdjustmentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttendanceAdjustmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idUser = null,
    Object? idManager = null,
    Object? status = null,
    Object? adjustmentDate = null,
    Object? originalCheckIn = null,
    Object? originalCheckOut = null,
    Object? adjustedCheckIn = null,
    Object? adjustedCheckOut = null,
    Object? reason = null,
    Object? activitiesLog = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$AttendanceAdjustmentModelImpl(
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
                  as String,
        adjustmentDate: null == adjustmentDate
            ? _value.adjustmentDate
            : adjustmentDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        originalCheckIn: null == originalCheckIn
            ? _value.originalCheckIn
            : originalCheckIn // ignore: cast_nullable_to_non_nullable
                  as String,
        originalCheckOut: null == originalCheckOut
            ? _value.originalCheckOut
            : originalCheckOut // ignore: cast_nullable_to_non_nullable
                  as String,
        adjustedCheckIn: null == adjustedCheckIn
            ? _value.adjustedCheckIn
            : adjustedCheckIn // ignore: cast_nullable_to_non_nullable
                  as String,
        adjustedCheckOut: null == adjustedCheckOut
            ? _value.adjustedCheckOut
            : adjustedCheckOut // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceAdjustmentModelImpl implements _AttendanceAdjustmentModel {
  const _$AttendanceAdjustmentModelImpl({
    required this.id,
    required this.idUser,
    required this.idManager,
    required this.status,
    required this.adjustmentDate,
    required this.originalCheckIn,
    required this.originalCheckOut,
    required this.adjustedCheckIn,
    required this.adjustedCheckOut,
    required this.reason,
    required final List<ActivityLogModel> activitiesLog,
    required this.createdAt,
  }) : _activitiesLog = activitiesLog;

  factory _$AttendanceAdjustmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceAdjustmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String idUser;
  @override
  final String idManager;
  @override
  final String status;
  @override
  final DateTime adjustmentDate;
  @override
  final String originalCheckIn;
  @override
  final String originalCheckOut;
  @override
  final String adjustedCheckIn;
  @override
  final String adjustedCheckOut;
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
    return 'AttendanceAdjustmentModel(id: $id, idUser: $idUser, idManager: $idManager, status: $status, adjustmentDate: $adjustmentDate, originalCheckIn: $originalCheckIn, originalCheckOut: $originalCheckOut, adjustedCheckIn: $adjustedCheckIn, adjustedCheckOut: $adjustedCheckOut, reason: $reason, activitiesLog: $activitiesLog, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceAdjustmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idUser, idUser) || other.idUser == idUser) &&
            (identical(other.idManager, idManager) ||
                other.idManager == idManager) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.adjustmentDate, adjustmentDate) ||
                other.adjustmentDate == adjustmentDate) &&
            (identical(other.originalCheckIn, originalCheckIn) ||
                other.originalCheckIn == originalCheckIn) &&
            (identical(other.originalCheckOut, originalCheckOut) ||
                other.originalCheckOut == originalCheckOut) &&
            (identical(other.adjustedCheckIn, adjustedCheckIn) ||
                other.adjustedCheckIn == adjustedCheckIn) &&
            (identical(other.adjustedCheckOut, adjustedCheckOut) ||
                other.adjustedCheckOut == adjustedCheckOut) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            const DeepCollectionEquality().equals(
              other._activitiesLog,
              _activitiesLog,
            ) &&
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
    adjustmentDate,
    originalCheckIn,
    originalCheckOut,
    adjustedCheckIn,
    adjustedCheckOut,
    reason,
    const DeepCollectionEquality().hash(_activitiesLog),
    createdAt,
  );

  /// Create a copy of AttendanceAdjustmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceAdjustmentModelImplCopyWith<_$AttendanceAdjustmentModelImpl>
  get copyWith =>
      __$$AttendanceAdjustmentModelImplCopyWithImpl<
        _$AttendanceAdjustmentModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceAdjustmentModelImplToJson(this);
  }
}

abstract class _AttendanceAdjustmentModel implements AttendanceAdjustmentModel {
  const factory _AttendanceAdjustmentModel({
    required final String id,
    required final String idUser,
    required final String idManager,
    required final String status,
    required final DateTime adjustmentDate,
    required final String originalCheckIn,
    required final String originalCheckOut,
    required final String adjustedCheckIn,
    required final String adjustedCheckOut,
    required final String reason,
    required final List<ActivityLogModel> activitiesLog,
    required final DateTime createdAt,
  }) = _$AttendanceAdjustmentModelImpl;

  factory _AttendanceAdjustmentModel.fromJson(Map<String, dynamic> json) =
      _$AttendanceAdjustmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get idUser;
  @override
  String get idManager;
  @override
  String get status;
  @override
  DateTime get adjustmentDate;
  @override
  String get originalCheckIn;
  @override
  String get originalCheckOut;
  @override
  String get adjustedCheckIn;
  @override
  String get adjustedCheckOut;
  @override
  String get reason;
  @override
  List<ActivityLogModel> get activitiesLog;
  @override
  DateTime get createdAt;

  /// Create a copy of AttendanceAdjustmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceAdjustmentModelImplCopyWith<_$AttendanceAdjustmentModelImpl>
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
    ActivityLogModel value,
    $Res Function(ActivityLogModel) then,
  ) = _$ActivityLogModelCopyWithImpl<$Res, ActivityLogModel>;
  @useResult
  $Res call({
    String id,
    String action,
    String userId,
    String userRole,
    DateTime timestamp,
    String? comment,
  });
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
    return _then(
      _value.copyWith(
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityLogModelImplCopyWith<$Res>
    implements $ActivityLogModelCopyWith<$Res> {
  factory _$$ActivityLogModelImplCopyWith(
    _$ActivityLogModelImpl value,
    $Res Function(_$ActivityLogModelImpl) then,
  ) = __$$ActivityLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String action,
    String userId,
    String userRole,
    DateTime timestamp,
    String? comment,
  });
}

/// @nodoc
class __$$ActivityLogModelImplCopyWithImpl<$Res>
    extends _$ActivityLogModelCopyWithImpl<$Res, _$ActivityLogModelImpl>
    implements _$$ActivityLogModelImplCopyWith<$Res> {
  __$$ActivityLogModelImplCopyWithImpl(
    _$ActivityLogModelImpl _value,
    $Res Function(_$ActivityLogModelImpl) _then,
  ) : super(_value, _then);

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
    return _then(
      _$ActivityLogModelImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityLogModelImpl implements _ActivityLogModel {
  const _$ActivityLogModelImpl({
    required this.id,
    required this.action,
    required this.userId,
    required this.userRole,
    required this.timestamp,
    this.comment,
  });

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
    runtimeType,
    id,
    action,
    userId,
    userRole,
    timestamp,
    comment,
  );

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogModelImplCopyWith<_$ActivityLogModelImpl> get copyWith =>
      __$$ActivityLogModelImplCopyWithImpl<_$ActivityLogModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogModelImplToJson(this);
  }
}

abstract class _ActivityLogModel implements ActivityLogModel {
  const factory _ActivityLogModel({
    required final String id,
    required final String action,
    required final String userId,
    required final String userRole,
    required final DateTime timestamp,
    final String? comment,
  }) = _$ActivityLogModelImpl;

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
