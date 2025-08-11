// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      requestType:
          const RequestTypeConverter().fromJson(json['requestType'] as String),
      status: const RequestStatusConverter().fromJson(json['status'] as String),
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String,
      recipientId: json['recipientId'] as String,
      title: json['title'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'requestType': const RequestTypeConverter().toJson(instance.requestType),
      'status': const RequestStatusConverter().toJson(instance.status),
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAvatar': instance.senderAvatar,
      'recipientId': instance.recipientId,
      'title': instance.title,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
