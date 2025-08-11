import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/attendance/domain/entities/notification_entity.dart';
import 'package:timesheet_project/features/attendance/domain/repositories/notification_repository.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

class CreateRequestNotificationUsecase
    implements UseCase<void, CreateRequestNotificationParams> {
  final NotificationRepository notificationRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CreateRequestNotificationUsecase(this.notificationRepository);

  @override
  Future<void> call(CreateRequestNotificationParams params) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    // Lấy thông tin người dùng hiện tại
    final currentUserDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();
    final currentUserData = currentUserDoc.data();
    if (currentUserData == null) {
      throw Exception('Không tìm thấy thông tin người dùng');
    }

    final currentUserName =
        '${currentUserData['firstName'] ?? ''} ${currentUserData['lastName'] ?? ''}'
            .trim();
    final currentUserAvatar = currentUserData['avatarUrl'] ?? '';

    // Xác định recipientId và title dựa trên action
    String recipientId;
    String title;

    if (params.action == NotificationAction.create) {
      // Khi tạo đơn: recipientId là idManager, title là "Đang có đơn cần chờ duyệt"
      recipientId = params.managerId;
      title = 'Đang có đơn cần chờ duyệt';
    } else {
      // Khi duyệt đơn: recipientId là idUser, title là "Đơn của bạn đã được duyệt"
      recipientId = params.userId;
      title = 'Đơn của bạn đã được duyệt';
    }

    // Tạo notification entity
    final notification = NotificationEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      requestId: params.requestId,
      requestType: params.requestType,
      status: params.status,
      senderId: currentUser.uid,
      senderName: currentUserName,
      senderAvatar: currentUserAvatar,
      recipientId: recipientId,
      title: title,
      createdAt: DateTime.now(),
    );

    await notificationRepository.createNotification(notification);
  }
}

class CreateRequestNotificationParams {
  final String requestId;
  final RequestType requestType; // 'leave', 'overtime', 'attendance', 'worklog'
  final RequestStatus status; // 'pending', 'approved', 'rejected', 'cancelled'
  final String userId;
  final String managerId;
  final NotificationAction action;

  CreateRequestNotificationParams({
    required this.requestId,
    required this.requestType,
    required this.status,
    required this.userId,
    required this.managerId,
    required this.action,
  });
}

enum NotificationAction {
  create, // Khi tạo đơn mới
  approve, // Khi duyệt đơn
}
