import 'package:flutter/material.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

abstract class OvertimeRequestState {}

class OvertimeRequestInitial extends OvertimeRequestState {}

class OvertimeRequestLoading extends OvertimeRequestState {}

class OvertimeRequestCreated extends OvertimeRequestState {
  final String message;

  OvertimeRequestCreated(this.message);
}

class OvertimeRequestError extends OvertimeRequestState {
  final String message;

  OvertimeRequestError(this.message);
}

class OvertimeRequestsLoaded extends OvertimeRequestState {
  final List<OvertimeRequestEntity> requests;

  OvertimeRequestsLoaded(this.requests);
}

class ManagersLoaded extends OvertimeRequestState {
  final List<UserEntity> managers;

  ManagersLoaded(this.managers);
}

class OvertimeRequestFormState extends OvertimeRequestState {
  final DateTime? overtimeDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String reason;
  final UserEntity? selectedManager;
  final List<UserEntity> managers;
  final bool isLoading;
  final String? overtimeDateError;
  final String? startTimeError;
  final String? endTimeError;
  final String? reasonError;
  final String? managerError;

  OvertimeRequestFormState({
    this.overtimeDate,
    this.startTime,
    this.endTime,
    this.reason = '',
    this.selectedManager,
    this.managers = const [],
    this.isLoading = false,
    this.overtimeDateError,
    this.startTimeError,
    this.endTimeError,
    this.reasonError,
    this.managerError,
  });

  OvertimeRequestFormState copyWith({
    DateTime? overtimeDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? reason,
    UserEntity? selectedManager,
    List<UserEntity>? managers,
    bool? isLoading,
    String? overtimeDateError,
    String? startTimeError,
    String? endTimeError,
    String? reasonError,
    String? managerError,
  }) {
    return OvertimeRequestFormState(
      overtimeDate: overtimeDate ?? this.overtimeDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      selectedManager: selectedManager ?? this.selectedManager,
      managers: managers ?? this.managers,
      isLoading: isLoading ?? this.isLoading,
      overtimeDateError: overtimeDateError,
      startTimeError: startTimeError,
      endTimeError: endTimeError,
      reasonError: reasonError,
      managerError: managerError,
    );
  }
}
