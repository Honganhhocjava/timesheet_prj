import 'package:flutter/material.dart';
import 'package:timesheet_project/core/usecases/usecase.dart';

import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/leave_request/domain/repositories/leave_request_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateLeaveRequestUsecase
    implements UseCase<void, CreateLeaveRequestParams> {
  final LeaveRequestRepository repository;

  CreateLeaveRequestUsecase(this.repository);

  @override
  Future<void> call(CreateLeaveRequestParams params) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final initialActivity = ActivityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      action: 'Tạo đơn xin nghỉ phép',
      userId: currentUser.uid,
      userRole: 'Nhân viên',
      timestamp: DateTime.now(),
      comment: 'Đơn xin nghỉ phép được tạo',
    );

    final leaveRequest = LeaveRequestEntity(
      id: params.id,
      idUser: currentUser.uid,
      idManager: params.idManager,
      status: LeaveRequestStatus.pending,
      startDate: params.startDate,
      endDate: params.endDate,
      startTime: params.startTime,
      endTime: params.endTime,
      reason: params.reason,
      activitiesLog: [initialActivity],
      createdAt: DateTime.now(),
    );

    await repository.createLeaveRequest(leaveRequest);
  }
}

class CreateLeaveRequestParams {
  final String id;
  final String idManager;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String reason;

  CreateLeaveRequestParams({
    required this.id,
    required this.idManager,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.reason,
  });
}
