import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/features/overtime_request/domain/usecases/create_overtime_request_usecase.dart';
import 'package:timesheet_project/features/overtime_request/domain/usecases/get_managers_usecase.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';
import 'package:timesheet_project/features/overtime_request/presentation/cubit/overtime_request_state.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

class OvertimeRequestCubit extends Cubit<OvertimeRequestState> {
  final CreateOvertimeRequestUsecase _createOvertimeRequestUsecase;
  final GetManagersUsecase _getManagersUsecase;

  OvertimeRequestCubit(
    this._createOvertimeRequestUsecase,
    this._getManagersUsecase,
  ) : super(OvertimeRequestInitial());

  void initializeForm() async {
    emit(OvertimeRequestFormState(isLoading: true));
    try {
      final managers = await _getManagersUsecase(NoParams());
      emit(OvertimeRequestFormState(managers: managers));
    } catch (e) {
      emit(OvertimeRequestError('Lỗi khi tải danh sách quản lý: $e'));
    }
  }

  void updateOvertimeDate(DateTime date) {
    if (state is OvertimeRequestFormState) {
      final currentState = state as OvertimeRequestFormState;
      emit(currentState.copyWith(overtimeDate: date, overtimeDateError: null));
    }
  }

  void updateStartTime(TimeOfDay time) {
    if (state is OvertimeRequestFormState) {
      final currentState = state as OvertimeRequestFormState;
      emit(currentState.copyWith(startTime: time, startTimeError: null));
    }
  }

  void updateEndTime(TimeOfDay time) {
    if (state is OvertimeRequestFormState) {
      final currentState = state as OvertimeRequestFormState;
      emit(currentState.copyWith(endTime: time, endTimeError: null));
    }
  }

  void updateReason(String reason) {
    if (state is OvertimeRequestFormState) {
      final currentState = state as OvertimeRequestFormState;
      emit(currentState.copyWith(reason: reason, reasonError: null));
    }
  }

  void selectManager(UserEntity manager) {
    if (state is OvertimeRequestFormState) {
      final currentState = state as OvertimeRequestFormState;
      emit(currentState.copyWith(selectedManager: manager, managerError: null));
    }
  }

  Future<void> submitOvertimeRequest() async {
    if (state is! OvertimeRequestFormState) return;

    final formState = state as OvertimeRequestFormState;

    // Reset validation errors
    String? overtimeDateError;
    String? startTimeError;
    String? endTimeError;
    String? reasonError;
    String? managerError;
    bool hasError = false;

    if (formState.overtimeDate == null) {
      overtimeDateError = 'Vui lòng chọn ngày làm thêm giờ';
      hasError = true;
    }

    if (formState.startTime == null) {
      startTimeError = 'Vui lòng chọn thời gian bắt đầu làm';
      hasError = true;
    }

    if (formState.endTime == null) {
      endTimeError = 'Vui lòng chọn thời gian kết thúc làm';
      hasError = true;
    }

    if (formState.reason.trim().isEmpty) {
      reasonError = 'Vui lòng nhập lý do làm thêm giờ';
      hasError = true;
    }

    if (formState.selectedManager == null) {
      managerError = 'Vui lòng chọn người duyệt';
      hasError = true;
    }

    // Validation: Giờ bắt đầu phải nhỏ hơn giờ kết thúc
    if (formState.startTime != null && formState.endTime != null) {
      final startMinutes =
          formState.startTime!.hour * 60 + formState.startTime!.minute;
      final endMinutes =
          formState.endTime!.hour * 60 + formState.endTime!.minute;

      if (startMinutes >= endMinutes) {
        startTimeError = 'Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc';
        hasError = true;
      }
    }

    // Validation: Ngày làm thêm giờ không được là ngày quá khứ
    if (formState.overtimeDate != null) {
      final today = DateTime.now();
      final selectedDate = formState.overtimeDate!;

      if (selectedDate.isBefore(DateTime(today.year, today.month, today.day))) {
        overtimeDateError = 'Không thể chọn ngày làm thêm giờ ở quá khứ';
        hasError = true;
      }
    }

    // Update form state with validation errors
    emit(
      formState.copyWith(
        overtimeDateError: overtimeDateError,
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
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(OvertimeRequestError('Người dùng chưa đăng nhập'));
        return;
      }

      final activityLog = ActivityLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        action: 'Đơn xin làm thêm giờ được tạo',
        userId: currentUser.uid,
        userRole: 'Nhân viên',
        timestamp: DateTime.now(),
      );

      final overtimeRequest = OvertimeRequestEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        idUser: currentUser.uid,
        idManager: formState.selectedManager!.uid,
        status: RequestStatus.pending,
        overtimeDate: formState.overtimeDate!,
        startTime: formState.startTime!,
        endTime: formState.endTime!,
        reason: formState.reason.trim(),
        activitiesLog: [activityLog],
        createdAt: DateTime.now(),
      );

      await _createOvertimeRequestUsecase(overtimeRequest);
      emit(
        OvertimeRequestCreated('Đơn xin làm thêm giờ đã được tạo thành công!'),
      );
    } catch (e, s) {
      print(e);
      print(s);
      emit(OvertimeRequestError('Lỗi khi tạo đơn xin làm thêm giờ: $e'));
      emit(formState.copyWith(isLoading: false));
    }
  }

  void resetState() {
    emit(OvertimeRequestInitial());
  }
}
