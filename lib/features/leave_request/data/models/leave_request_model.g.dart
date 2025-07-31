// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveRequestModelImpl _$$LeaveRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$LeaveRequestModelImpl(
  id: json['id'] as String,
  idUser: json['idUser'] as String,
  idManager: json['idManager'] as String,
  status: json['status'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  reason: json['reason'] as String,
  activitiesLog: (json['activitiesLog'] as List<dynamic>)
      .map((e) => ActivityLogModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$LeaveRequestModelImplToJson(
  _$LeaveRequestModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'idUser': instance.idUser,
  'idManager': instance.idManager,
  'status': instance.status,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'startTime': instance.startTime,
  'endTime': instance.endTime,
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
