import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_project/features/attendance/data/models/notification_model.dart';
import 'package:timesheet_project/features/attendance/domain/entities/notification_entity.dart';
import 'package:timesheet_project/features/attendance/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createNotification(NotificationEntity notification) async {
    try {
      final notificationModel = notification.toModel();
      final notificationJson = notificationModel.toJson();

      await _firestore
          .collection('notifications')
          .doc(notification.id)
          .set(notificationJson);
    } catch (e) {
      throw Exception('Lỗi khi tạo thông báo: $e');
    }
  }

  @override
  Future<List<NotificationEntity>> getNotificationsByRecipientId(
      String recipientId) async {
    try {
      final querySnapshot = await _firestore
          .collection('notifications')
          .where('recipientId', isEqualTo: recipientId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách thông báo: $e');
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      await _firestore.collection('notifications').doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa thông báo: $e');
    }
  }
}
