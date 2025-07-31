import 'package:flutter/material.dart';
import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

abstract class LeaveRequestState {}

class LeaveRequestInitial extends LeaveRequestState {}

class LeaveRequestLoading extends LeaveRequestState {}

class LeaveRequestCreated extends LeaveRequestState {
  final String message;

  LeaveRequestCreated(this.message);
}

class LeaveRequestError extends LeaveRequestState {
  final String message;

  LeaveRequestError(this.message);
}

class LeaveRequestsLoaded extends LeaveRequestState {
  final List<LeaveRequestEntity> requests;

  LeaveRequestsLoaded(this.requests);
}

class ManagersLoaded extends LeaveRequestState {
  final List<UserEntity> managers;

  ManagersLoaded(this.managers);
}

class LeaveRequestFormState extends LeaveRequestState {
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String reason;
  final UserEntity? selectedManager;
  final List<UserEntity> managers;
  final bool isLoading;
  final String? startDateError;
  final String? endDateError;
  final String? startTimeError;
  final String? endTimeError;
  final String? reasonError;
  final String? managerError;

  LeaveRequestFormState({
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.reason = '',
    this.selectedManager,
    this.managers = const [],
    this.isLoading = false,
    this.startDateError,
    this.endDateError,
    this.startTimeError,
    this.endTimeError,
    this.reasonError,
    this.managerError,
  });

  LeaveRequestFormState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? reason,
    UserEntity? selectedManager,
    List<UserEntity>? managers,
    bool? isLoading,
    String? startDateError,
    String? endDateError,
    String? startTimeError,
    String? endTimeError,
    String? reasonError,
    String? managerError,
  }) {
    return LeaveRequestFormState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      selectedManager: selectedManager ?? this.selectedManager,
      managers: managers ?? this.managers,
      isLoading: isLoading ?? this.isLoading,
      startDateError: startDateError,
      endDateError: endDateError,
      startTimeError: startTimeError,
      endTimeError: endTimeError,
      reasonError: reasonError,
      managerError: managerError,
    );
  }
}
