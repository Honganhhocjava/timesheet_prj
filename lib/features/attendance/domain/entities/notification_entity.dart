import 'package:timesheet_project/features/requests/presentation/pages/created_by_me_page.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

class NotificationEntity {
  final String id;
  final String requestId; //id request
  final RequestType requestType; // 'leave', 'overtime', 'attendance', 'worklog'
  final RequestStatus status; // 'pending', 'approved', 'rejected', 'cancelled'
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String recipientId;
  final String title;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.requestId,
    required this.requestType,
    required this.status,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.recipientId,
    required this.title,
    required this.createdAt,
  });

  String getDisplayTitle() {
    switch (requestType) {
      case RequestType.leave:
        return 'Đơn nghỉ phép';
      case RequestType.overtime:
        return 'Đơn làm thêm giờ';
      case RequestType.attendance:
        return 'Đơn điều chỉnh chấm công';
      case RequestType.worklog:
        return 'Đơn chấm công làm việc từ xa';
    }
  }
}

// Extension để convert NotificationEntity sang RequestItem
extension NotificationEntityToRequestItem on NotificationEntity {
  RequestItem toRequestItem() {
    return RequestItem(
      id: requestId,
      userName: senderName,
      reason: '', // Không có reason trong notification
      status: status.toStringValue(),
      createdAt: createdAt,
      requestType: requestType.toStringValue(),
      startDate: null, // Không có trong notification
      endDate: null, // Không có trong notification
      adjustmentDate: null, // Không có trong notification
      overtimeDate: null, // Không có trong notification
    );
  }
}
