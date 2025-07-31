// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkLogModelImpl _$$WorkLogModelImplFromJson(Map<String, dynamic> json) =>
    _$WorkLogModelImpl(
      id: json['id'] as String,
      idUser: json['idUser'] as String,
      idManager: json['idManager'] as String,
      status: json['status'] as String,
      workDate: DateTime.parse(json['workDate'] as String),
      checkInTime: json['checkInTime'] as String,
      checkOutTime: json['checkOutTime'] as String,
      notes: json['notes'] as String?,
      activitiesLog: (json['activitiesLog'] as List<dynamic>)
          .map((e) => ActivityLogModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$WorkLogModelImplToJson(_$WorkLogModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idUser': instance.idUser,
      'idManager': instance.idManager,
      'status': instance.status,
      'workDate': instance.workDate.toIso8601String(),
      'checkInTime': instance.checkInTime,
      'checkOutTime': instance.checkOutTime,
      'notes': instance.notes,
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
