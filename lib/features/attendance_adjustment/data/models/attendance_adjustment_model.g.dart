// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_adjustment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceAdjustmentModelImpl _$$AttendanceAdjustmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$AttendanceAdjustmentModelImpl(
  id: json['id'] as String,
  idUser: json['idUser'] as String,
  idManager: json['idManager'] as String,
  status: json['status'] as String,
  adjustmentDate: DateTime.parse(json['adjustmentDate'] as String),
  originalCheckIn: json['originalCheckIn'] as String,
  originalCheckOut: json['originalCheckOut'] as String,
  adjustedCheckIn: json['adjustedCheckIn'] as String,
  adjustedCheckOut: json['adjustedCheckOut'] as String,
  reason: json['reason'] as String,
  activitiesLog: (json['activitiesLog'] as List<dynamic>)
      .map((e) => ActivityLogModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$AttendanceAdjustmentModelImplToJson(
  _$AttendanceAdjustmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'idUser': instance.idUser,
  'idManager': instance.idManager,
  'status': instance.status,
  'adjustmentDate': instance.adjustmentDate.toIso8601String(),
  'originalCheckIn': instance.originalCheckIn,
  'originalCheckOut': instance.originalCheckOut,
  'adjustedCheckIn': instance.adjustedCheckIn,
  'adjustedCheckOut': instance.adjustedCheckOut,
  'reason': instance.reason,
  'activitiesLog': instance.activitiesLog,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$ActivityLogModelImpl _$$ActivityLogModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityLogModelImpl(
  id: json['id'] as String,
  action: json['action'] as String,
  userId: json['userId'] as String,
  userRole: json['userRole'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$$ActivityLogModelImplToJson(
  _$ActivityLogModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'action': instance.action,
  'userId': instance.userId,
  'userRole': instance.userRole,
  'timestamp': instance.timestamp.toIso8601String(),
  'comment': instance.comment,
};
