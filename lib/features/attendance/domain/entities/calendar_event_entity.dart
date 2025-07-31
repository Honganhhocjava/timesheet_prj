class CalendarEventEntity {
  final String id;
  final String requestId;
  final String requestType; // 'leave', 'overtime', 'attendance'
  final String status; // 'pending', 'approved', 'rejected', 'cancelled'
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
    switch (status.toLowerCase()) {
      case 'cancelled':
      case 'rejected':
        return '#FF0000'; // Red
      case 'approved':
        return '#00FF00'; // Green
      case 'pending':
        return '#FFA500'; // Orange
      default:
        return '#808080'; // Gray
    }
  }

  // Helper method to get display title
  String getDisplayTitle() {
    switch (requestType) {
      case 'leave':
        return 'Đơn nghỉ phép';
      case 'overtime':
        return 'Đơn làm thêm giờ';
      case 'attendance':
        return 'Đơn điều chỉnh chấm công';
      default:
        return 'Đơn';
    }
  }
}
