import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_project/features/attendance_adjustment/presentation/cubit/attendance_adjustment_cubit.dart';
import 'package:timesheet_project/features/attendance_adjustment/presentation/cubit/attendance_adjustment_state.dart';
import 'package:timesheet_project/features/leave_request/presentation/pages/top_snackbar.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

class CreateAttendanceAdjustmentPage extends StatelessWidget {
  const CreateAttendanceAdjustmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AttendanceAdjustmentCubit>()..initializeForm(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A357D),
          title: const Text(
            'Đơn điều chỉnh chấm công',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        body:
            BlocListener<AttendanceAdjustmentCubit, AttendanceAdjustmentState>(
          listener: (context, state) {
            if (state is AttendanceAdjustmentCreated) {
              TopSnackbar.showGreen(context, state.message);
              Navigator.pop(context);
            } else if (state is AttendanceAdjustmentError) {
              TopSnackbar.show(context, state.message);
            }
          },
          child:
              BlocBuilder<AttendanceAdjustmentCubit, AttendanceAdjustmentState>(
            builder: (context, state) {
              if (state is AttendanceAdjustmentFormState) {
                return _buildForm(context, state);
              } else if (state is AttendanceAdjustmentInitial ||
                  state is AttendanceAdjustmentLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF0A357D),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, AttendanceAdjustmentFormState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ngày cần điều chỉnh*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildDateField(
            context,
            selectedDate: state.adjustmentDate,
            hintText: 'Chọn ngày cần điều chỉnh',
            onTap: () => _selectAdjustmentDate(context),
            errorText: state.adjustmentDateError,
          ),
          const SizedBox(height: 20),

          // Original Check-in time
          const Text(
            'Giờ vào ban đầu*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildTimeField(
            context,
            selectedTime: state.originalCheckIn,
            hintText: 'Chọn giờ vào ban đầu',
            onTap: () => _selectOriginalCheckIn(context),
            errorText: state.originalCheckInError,
          ),
          const SizedBox(height: 20),

          // Original Check-out time
          const Text(
            'Giờ ra ban đầu*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildTimeField(
            context,
            selectedTime: state.originalCheckOut,
            hintText: 'Chọn giờ ra ban đầu',
            onTap: () => _selectOriginalCheckOut(context),
            errorText: state.originalCheckOutError,
          ),
          const SizedBox(height: 20),

          // Adjusted Check-in time
          const Text(
            'Giờ vào điều chỉnh*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildTimeField(
            context,
            selectedTime: state.adjustedCheckIn,
            hintText: 'Chọn giờ vào điều chỉnh',
            onTap: () => _selectAdjustedCheckIn(context),
            errorText: state.adjustedCheckInError,
          ),
          const SizedBox(height: 20),

          // Adjusted Check-out time
          const Text(
            'Giờ ra điều chỉnh*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildTimeField(
            context,
            selectedTime: state.adjustedCheckOut,
            hintText: 'Chọn giờ ra điều chỉnh',
            onTap: () => _selectAdjustedCheckOut(context),
            errorText: state.adjustedCheckOutError,
          ),
          const SizedBox(height: 20),

          // Reason
          const Text(
            'Lý do điều chỉnh*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildReasonField(context, state.reason, state.reasonError),
          const SizedBox(height: 20),

          // Approver
          const Text(
            'Approver*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'You must send this request to your direct manager first',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          _buildManagerDropdown(context, state, state.managerError),
          const SizedBox(height: 40),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () => context
                      .read<AttendanceAdjustmentCubit>()
                      .submitAttendanceAdjustment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A357D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Gửi đơn điều chỉnh chấm công',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required DateTime? selectedDate,
    required String hintText,
    required VoidCallback onTap,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: errorText != null ? Colors.red : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(selectedDate)
                        : hintText,
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeField(
    BuildContext context, {
    required TimeOfDay? selectedTime,
    required String hintText,
    required VoidCallback onTap,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: errorText != null ? Colors.red : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedTime != null
                        ? selectedTime.format(context)
                        : hintText,
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedTime != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                Icon(Icons.access_time, color: Colors.grey.shade600, size: 20),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildReasonField(
    BuildContext context,
    String reason,
    String? errorText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
            ),
          ),
          child: TextFormField(
            initialValue: reason,
            maxLines: 6,
            onChanged: (value) {
              context.read<AttendanceAdjustmentCubit>().updateReason(value);
            },
            decoration: const InputDecoration(
              hintText: 'Nhập lý do điều chỉnh chấm công...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildManagerDropdown(
    BuildContext context,
    AttendanceAdjustmentFormState state,
    String? errorText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
            ),
          ),
          child: DropdownButtonFormField<UserEntity>(
            value: state.selectedManager,
            decoration: const InputDecoration(
              hintText: 'Chọn người duyệt',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintStyle: TextStyle(color: Colors.grey),
            ),
            items: state.managers.map((manager) {
              return DropdownMenuItem(
                value: manager,
                child: Text(
                  '${manager.firstName} ${manager.lastName} (${manager.role})',
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (UserEntity? manager) {
              if (manager != null) {
                context.read<AttendanceAdjustmentCubit>().selectManager(
                      manager,
                    );
              }
            },
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Future<void> _selectAdjustmentDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 1)),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0A357D)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<AttendanceAdjustmentCubit>().updateAdjustmentDate(picked);
    }
  }

  Future<void> _selectOriginalCheckIn(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0A357D)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<AttendanceAdjustmentCubit>().updateOriginalCheckIn(picked);
    }
  }

  Future<void> _selectOriginalCheckOut(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 17, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0A357D)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<AttendanceAdjustmentCubit>().updateOriginalCheckOut(picked);
    }
  }

  Future<void> _selectAdjustedCheckIn(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0A357D)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<AttendanceAdjustmentCubit>().updateAdjustedCheckIn(picked);
    }
  }

  Future<void> _selectAdjustedCheckOut(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 17, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0A357D)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<AttendanceAdjustmentCubit>().updateAdjustedCheckOut(picked);
    }
  }
}
