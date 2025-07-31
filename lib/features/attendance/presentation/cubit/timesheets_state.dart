import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/entities/attendance_adjustment_entity.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';

abstract class TimesheetsState {}

class TimesheetsInitial extends TimesheetsState {}

class TimesheetsLoading extends TimesheetsState {}

class TimesheetsLoaded extends TimesheetsState {
  final Map<DateTime, AttendanceDayStatus> dayStatusMap;
  final DateTime selectedMonth;
  final DateTime? selectedDay;
  final DayDetails? dayDetails;

  TimesheetsLoaded({
    required this.dayStatusMap,
    required this.selectedMonth,
    this.selectedDay,
    this.dayDetails,
  });

  TimesheetsLoaded copyWith({
    Map<DateTime, AttendanceDayStatus>? dayStatusMap,
    DateTime? selectedMonth,
    DateTime? selectedDay,
    DayDetails? dayDetails,
  }) {
    return TimesheetsLoaded(
      dayStatusMap: dayStatusMap ?? this.dayStatusMap,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
      dayDetails: dayDetails ?? this.dayDetails,
    );
  }
}

class TimesheetsError extends TimesheetsState {
  final String message;

  TimesheetsError(this.message);
}

class DayDetails {
  final DateTime date;
  final List<LeaveRequestEntity> leaveRequests;
  final List<AttendanceAdjustmentEntity> attendanceAdjustments;
  final List<OvertimeRequestEntity> overtimeRequests;
  final AttendanceDayStatus status;

  DayDetails({
    required this.date,
    required this.leaveRequests,
    required this.attendanceAdjustments,
    required this.overtimeRequests,
    required this.status,
  });

  bool get hasEvents {
    return leaveRequests.isNotEmpty ||
        attendanceAdjustments.isNotEmpty ||
        overtimeRequests.isNotEmpty;
  }
}

enum AttendanceDayStatus {
  normal, // Ngày bình thường/cuối tuần
  hasApprovedRequest, // Có đơn được duyệt (màu xanh lá) - như ảnh 1
  hasPendingRequest, // Có đơn đang chờ (màu cam) - như ảnh 2
  hasRejectedRequest, // Có đơn bị từ chối (màu đỏ)
  noData, // Ngày làm việc không có đơn (màu đỏ) - như ảnh 3
}
