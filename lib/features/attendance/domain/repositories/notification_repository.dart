import 'package:timesheet_project/features/attendance/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<void> createNotification(NotificationEntity notification);
  Future<List<NotificationEntity>> getNotificationsByRecipientId(
      String recipientId);
  Future<void> deleteNotification(String id);
}
