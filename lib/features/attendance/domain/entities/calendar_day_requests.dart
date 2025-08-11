import 'package:timesheet_project/core/enums/request_enums.dart';

class CalendarDayRequests {
  final List<Map<String, dynamic>> leaveRequests;
  final List<Map<String, dynamic>> overtimeRequests;
  final List<Map<String, dynamic>> attendanceAdjustments;
  final List<Map<String, dynamic>> workLogs;

  CalendarDayRequests({
    List<Map<String, dynamic>>? leaveRequests,
    List<Map<String, dynamic>>? overtimeRequests,
    List<Map<String, dynamic>>? attendanceAdjustments,
    List<Map<String, dynamic>>? workLogs,
  })  : leaveRequests = leaveRequests ?? [],
        overtimeRequests = overtimeRequests ?? [],
        attendanceAdjustments = attendanceAdjustments ?? [],
        workLogs = workLogs ?? [];

  void addRequest(String type, Map<String, dynamic> data) {
    switch (type.toRequestType()) {
      case RequestType.leave:
        leaveRequests.add(data);
        break;
      case RequestType.overtime:
        overtimeRequests.add(data);
        break;
      case RequestType.attendance:
        attendanceAdjustments.add(data);
        break;
      case RequestType.worklog:
        workLogs.add(data);
        break;
    }
  }
}
