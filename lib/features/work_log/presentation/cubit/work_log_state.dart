import 'package:flutter/material.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

abstract class WorkLogState {}

class WorkLogInitial extends WorkLogState {}

class WorkLogLoading extends WorkLogState {}

class WorkLogFormState extends WorkLogState {
  final DateTime? workDate;
  final TimeOfDay? checkInTime;
  final TimeOfDay? checkOutTime;
  final String notes;
  final List<UserEntity> managers;
  final UserEntity? selectedManager;
  final bool isLoading;
  final String? workDateError;
  final String? checkInTimeError;
  final String? checkOutTimeError;
  final String? managerError;

  WorkLogFormState({
    this.workDate,
    this.checkInTime,
    this.checkOutTime,
    this.notes = '',
    this.managers = const [],
    this.selectedManager,
    this.isLoading = false,
    this.workDateError,
    this.checkInTimeError,
    this.checkOutTimeError,
    this.managerError,
  });

  WorkLogFormState copyWith({
    DateTime? workDate,
    TimeOfDay? checkInTime,
    TimeOfDay? checkOutTime,
    String? notes,
    List<UserEntity>? managers,
    UserEntity? selectedManager,
    bool? isLoading,
    String? workDateError,
    String? checkInTimeError,
    String? checkOutTimeError,
    String? managerError,
  }) {
    return WorkLogFormState(
      workDate: workDate ?? this.workDate,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      notes: notes ?? this.notes,
      managers: managers ?? this.managers,
      selectedManager: selectedManager ?? this.selectedManager,
      isLoading: isLoading ?? this.isLoading,
      workDateError: workDateError,
      checkInTimeError: checkInTimeError,
      checkOutTimeError: checkOutTimeError,
      managerError: managerError,
    );
  }
}

class WorkLogCreated extends WorkLogState {
  final String message;

  WorkLogCreated(this.message);
}

class WorkLogError extends WorkLogState {
  final String message;

  WorkLogError(this.message);
}
