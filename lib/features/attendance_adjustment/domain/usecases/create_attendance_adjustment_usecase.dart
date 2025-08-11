import 'package:flutter/material.dart';
import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/entities/attendance_adjustment_entity.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/repositories/attendance_adjustment_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

class CreateAttendanceAdjustmentUsecase
    implements UseCase<void, CreateAttendanceAdjustmentParams> {
  final AttendanceAdjustmentRepository repository;

  CreateAttendanceAdjustmentUsecase(this.repository);

  @override
  Future<void> call(CreateAttendanceAdjustmentParams params) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final initialActivity = ActivityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      action: 'Tạo đơn điều chỉnh chấm công',
      userId: currentUser.uid,
      userRole: 'Nhân viên',
      timestamp: DateTime.now(),
      comment: 'Đơn điều chỉnh chấm công được tạo',
    );

    final attendanceAdjustment = AttendanceAdjustmentEntity(
      id: params.id,
      idUser: currentUser.uid,
      idManager: params.idManager,
      status: RequestStatus.pending,
      adjustmentDate: params.adjustmentDate,
      originalCheckIn: params.originalCheckIn,
      originalCheckOut: params.originalCheckOut,
      adjustedCheckIn: params.adjustedCheckIn,
      adjustedCheckOut: params.adjustedCheckOut,
      reason: params.reason,
      activitiesLog: [initialActivity],
      createdAt: DateTime.now(),
    );

    await repository.createAttendanceAdjustment(attendanceAdjustment);
  }
}

class CreateAttendanceAdjustmentParams {
  final String id;
  final String idManager;
  final DateTime adjustmentDate;
  final TimeOfDay originalCheckIn;
  final TimeOfDay originalCheckOut;
  final TimeOfDay adjustedCheckIn;
  final TimeOfDay adjustedCheckOut;
  final String reason;

  CreateAttendanceAdjustmentParams({
    required this.id,
    required this.idManager,
    required this.adjustmentDate,
    required this.originalCheckIn,
    required this.originalCheckOut,
    required this.adjustedCheckIn,
    required this.adjustedCheckOut,
    required this.reason,
  });
}
