import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/features/leave_request/domain/repositories/leave_request_repository.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/repositories/attendance_adjustment_repository.dart';
import 'package:timesheet_project/features/overtime_request/domain/repositories/overtime_request_repository.dart';
import 'package:timesheet_project/features/attendance/presentation/cubit/timesheets_state.dart';

class TimesheetsCubit extends Cubit<TimesheetsState> {
  final LeaveRequestRepository _leaveRequestRepository;
  final AttendanceAdjustmentRepository _attendanceAdjustmentRepository;
  final OvertimeRequestRepository _overtimeRequestRepository;

  TimesheetsCubit(
    this._leaveRequestRepository,
    this._attendanceAdjustmentRepository,
    this._overtimeRequestRepository,
  ) : super(TimesheetsInitial());

  Future<void> loadMonthlyData(DateTime month) async {
    emit(TimesheetsLoading());

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(TimesheetsError('Người dùng chưa đăng nhập'));
        return;
      }

      // Load all requests from form collections only
      final leaveRequests = await _leaveRequestRepository
          .getLeaveRequestsByUser(currentUser.uid);
      final attendanceAdjustments = await _attendanceAdjustmentRepository
          .getAttendanceAdjustmentsByUser(currentUser.uid);
      final overtimeRequests = await _overtimeRequestRepository
          .getOvertimeRequestsByUser(currentUser.uid);

      // Filter requests by month
      final monthlyLeaveRequests = leaveRequests.where((req) {
        return _isDateInMonth(req.startDate, month) ||
            _isDateInMonth(req.endDate, month);
      }).toList();

      final monthlyAttendanceAdjustments = attendanceAdjustments.where((adj) {
        return _isDateInMonth(adj.adjustmentDate, month);
      }).toList();

      final monthlyOvertimeRequests = overtimeRequests.where((req) {
        return _isDateInMonth(req.overtimeDate, month);
      }).toList();

      // Analyze each day based on forms only
      final dayStatusMap = <DateTime, AttendanceDayStatus>{};
      final endDate = DateTime(month.year, month.month + 1, 0);

      for (int day = 1; day <= endDate.day; day++) {
        final currentDate = DateTime(month.year, month.month, day);

        final status = _analyzeDayStatusFromForms(
          currentDate,
          monthlyLeaveRequests,
          monthlyAttendanceAdjustments,
          monthlyOvertimeRequests,
        );

        dayStatusMap[currentDate] = status;
      }

