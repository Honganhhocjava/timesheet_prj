import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/usecases/create_attendance_adjustment_usecase.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/usecases/get_managers_usecase.dart';
import 'package:timesheet_project/features/attendance_adjustment/presentation/cubit/attendance_adjustment_state.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/core/usecases/usecase.dart';

class AttendanceAdjustmentCubit extends Cubit<AttendanceAdjustmentState> {
  final CreateAttendanceAdjustmentUsecase _createAttendanceAdjustmentUsecase;
  final GetManagersUsecase _getManagersUsecase;

  AttendanceAdjustmentCubit(
    this._createAttendanceAdjustmentUsecase,
    this._getManagersUsecase,
  ) : super(AttendanceAdjustmentInitial());

  void initializeForm() async {
    emit(AttendanceAdjustmentFormState(isLoading: true));
    try {
      final managers = await _getManagersUsecase(NoParams());
      emit(AttendanceAdjustmentFormState(managers: managers));
    } catch (e) {
      emit(AttendanceAdjustmentError('Lỗi khi tải danh sách quản lý: $e'));
    }
  }

  void updateAdjustmentDate(DateTime date) {
    if (state is AttendanceAdjustmentFormState) {
      final currentState = state as AttendanceAdjustmentFormState;
      emit(
        currentState.copyWith(adjustmentDate: date, adjustmentDateError: null),
      );
    }
  }

  void updateOriginalCheckIn(TimeOfDay time) {
    if (state is AttendanceAdjustmentFormState) {
      final currentState = state as AttendanceAdjustmentFormState;
      emit(
        currentState.copyWith(
          originalCheckIn: time,
          originalCheckInError: null,
        ),
      );
    }
  }

  void updateOriginalCheckOut(TimeOfDay time) {
    if (state is AttendanceAdjustmentFormState) {
      final currentState = state as AttendanceAdjustmentFormState;
      emit(
        currentState.copyWith(
          originalCheckOut: time,
          originalCheckOutError: null,
        ),
      );
    }
  }

  void updateAdjustedCheckIn(TimeOfDay time) {
    if (state is AttendanceAdjustmentFormState) {
      final currentState = state as AttendanceAdjustmentFormState;
      emit(
        currentState.copyWith(
          adjustedCheckIn: time,
          adjustedCheckInError: null,
        ),
      );
    }
  }

  void updateAdjustedCheckOut(TimeOfDay time) {
    if (state is AttendanceAdjustmentFormState) {
      final currentState = state as AttendanceAdjustmentFormState;
      emit(
        currentState.copyWith(
          adjustedCheckOut: time,
          adjustedCheckOutError: null,
        ),
      );
    }
  }

  void updateReason(String reason) {
    if (state is AttendanceAdjustmentFormState) {
      final currentState = state as AttendanceAdjustmentFormState;
      emit(currentState.copyWith(reason: reason, reasonError: null));
    }
  }

  void selectManager(UserEntity manager) {
    if (state is AttendanceAdjustmentFormState) {
      final currentState = state as AttendanceAdjustmentFormState;
      emit(currentState.copyWith(selectedManager: manager, managerError: null));
    }
  }

  Future<void> submitAttendanceAdjustment() async {
    if (state is! AttendanceAdjustmentFormState) return;

    final formState = state as AttendanceAdjustmentFormState;

    // Reset validation errors
    String? adjustmentDateError;
    String? originalCheckInError;
    String? originalCheckOutError;
    String? adjustedCheckInError;
    String? adjustedCheckOutError;
    String? reasonError;
    String? managerError;
    bool hasError = false;

    if (formState.adjustmentDate == null) {
      adjustmentDateError = 'Vui lòng chọn ngày cần điều chỉnh';
      hasError = true;
    }

    if (formState.originalCheckIn == null) {
      originalCheckInError = 'Vui lòng chọn giờ vào ban đầu';
      hasError = true;
    }

    if (formState.originalCheckOut == null) {
      originalCheckOutError = 'Vui lòng chọn giờ ra ban đầu';
      hasError = true;
    }

    if (formState.adjustedCheckIn == null) {
      adjustedCheckInError = 'Vui lòng chọn giờ vào điều chỉnh';
      hasError = true;
    }

    if (formState.adjustedCheckOut == null) {
      adjustedCheckOutError = 'Vui lòng chọn giờ ra điều chỉnh';
      hasError = true;
    }

    if (formState.reason.trim().isEmpty) {
      reasonError = 'Vui lòng nhập lý do điều chỉnh';
      hasError = true;
    }

    if (formState.selectedManager == null) {
      managerError = 'Vui lòng chọn người duyệt';
      hasError = true;
    }

    // Validation: Giờ vào phải nhỏ hơn giờ ra (original)
    if (formState.originalCheckIn != null &&
        formState.originalCheckOut != null) {
      final originalCheckInMinutes = formState.originalCheckIn!.hour * 60 +
          formState.originalCheckIn!.minute;
      final originalCheckOutMinutes = formState.originalCheckOut!.hour * 60 +
          formState.originalCheckOut!.minute;

      if (originalCheckInMinutes >= originalCheckOutMinutes) {
        originalCheckInError = 'Giờ vào ban đầu phải nhỏ hơn giờ ra ban đầu';
        hasError = true;
      }
    }

    // Validation: Giờ vào phải nhỏ hơn giờ ra (adjusted)
    if (formState.adjustedCheckIn != null &&
        formState.adjustedCheckOut != null) {
      final adjustedCheckInMinutes = formState.adjustedCheckIn!.hour * 60 +
          formState.adjustedCheckIn!.minute;
      final adjustedCheckOutMinutes = formState.adjustedCheckOut!.hour * 60 +
          formState.adjustedCheckOut!.minute;

      if (adjustedCheckInMinutes >= adjustedCheckOutMinutes) {
        adjustedCheckInError =
            'Giờ vào điều chỉnh phải nhỏ hơn giờ ra điều chỉnh';
        hasError = true;
      }
    }

    // Update form state with validation errors
    emit(
      formState.copyWith(
        adjustmentDateError: adjustmentDateError,
        originalCheckInError: originalCheckInError,
        originalCheckOutError: originalCheckOutError,
        adjustedCheckInError: adjustedCheckInError,
        adjustedCheckOutError: adjustedCheckOutError,
        reasonError: reasonError,
        managerError: managerError,
      ),
    );

    if (hasError) {
      return;
    }

    emit(formState.copyWith(isLoading: true));

    try {
      final params = CreateAttendanceAdjustmentParams(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        idManager: formState.selectedManager!.uid,
        adjustmentDate: formState.adjustmentDate!,
        originalCheckIn: formState.originalCheckIn!,
        originalCheckOut: formState.originalCheckOut!,
        adjustedCheckIn: formState.adjustedCheckIn!,
        adjustedCheckOut: formState.adjustedCheckOut!,
        reason: formState.reason.trim(),
      );

      await _createAttendanceAdjustmentUsecase(params);
      emit(
        AttendanceAdjustmentCreated(
          'Đơn điều chỉnh chấm công đã được tạo thành công!',
        ),
      );
    } catch (e, s) {
      print(e);
      print(s);
      emit(
        AttendanceAdjustmentError('Lỗi khi tạo đơn điều chỉnh chấm công: $e'),
      );
      emit(formState.copyWith(isLoading: false));
    }
  }

  void resetState() {
    emit(AttendanceAdjustmentInitial());
  }
}
