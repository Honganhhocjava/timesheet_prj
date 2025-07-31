import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/features/leave_request/domain/usecases/create_leave_request_usecase.dart';
import 'package:timesheet_project/features/leave_request/domain/usecases/get_managers_usecase.dart';
import 'package:timesheet_project/features/leave_request/domain/usecases/update_leave_request_usecase.dart';
import 'package:timesheet_project/features/leave_request/domain/usecases/delete_leave_request_usecase.dart';
import 'package:timesheet_project/features/leave_request/presentation/cubit/leave_request_state.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';

class LeaveRequestCubit extends Cubit<LeaveRequestState> {
  final CreateLeaveRequestUsecase _createLeaveRequestUsecase;
  final GetManagersUsecase _getManagersUsecase;
  final UpdateLeaveRequestUseCase _updateLeaveRequestUseCase;
  final DeleteLeaveRequestUseCase _deleteLeaveRequestUseCase;

  LeaveRequestCubit(
    this._createLeaveRequestUsecase,
    this._getManagersUsecase,
    this._updateLeaveRequestUseCase,
    this._deleteLeaveRequestUseCase,
  ) : super(LeaveRequestInitial());

  void initializeForm() async {
    emit(LeaveRequestFormState(isLoading: true));
    try {
      final managers = await _getManagersUsecase(NoParams());
      emit(LeaveRequestFormState(managers: managers));
    } catch (e) {
      emit(LeaveRequestError('Lỗi khi tải danh sách quản lý: $e'));
    }
  }

  void updateStartDate(DateTime date) {
    if (state is LeaveRequestFormState) {
      final currentState = state as LeaveRequestFormState;
      emit(currentState.copyWith(startDate: date, startDateError: null));
    }
  }

  void updateEndDate(DateTime date) {
    if (state is LeaveRequestFormState) {
      final currentState = state as LeaveRequestFormState;
      emit(currentState.copyWith(endDate: date, endDateError: null));
    }
  }

  void updateStartTime(TimeOfDay time) {
    if (state is LeaveRequestFormState) {
      final currentState = state as LeaveRequestFormState;
      emit(currentState.copyWith(startTime: time, startTimeError: null));
    }
  }

  void updateEndTime(TimeOfDay time) {
    if (state is LeaveRequestFormState) {
      final currentState = state as LeaveRequestFormState;
      emit(currentState.copyWith(endTime: time, endTimeError: null));
    }
  }

  void updateReason(String reason) {
    if (state is LeaveRequestFormState) {
      final currentState = state as LeaveRequestFormState;
      emit(currentState.copyWith(reason: reason, reasonError: null));
    }
  }

  void selectManager(UserEntity manager) {
    if (state is LeaveRequestFormState) {
      final currentState = state as LeaveRequestFormState;
      emit(currentState.copyWith(selectedManager: manager, managerError: null));
    }
  }

  Future<void> submitLeaveRequest() async {
    if (state is! LeaveRequestFormState) return;

    final formState = state as LeaveRequestFormState;

    // Reset validation errors
    String? startDateError;
    String? endDateError;
    String? startTimeError;
    String? endTimeError;
    String? reasonError;
    String? managerError;
    bool hasError = false;

    if (formState.startDate == null) {
      startDateError = 'Vui lòng chọn ngày bắt đầu nghỉ';
      hasError = true;
    }

    if (formState.endDate == null) {
      endDateError = 'Vui lòng chọn ngày kết thúc nghỉ';
      hasError = true;
    }

    if (formState.startTime == null) {
      startTimeError = 'Vui lòng chọn giờ bắt đầu nghỉ';
      hasError = true;
    }

    if (formState.endTime == null) {
      endTimeError = 'Vui lòng chọn giờ kết thúc nghỉ';
      hasError = true;
    }

    if (formState.reason.trim().isEmpty) {
      reasonError = 'Vui lòng nhập lý do nghỉ';
      hasError = true;
    }

    if (formState.selectedManager == null) {
      managerError = 'Vui lòng chọn người duyệt';
      hasError = true;
    }

    // Validation: Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc
    if (formState.startDate != null &&
        formState.endDate != null &&
        formState.startDate!.isAfter(formState.endDate!)) {
      startDateError = 'Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc';
      hasError = true;
    }

    // Validation: Nếu cùng ngày, giờ bắt đầu phải nhỏ hơn giờ kết thúc
    if (formState.startDate != null &&
        formState.endDate != null &&
        formState.startTime != null &&
        formState.endTime != null &&
        formState.startDate!.year == formState.endDate!.year &&
        formState.startDate!.month == formState.endDate!.month &&
        formState.startDate!.day == formState.endDate!.day) {
      final startMinutes =
          formState.startTime!.hour * 60 + formState.startTime!.minute;
      final endMinutes =
          formState.endTime!.hour * 60 + formState.endTime!.minute;

      if (startMinutes >= endMinutes) {
        startTimeError = 'Giờ bắt đầu phải nhỏ hơn giờ kết thúc khi cùng ngày';
        hasError = true;
      }
    }

    // Update form state with validation errors
    emit(
      formState.copyWith(
        startDateError: startDateError,
        endDateError: endDateError,
        startTimeError: startTimeError,
        endTimeError: endTimeError,
        reasonError: reasonError,
        managerError: managerError,
      ),
    );

    if (hasError) {
      return;
    }

    emit(formState.copyWith(isLoading: true));

    try {
      final params = CreateLeaveRequestParams(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        idManager: formState.selectedManager!.uid,
        startDate: formState.startDate!,
        endDate: formState.endDate!,
        startTime: formState.startTime!,
        endTime: formState.endTime!,
        reason: formState.reason.trim(),
      );

      await _createLeaveRequestUsecase(params);
      emit(LeaveRequestCreated('Đơn xin nghỉ phép đã được tạo thành công!'));
    } catch (e, s) {
      print(e);
      print(s);
      emit(LeaveRequestError('Lỗi khi tạo đơn xin nghỉ: $e'));
      emit(formState.copyWith(isLoading: false));
    }
  }