      emit(TimesheetsLoaded(dayStatusMap: dayStatusMap, selectedMonth: month));
    } catch (e) {
      emit(TimesheetsError('Lỗi khi tải dữ liệu: $e'));
    }
  }

  Future<void> selectDay(DateTime day) async {
    if (state is! TimesheetsLoaded) return;

    final currentState = state as TimesheetsLoaded;

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Load all requests for this specific day
      final allLeaveRequests = await _leaveRequestRepository
          .getLeaveRequestsByUser(currentUser.uid);
      final allAttendanceAdjustments = await _attendanceAdjustmentRepository
          .getAttendanceAdjustmentsByUser(currentUser.uid);
      final allOvertimeRequests = await _overtimeRequestRepository
          .getOvertimeRequestsByUser(currentUser.uid);

      // Filter requests for the selected day
      final dayLeaveRequests = allLeaveRequests.where((req) {
        return _isDateInRange(day, req.startDate, req.endDate);
      }).toList();

      final dayAttendanceAdjustments = allAttendanceAdjustments.where((adj) {
        return _isSameDay(adj.adjustmentDate, day);
      }).toList();

      final dayOvertimeRequests = allOvertimeRequests.where((req) {
        return _isSameDay(req.overtimeDate, day);
      }).toList();

      final dayStatus =
          currentState.dayStatusMap[day] ?? AttendanceDayStatus.normal;

      final dayDetails = DayDetails(
        date: day,
        leaveRequests: dayLeaveRequests.cast(),
        attendanceAdjustments: dayAttendanceAdjustments.cast(),
        overtimeRequests: dayOvertimeRequests.cast(),
        status: dayStatus,
      );

      emit(currentState.copyWith(selectedDay: day, dayDetails: dayDetails));
    } catch (e) {
      debugPrint('Lỗi khi tải chi tiết ngày: $e');
    }
  }

  void changeMonth(DateTime newMonth) {
    loadMonthlyData(newMonth);
  }

  // New logic - analyze day status based on forms only
  AttendanceDayStatus _analyzeDayStatusFromForms(
    DateTime date,
    List leaveRequests,
    List attendanceAdjustments,
    List overtimeRequests,
  ) {
    // Weekend always normal
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return AttendanceDayStatus.normal;
    }

    // Check for any requests covering this date
    bool hasLeaveRequest = leaveRequests.any(
      (req) => _isDateInRange(date, req.startDate, req.endDate),
    );

    bool hasAttendanceAdjustment = attendanceAdjustments.any(
      (adj) => _isSameDay(adj.adjustmentDate, date),
    );

    bool hasOvertimeRequest = overtimeRequests.any(
      (req) => _isSameDay(req.overtimeDate, date),
    );

    // If has any requests
    if (hasLeaveRequest || hasAttendanceAdjustment || hasOvertimeRequest) {
      // Check if any request is approved
      bool hasApproved =
          leaveRequests.any(
            (req) =>
                _isApproved(req.status) &&
                _isDateInRange(date, req.startDate, req.endDate),
          ) ||
          attendanceAdjustments.any(
            (adj) =>
                _isApproved(adj.status) && _isSameDay(adj.adjustmentDate, date),
          ) ||
          overtimeRequests.any(
            (req) =>
                _isApproved(req.status) && _isSameDay(req.overtimeDate, date),
          );

      // Check if any request is rejected
      bool hasRejected =
          leaveRequests.any(
            (req) =>
                _isRejected(req.status) &&
                _isDateInRange(date, req.startDate, req.endDate),
          ) ||
          attendanceAdjustments.any(
            (adj) =>
                _isRejected(adj.status) && _isSameDay(adj.adjustmentDate, date),
          ) ||
          overtimeRequests.any(
            (req) =>
                _isRejected(req.status) && _isSameDay(req.overtimeDate, date),
          );

      // Check if any request is pending
      bool hasPending =
          leaveRequests.any(
            (req) =>
                _isPending(req.status) &&
                _isDateInRange(date, req.startDate, req.endDate),
          ) ||
          attendanceAdjustments.any(
            (adj) =>
                _isPending(adj.status) && _isSameDay(adj.adjustmentDate, date),
          ) ||
          overtimeRequests.any(
            (req) =>
                _isPending(req.status) && _isSameDay(req.overtimeDate, date),
          );

      // Priority: Rejected > Approved > Pending
      if (hasRejected) {
        return AttendanceDayStatus.hasRejectedRequest;
      } else if (hasApproved) {
        return AttendanceDayStatus.hasApprovedRequest;
      } else if (hasPending) {
        return AttendanceDayStatus.hasPendingRequest;
      }
    }

    // Weekday with no requests - might need attention
    return AttendanceDayStatus.noData; // Red - needs action
  }

  bool _isApproved(dynamic status) {
    return status.toString().toLowerCase().contains('approved');
  }

  bool _isRejected(dynamic status) {
    return status.toString().toLowerCase().contains('rejected');
  }

  bool _isPending(dynamic status) {
    return status.toString().toLowerCase().contains('pending');
  }

  bool _isDateInMonth(DateTime date, DateTime month) {
    return date.year == month.year && date.month == month.month;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isDateInRange(DateTime date, DateTime startDate, DateTime endDate) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(startDate.year, startDate.month, startDate.day);
    final endOnly = DateTime(endDate.year, endDate.month, endDate.day);

    return (dateOnly.isAfter(startOnly) ||
            dateOnly.isAtSameMomentAs(startOnly)) &&
        (dateOnly.isBefore(endOnly) || dateOnly.isAtSameMomentAs(endOnly));
  }
}
