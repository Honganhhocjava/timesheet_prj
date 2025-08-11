import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/features/requests/presentation/cubit/requests_state.dart';
import 'package:timesheet_project/features/leave_request/domain/repositories/leave_request_repository.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/repositories/attendance_adjustment_repository.dart';
import 'package:timesheet_project/features/overtime_request/domain/repositories/overtime_request_repository.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';
import 'package:timesheet_project/features/work_log/domain/repositories/work_log_repository.dart';
import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';
import 'package:timesheet_project/features/user/domain/repositories/user_repository.dart';

class RequestsCubit extends Cubit<RequestsState> {
  final LeaveRequestRepository _leaveRequestRepository;
  final AttendanceAdjustmentRepository _attendanceAdjustmentRepository;
  final OvertimeRequestRepository _overtimeRequestRepository;
  final WorkLogRepository _workLogRepository;
  final UserRepository _userRepository;

  RequestsCubit(
    this._leaveRequestRepository,
    this._attendanceAdjustmentRepository,
    this._overtimeRequestRepository,
    this._workLogRepository,
    this._userRepository,
  ) : super(RequestsInitial());

  // UI-independent state
  String _statusFilter =
      'all'; // 'all' | 'pending' | 'approved' | 'rejected' | 'cancelled'
  String _lastContext = 'created'; // 'created' | 'sent'

  Future<void> updateStatusFilter(String filter) async {
    _statusFilter = filter;
    if (_lastContext == 'sent') {
      await loadSentToMeRequests();
    } else {
      await loadCreatedByMeRequests();
    }
  }

  bool _matchStatus(String statusString) {
    final s = statusString.toLowerCase();
    final f = _statusFilter.toLowerCase();
    return f == 'all' || s == f;
  }

