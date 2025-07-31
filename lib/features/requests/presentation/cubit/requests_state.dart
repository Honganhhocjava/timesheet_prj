import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/entities/attendance_adjustment_entity.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';

abstract class RequestsState {}

class RequestsInitial extends RequestsState {}

class RequestsLoading extends RequestsState {}

class RequestsLoaded extends RequestsState {
  final List<LeaveRequestEntity> leaveRequests;
  final List<AttendanceAdjustmentEntity> attendanceAdjustments;
  final List<OvertimeRequestEntity> overtimeRequests;
  final int totalCount;

  RequestsLoaded({
    required this.leaveRequests,
    required this.attendanceAdjustments,
    required this.overtimeRequests,
    required this.totalCount,
  });
}

class RequestsLoadedWithUserNames extends RequestsState {
  final List<LeaveRequestEntity> leaveRequests;
  final List<AttendanceAdjustmentEntity> attendanceAdjustments;
  final List<OvertimeRequestEntity> overtimeRequests;
  final Map<String, String> userMap; // userId -> fullName
  final int totalCount;

  RequestsLoadedWithUserNames({
    required this.leaveRequests,
    required this.attendanceAdjustments,
    required this.overtimeRequests,
    required this.userMap,
    required this.totalCount,
  });
}

class RequestsError extends RequestsState {
  final String message;

  RequestsError(this.message);
}
