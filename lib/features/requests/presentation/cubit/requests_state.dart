import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/entities/attendance_adjustment_entity.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';
import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';

abstract class RequestsState {}

class RequestsInitial extends RequestsState {}

class RequestsLoading extends RequestsState {}

class RequestsLoaded extends RequestsState {
  final List<LeaveRequestEntity> leaveRequests;
  final List<AttendanceAdjustmentEntity> attendanceAdjustments;
  final List<OvertimeRequestEntity> overtimeRequests;
  final List<WorkLogEntity> workLogs;
  final int totalCount;
  final String
      statusFilter; // 'all' | 'pending' | 'approved' | 'rejected' | 'cancelled'

  RequestsLoaded({
    required this.leaveRequests,
    required this.attendanceAdjustments,
    required this.overtimeRequests,
    required this.workLogs,
    required this.totalCount,
    this.statusFilter = 'all',
  });
}

class RequestsLoadedWithUserNames extends RequestsState {
  final List<LeaveRequestEntity> leaveRequests;
  final List<AttendanceAdjustmentEntity> attendanceAdjustments;
  final List<OvertimeRequestEntity> overtimeRequests;
  final List<WorkLogEntity> workLogs;
  final Map<String, String> userMap;
  final int totalCount;
  final String
      statusFilter; // 'all' | 'pending' | 'approved' | 'rejected' | 'cancelled'

  RequestsLoadedWithUserNames({
    required this.leaveRequests,
    required this.attendanceAdjustments,
    required this.overtimeRequests,
    required this.workLogs,
    required this.userMap,
    required this.totalCount,
    this.statusFilter = 'all',
  });
}

class RequestsError extends RequestsState {
  final String message;

  RequestsError(this.message);
}