  void resetState() {
    emit(LeaveRequestInitial());
  }

  // Method to load existing request for editing
  void loadRequestForEdit(LeaveRequestEntity request) {
    emit(
      LeaveRequestFormState(
        startDate: request.startDate,
        endDate: request.endDate,
        startTime: request.startTime,
        endTime: request.endTime,
        reason: request.reason,
        selectedManager: null, // Will be loaded from managers list
        isLoading: false,
      ),
    );
  }

  // Method to update existing request
  Future<void> updateLeaveRequest(LeaveRequestEntity request) async {
    if (state is! LeaveRequestFormState) return;

    final formState = state as LeaveRequestFormState;

    // Validation logic (same as submitLeaveRequest)
    String? startDateError;
    String? endDateError;
    String? startTimeError;
    String? endTimeError;
    String? reasonError;
    String? managerError;
    bool hasError = false;

    if (formState.startDate == null) {
      startDateError = 'Vui lòng chọn ngày bắt đầu nghỉ';
      hasError = true;
    }

    if (formState.endDate == null) {
      endDateError = 'Vui lòng chọn ngày kết thúc nghỉ';
      hasError = true;
    }

    if (formState.startTime == null) {
      startTimeError = 'Vui lòng chọn giờ bắt đầu nghỉ';
      hasError = true;
    }

    if (formState.endTime == null) {
      endTimeError = 'Vui lòng chọn giờ kết thúc nghỉ';
      hasError = true;
    }

    if (formState.reason.trim().isEmpty) {
      reasonError = 'Vui lòng nhập lý do nghỉ';
      hasError = true;
    }

    if (formState.selectedManager == null) {
      managerError = 'Vui lòng chọn người duyệt';
      hasError = true;
    }

    // Validation: Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc
    if (formState.startDate != null &&
        formState.endDate != null &&
        formState.startDate!.isAfter(formState.endDate!)) {
      startDateError = 'Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc';
      hasError = true;
    }

    // Validation: Nếu cùng ngày, giờ bắt đầu phải nhỏ hơn giờ kết thúc
    if (formState.startDate != null &&
        formState.endDate != null &&
        formState.startTime != null &&
        formState.endTime != null &&
        formState.startDate!.year == formState.endDate!.year &&
        formState.startDate!.month == formState.endDate!.month &&
        formState.startDate!.day == formState.endDate!.day) {
      final startMinutes =
          formState.startTime!.hour * 60 + formState.startTime!.minute;
      final endMinutes =
          formState.endTime!.hour * 60 + formState.endTime!.minute;

      if (startMinutes >= endMinutes) {
        startTimeError = 'Giờ bắt đầu phải nhỏ hơn giờ kết thúc khi cùng ngày';
        hasError = true;
      }
    }

    // Update form state with validation errors
    emit(
      formState.copyWith(
        startDateError: startDateError,
        endDateError: endDateError,
        startTimeError: startTimeError,
        endTimeError: endTimeError,
        reasonError: reasonError,
        managerError: managerError,
      ),
    );

    if (hasError) {
      return;
    }

    emit(formState.copyWith(isLoading: true));

    try {
      // Create updated request entity
      final updatedRequest = LeaveRequestEntity(
        id: request.id,
        idUser: request.idUser,
        idManager: formState.selectedManager!.uid,
        status: request.status,
        startDate: formState.startDate!,
        endDate: formState.endDate!,
        startTime: formState.startTime!,
        endTime: formState.endTime!,
        reason: formState.reason.trim(),
        activitiesLog: request.activitiesLog,
        createdAt: request.createdAt,
      );

      await _updateLeaveRequestUseCase(updatedRequest);
      emit(
        LeaveRequestCreated('Đơn xin nghỉ phép đã được cập nhật thành công!'),
      );
    } catch (e) {
      emit(LeaveRequestError('Lỗi khi cập nhật đơn xin nghỉ: $e'));
      emit(formState.copyWith(isLoading: false));
    }
  }

  // Method to delete request
  Future<void> deleteLeaveRequest(String requestId) async {
    try {
      await _deleteLeaveRequestUseCase(requestId);
      emit(LeaveRequestCreated('Đơn xin nghỉ phép đã được xóa thành công!'));
    } catch (e) {
      emit(LeaveRequestError('Lỗi khi xóa đơn xin nghỉ: $e'));
    }
  }
}