  Future<void> loadSentToMeRequests() async {
    emit(RequestsLoading());

    try {
      _lastContext = 'sent';
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(RequestsError('Người dùng chưa đăng nhập'));
        return;
      }

      debugPrint('DEBUG: Current user ID: ${currentUser.uid}');

      final leaveRequests = await _leaveRequestRepository
          .getLeaveRequestsByManager(currentUser.uid);
      debugPrint('DEBUG: Raw leave requests count: ${leaveRequests.length}');

      final attendanceAdjustments = await _attendanceAdjustmentRepository
          .getAttendanceAdjustmentsByManager(currentUser.uid);
      debugPrint(
        'DEBUG: Raw attendance adjustments count: ${attendanceAdjustments.length}',
      );

      List<OvertimeRequestEntity> overtimeRequests = [];
      try {
        overtimeRequests = await _overtimeRequestRepository
            .getOvertimeRequestsByManager(currentUser.uid);
        debugPrint(
          'DEBUG: Raw overtime requests count: ${overtimeRequests.length}',
        );
      } catch (e) {
        debugPrint(
          'DEBUG: Error loading overtime requests in loadSentToMeRequests: $e',
        );
        // Continue with empty list if collection doesn't exist yet
      }

      List<WorkLogEntity> workLogs = [];
      try {
        workLogs =
            await _workLogRepository.getWorkLogsByManager(currentUser.uid);
        debugPrint(
          'DEBUG: Raw work logs count: ${workLogs.length}',
        );
      } catch (e) {
        debugPrint(
          'DEBUG: Error loading work logs in loadSentToMeRequests: $e',
        );
      }

      final userIds = <String>{};
      for (final request in leaveRequests) {
        userIds.add(request.idUser);
      }
      for (final adjustment in attendanceAdjustments) {
        userIds.add(adjustment.idUser);
      }
      for (final overtime in overtimeRequests) {
        userIds.add(overtime.idUser);
      }
      for (final workLog in workLogs) {
        userIds.add(workLog.idUser);
      }

      final userMap = <String, String>{}; // userId -> fullName
      for (final userId in userIds) {
        try {
          final user = await _userRepository.getUserData(userId);
          if (user != null) {
            final fullName = '${user.firstName} ${user.lastName}'.trim();
            userMap[userId] = fullName.isNotEmpty ? fullName : 'Unknown User';
          } else {
            userMap[userId] = 'Unknown User';
          }
        } catch (e) {
          userMap[userId] = 'Unknown User';
        }
      }

      // Apply status filter
      final filteredLeaveRequests = leaveRequests
          .where((req) => _matchStatus(req.status.toString().split('.').last))
          .toList();
      final filteredAttendanceAdjustments = attendanceAdjustments
          .where((adj) => _matchStatus(adj.status.toString().split('.').last))
          .toList();
      final filteredOvertimeRequests = overtimeRequests
          .where((req) => _matchStatus(req.status.toString().split('.').last))
          .toList();
      final filteredWorkLogs = workLogs
          .where((workLog) =>
              _matchStatus(workLog.status.toString().split('.').last))
          .toList();

      final totalCount = filteredLeaveRequests.length +
          filteredAttendanceAdjustments.length +
          filteredOvertimeRequests.length +
          filteredWorkLogs.length;

      emit(
        RequestsLoadedWithUserNames(
          leaveRequests: filteredLeaveRequests,
          attendanceAdjustments: filteredAttendanceAdjustments,
          overtimeRequests: filteredOvertimeRequests,
          workLogs: filteredWorkLogs,
          userMap: userMap,
          totalCount: totalCount,
          statusFilter: _statusFilter,
        ),
      );
    } catch (e) {
      emit(RequestsError('Lỗi khi tải danh sách đơn: $e'));
    }
  }

  Future<void> loadCreatedByMeRequests() async {
    emit(RequestsLoading());

    try {
      _lastContext = 'created';
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(RequestsError('Người dùng chưa đăng nhập'));
        return;
      }

      debugPrint('DEBUG: Loading requests created by user: ${currentUser.uid}');

      final leaveRequests =
          await _leaveRequestRepository.getLeaveRequestsByUser(currentUser.uid);
      debugPrint(
        'DEBUG: Leave requests created by me: ${leaveRequests.length}',
      );

      final attendanceAdjustments = await _attendanceAdjustmentRepository
          .getAttendanceAdjustmentsByUser(currentUser.uid);
      debugPrint(
        'DEBUG: Attendance adjustments created by me: ${attendanceAdjustments.length}',
      );

      // Try-catch for overtime requests to prevent errors if collection doesn't exist
      List<OvertimeRequestEntity> overtimeRequests = [];
      try {
        overtimeRequests = await _overtimeRequestRepository
            .getOvertimeRequestsByUser(currentUser.uid);
        debugPrint(
          'DEBUG: Overtime requests created by me: ${overtimeRequests.length}',
        );
      } catch (e) {
        debugPrint(
          'DEBUG: Error loading overtime requests in loadCreatedByMeRequests: $e',
        );
        // Continue with empty list if collection doesn't exist yet
      }

      List<WorkLogEntity> workLogs = [];
      try {
        workLogs = await _workLogRepository.getWorkLogsByUser(currentUser.uid);
        debugPrint(
          'DEBUG: Work logs created by me: ${workLogs.length}',
        );
      } catch (e) {
        debugPrint(
          'DEBUG: Error loading work logs in loadCreatedByMeRequests: $e',
        );
      }

      final managerIds = <String>{};
      for (final request in leaveRequests) {
        managerIds.add(request.idManager);
      }
      for (final adjustment in attendanceAdjustments) {
        managerIds.add(adjustment.idManager);
      }
      for (final overtime in overtimeRequests) {
        managerIds.add(overtime.idManager);
      }
      for (final workLog in workLogs) {
        managerIds.add(workLog.idManager);
      }

      final managerMap = <String, String>{}; // managerId -> fullName
      for (final managerId in managerIds) {
        try {
          final manager = await _userRepository.getUserData(managerId);
          if (manager != null) {
            final fullName = '${manager.firstName} ${manager.lastName}'.trim();
            managerMap[managerId] =
                fullName.isNotEmpty ? fullName : 'Unknown Manager';
          } else {
            managerMap[managerId] = 'Unknown Manager';
          }
        } catch (e) {
          managerMap[managerId] = 'Unknown Manager';
        }
      }

      // Apply status filter
      final filteredLeaveRequests = leaveRequests
          .where((req) => _matchStatus(req.status.toString().split('.').last))
          .toList();
      final filteredAttendanceAdjustments = attendanceAdjustments
          .where((adj) => _matchStatus(adj.status.toString().split('.').last))
          .toList();
      final filteredOvertimeRequests = overtimeRequests
          .where((req) => _matchStatus(req.status.toString().split('.').last))
          .toList();
      final filteredWorkLogs = workLogs
          .where((workLog) =>
              _matchStatus(workLog.status.toString().split('.').last))
          .toList();

      final totalCount = filteredLeaveRequests.length +
          filteredAttendanceAdjustments.length +
          filteredOvertimeRequests.length +
          filteredWorkLogs.length;

      emit(
        RequestsLoadedWithUserNames(
          leaveRequests: filteredLeaveRequests,
          attendanceAdjustments: filteredAttendanceAdjustments,
          overtimeRequests: filteredOvertimeRequests,
          workLogs: filteredWorkLogs,
          userMap: managerMap,
          totalCount: totalCount,
          statusFilter: _statusFilter,
        ),
      );
    } catch (e) {
      emit(RequestsError('Lỗi khi tải danh sách đơn đã tạo: $e'));
    }
  }

  Future<void> getCreatedByMeCount() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final leaveRequests =
          await _leaveRequestRepository.getLeaveRequestsByUser(currentUser.uid);
      final attendanceAdjustments = await _attendanceAdjustmentRepository
          .getAttendanceAdjustmentsByUser(currentUser.uid);

      // Try-catch for overtime requests to prevent errors if collection doesn't exist
      List<OvertimeRequestEntity> overtimeRequests = [];
      try {
        overtimeRequests = await _overtimeRequestRepository
            .getOvertimeRequestsByUser(currentUser.uid);
      } catch (e) {
        debugPrint(
          'DEBUG: Error loading overtime requests in getCreatedByMeCount: $e',
        );
        // Continue with empty list if collection doesn't exist yet
      }

      List<WorkLogEntity> workLogs = [];
      try {
        workLogs = await _workLogRepository.getWorkLogsByUser(currentUser.uid);
      } catch (e) {
        debugPrint(
          'DEBUG: Error loading work logs in getCreatedByMeCount: $e',
        );
      }

      final totalCreated = leaveRequests.length +
          attendanceAdjustments.length +
          overtimeRequests.length +
          workLogs.length;

      emit(
        RequestsLoaded(
          leaveRequests: leaveRequests,
          attendanceAdjustments: attendanceAdjustments,
          overtimeRequests: overtimeRequests,
          workLogs: workLogs,
          totalCount: totalCreated,
        ),
      );
    } catch (e) {
      debugPrint('DEBUG: Error in getCreatedByMeCount: $e');
      emit(RequestsError('Lỗi khi đếm số đơn đã tạo: $e'));
    }
  }

  Future<void> getPendingRequestsCount() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final leaveRequests = await _leaveRequestRepository
          .getLeaveRequestsByManager(currentUser.uid);
      final attendanceAdjustments = await _attendanceAdjustmentRepository
          .getAttendanceAdjustmentsByManager(currentUser.uid);

      // Try-catch for overtime requests to prevent errors if collection doesn't exist
      List<OvertimeRequestEntity> overtimeRequests = [];
      try {
        overtimeRequests = await _overtimeRequestRepository
            .getOvertimeRequestsByManager(currentUser.uid);
      } catch (e) {
        debugPrint('DEBUG: Error loading overtime requests: $e');
        // Continue with empty list if collection doesn't exist yet
      }

      List<WorkLogEntity> workLogs = [];
      try {
        workLogs =
            await _workLogRepository.getWorkLogsByManager(currentUser.uid);
      } catch (e) {
        debugPrint('DEBUG: Error loading work logs: $e');
      }

      // Filter only pending requests
      final pendingLeaveRequests = leaveRequests
          .where((req) => req.status.toString().split('.').last == 'pending')
          .toList();
      final pendingAttendanceAdjustments = attendanceAdjustments
          .where((adj) => adj.status.toString().split('.').last == 'pending')
          .toList();
      final pendingOvertimeRequests = overtimeRequests
          .where((req) => req.status.toString().split('.').last == 'pending')
          .toList();
      final pendingWorkLogs = workLogs
          .where((workLog) =>
              workLog.status.toString().split('.').last == 'pending')
          .toList();

      final totalPending = pendingLeaveRequests.length +
          pendingAttendanceAdjustments.length +
          pendingOvertimeRequests.length +
          pendingWorkLogs.length;

      emit(
        RequestsLoaded(
          leaveRequests: pendingLeaveRequests,
          attendanceAdjustments: pendingAttendanceAdjustments,
          overtimeRequests: pendingOvertimeRequests,
          workLogs: pendingWorkLogs,
          totalCount: totalPending,
        ),
      );
    } catch (e) {
      debugPrint('DEBUG: Error in getPendingRequestsCount: $e');
      emit(RequestsError('Lỗi khi đếm số đơn: $e'));
    }
  }
}
