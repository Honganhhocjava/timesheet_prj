import 'package:flutter/material.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/entities/attendance_adjustment_entity.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

abstract class AttendanceAdjustmentState {}

class AttendanceAdjustmentInitial extends AttendanceAdjustmentState {}

class AttendanceAdjustmentLoading extends AttendanceAdjustmentState {}

class AttendanceAdjustmentCreated extends AttendanceAdjustmentState {
  final String message;

  AttendanceAdjustmentCreated(this.message);
}

class AttendanceAdjustmentError extends AttendanceAdjustmentState {
  final String message;

  AttendanceAdjustmentError(this.message);
}

class AttendanceAdjustmentsLoaded extends AttendanceAdjustmentState {
  final List<AttendanceAdjustmentEntity> adjustments;

  AttendanceAdjustmentsLoaded(this.adjustments);
}

class ManagersLoaded extends AttendanceAdjustmentState {
  final List<UserEntity> managers;

  ManagersLoaded(this.managers);
}

class AttendanceAdjustmentFormState extends AttendanceAdjustmentState {
  final DateTime? adjustmentDate;
  final TimeOfDay? originalCheckIn;
  final TimeOfDay? originalCheckOut;
  final TimeOfDay? adjustedCheckIn;
  final TimeOfDay? adjustedCheckOut;
  final String reason;
  final UserEntity? selectedManager;
  final List<UserEntity> managers;
  final bool isLoading;
  final String? adjustmentDateError;
  final String? originalCheckInError;
  final String? originalCheckOutError;
  final String? adjustedCheckInError;
  final String? adjustedCheckOutError;
  final String? reasonError;
  final String? managerError;

  AttendanceAdjustmentFormState({
    this.adjustmentDate,
    this.originalCheckIn,
    this.originalCheckOut,
    this.adjustedCheckIn,
    this.adjustedCheckOut,
    this.reason = '',
    this.selectedManager,
    this.managers = const [],
    this.isLoading = false,
    this.adjustmentDateError,
    this.originalCheckInError,
    this.originalCheckOutError,
    this.adjustedCheckInError,
    this.adjustedCheckOutError,
    this.reasonError,
    this.managerError,
  });

  AttendanceAdjustmentFormState copyWith({
    DateTime? adjustmentDate,
    TimeOfDay? originalCheckIn,
    TimeOfDay? originalCheckOut,
    TimeOfDay? adjustedCheckIn,
    TimeOfDay? adjustedCheckOut,
    String? reason,
    UserEntity? selectedManager,
    List<UserEntity>? managers,
    bool? isLoading,
    String? adjustmentDateError,
    String? originalCheckInError,
    String? originalCheckOutError,
    String? adjustedCheckInError,
    String? adjustedCheckOutError,
    String? reasonError,
    String? managerError,
  }) {
    return AttendanceAdjustmentFormState(
      adjustmentDate: adjustmentDate ?? this.adjustmentDate,
      originalCheckIn: originalCheckIn ?? this.originalCheckIn,
      originalCheckOut: originalCheckOut ?? this.originalCheckOut,
      adjustedCheckIn: adjustedCheckIn ?? this.adjustedCheckIn,
      adjustedCheckOut: adjustedCheckOut ?? this.adjustedCheckOut,
      reason: reason ?? this.reason,
      selectedManager: selectedManager ?? this.selectedManager,
      managers: managers ?? this.managers,
      isLoading: isLoading ?? this.isLoading,
      adjustmentDateError: adjustmentDateError,
      originalCheckInError: originalCheckInError,
      originalCheckOutError: originalCheckOutError,
      adjustedCheckInError: adjustedCheckInError,
      adjustedCheckOutError: adjustedCheckOutError,
      reasonError: reasonError,
      managerError: managerError,
    );
  }
}
