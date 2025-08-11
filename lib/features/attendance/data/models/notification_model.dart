import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheet_project/features/attendance/domain/entities/notification_entity.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';
import 'package:timesheet_project/core/converters/request_converters.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String requestId,
    @RequestTypeConverter() required RequestType requestType,
    @RequestStatusConverter() required RequestStatus status,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String recipientId,
    required String title,
    @TimestampConverter() required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}

extension NotificationModelToEntity on NotificationModel {
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      requestId: requestId,
      requestType: requestType,
      status: status,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      recipientId: recipientId,
      title: title,
      createdAt: createdAt,
    );
  }
}

extension NotificationEntityToModel on NotificationEntity {
  NotificationModel toModel() {
    return NotificationModel(
      id: id,
      requestId: requestId,
      requestType: requestType,
      status: status,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      recipientId: recipientId,
      title: title,
      createdAt: createdAt,
    );
  }
}
