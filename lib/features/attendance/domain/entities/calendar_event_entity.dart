import 'package:timesheet_project/core/enums/request_enums.dart';

class CalendarEventEntity {
  final String id;
  final String requestId;
  final RequestType requestType;
  final RequestStatus status;
  final DateTime date;
  final String title;
  final String reason;

  CalendarEventEntity({
    required this.id,
    required this.requestId,
    required this.requestType,
    required this.status,
    required this.date,
    required this.title,
    required this.reason,
  });

  // Helper method to get color based on status
  String getStatusColor() {
    switch (status) {
      case RequestStatus.cancelled:
      case RequestStatus.rejected:
        return '#FF0000'; // Red
      case RequestStatus.approved:
        return '#00FF00'; // Green
      case RequestStatus.pending:
        return '#FFA500'; // Orange
    }
  }

  // Helper method to get display title
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
