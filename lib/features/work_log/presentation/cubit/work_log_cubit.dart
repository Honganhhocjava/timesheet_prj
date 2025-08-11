import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';
import 'package:timesheet_project/features/work_log/domain/usecases/create_work_log_usecase.dart';
import 'package:timesheet_project/features/work_log/domain/usecases/get_managers_usecase.dart';
import 'package:timesheet_project/features/work_log/presentation/cubit/work_log_state.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

class WorkLogCubit extends Cubit<WorkLogState> {
  final CreateWorkLogUsecase createWorkLogUsecase;
  final GetManagersUsecase getManagersUsecase;

  WorkLogCubit(this.createWorkLogUsecase, this.getManagersUsecase)
      : super(WorkLogInitial());

  Future<void> initializeForm() async {
    emit(WorkLogLoading());
    try {
      final managers = await getManagersUsecase(NoParams());
      emit(WorkLogFormState(managers: managers));
    } catch (e) {
      emit(WorkLogError('Failed to load managers: $e'));
    }
  }

  void updateWorkDate(DateTime date) {
    if (state is WorkLogFormState) {
      final currentState = state as WorkLogFormState;
      emit(currentState.copyWith(workDate: date, workDateError: null));
    }
  }

  void updateCheckInTime(TimeOfDay time) {
    if (state is WorkLogFormState) {
      final currentState = state as WorkLogFormState;
      emit(currentState.copyWith(checkInTime: time, checkInTimeError: null));
    }
  }

  void updateCheckOutTime(TimeOfDay time) {
    if (state is WorkLogFormState) {
      final currentState = state as WorkLogFormState;
      emit(currentState.copyWith(checkOutTime: time, checkOutTimeError: null));
    }
  }

  void updateNotes(String notes) {
    if (state is WorkLogFormState) {
      final currentState = state as WorkLogFormState;
      emit(currentState.copyWith(notes: notes));
    }
  }

  void selectManager(UserEntity manager) {
    if (state is WorkLogFormState) {
      final currentState = state as WorkLogFormState;
      emit(currentState.copyWith(selectedManager: manager, managerError: null));
    }
  }

  Future<void> submitWorkLog() async {
    if (state is! WorkLogFormState) return;

    final currentState = state as WorkLogFormState;

    // Reset validation errors
    String? workDateError;
    String? checkInTimeError;
    String? checkOutTimeError;
    String? managerError;
    bool hasError = false;

    if (currentState.workDate == null) {
      workDateError = 'Vui lòng chọn ngày làm việc';
      hasError = true;
    }

    if (currentState.checkInTime == null) {
      checkInTimeError = 'Vui lòng chọn giờ check-in';
      hasError = true;
    }

    if (currentState.checkOutTime == null) {
      checkOutTimeError = 'Vui lòng chọn giờ check-out';
      hasError = true;
    }

    if (currentState.selectedManager == null) {
      managerError = 'Vui lòng chọn người duyệt';
      hasError = true;
    }

    // Check if check-in time is before check-out time
    if (currentState.checkInTime != null && currentState.checkOutTime != null) {
      final checkInMinutes = currentState.checkInTime!.hour * 60 +
          currentState.checkInTime!.minute;
      final checkOutMinutes = currentState.checkOutTime!.hour * 60 +
          currentState.checkOutTime!.minute;

      if (checkInMinutes >= checkOutMinutes) {
        checkInTimeError = 'Giờ check-in phải trước giờ check-out';
        hasError = true;
      }
    }

    // Update form state with validation errors
    emit(
      currentState.copyWith(
        workDateError: workDateError,
        checkInTimeError: checkInTimeError,
        checkOutTimeError: checkOutTimeError,
        managerError: managerError,
      ),
    );

    if (hasError) {
      return;
    }

    emit(currentState.copyWith(isLoading: true));

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final workLog = WorkLogEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        idUser: user.uid,
        idManager: currentState.selectedManager!.uid,
        status: RequestStatus.pending,
        workDate: currentState.workDate!,
        checkInTime: currentState.checkInTime!,
        checkOutTime: currentState.checkOutTime!,
        notes: currentState.notes.isNotEmpty ? currentState.notes : null,
        activitiesLog: [
          ActivityLog(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            action: 'created',
            userId: user.uid,
            userRole: 'Nhân viên',
            timestamp: DateTime.now(),
            comment: 'Work log created',
          ),
        ],
        createdAt: DateTime.now(),
      );

      await createWorkLogUsecase(workLog);
      emit(WorkLogCreated('Work log đã được tạo thành công'));
    } catch (e) {
      emit(WorkLogError('Tạo work log thất bại: $e'));
      emit(currentState.copyWith(isLoading: false));
    }
  }
}
