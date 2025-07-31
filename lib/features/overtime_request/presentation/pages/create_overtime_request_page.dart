import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_project/features/leave_request/presentation/pages/top_snackbar.dart';
import 'package:timesheet_project/features/overtime_request/presentation/cubit/overtime_request_cubit.dart';
import 'package:timesheet_project/features/overtime_request/presentation/cubit/overtime_request_state.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

class CreateOvertimeRequestPage extends StatelessWidget {
  const CreateOvertimeRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OvertimeRequestCubit>()..initializeForm(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A357D),
          title: const Text(
            'Đơn xin làm thêm giờ',
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
        body: BlocListener<OvertimeRequestCubit, OvertimeRequestState>(
          listener: (context, state) {
            if (state is OvertimeRequestCreated) {
              TopSnackbar.showGreen(context, state.message);
              Navigator.pop(context);
            } else if (state is OvertimeRequestError) {
              TopSnackbar.show(context, state.message);
            }
          },
          child: BlocBuilder<OvertimeRequestCubit, OvertimeRequestState>(
            builder: (context, state) {
              if (state is OvertimeRequestFormState) {
                return _buildForm(context, state);
              } else if (state is OvertimeRequestInitial ||
                  state is OvertimeRequestLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0A357D)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, OvertimeRequestFormState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ngày làm thêm giờ*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildDateField(
            context,
            selectedDate: state.overtimeDate,
            hintText: 'Click to select a date',
            onTap: () => _selectOvertimeDate(context),
            errorText: state.overtimeDateError,
          ),
          const SizedBox(height: 20),

          const Text(
            'Thời gian bắt đầu làm*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildTimeField(
            context,
            selectedTime: state.startTime,
            hintText: 'Select time',
            onTap: () => _selectStartTime(context),
            errorText: state.startTimeError,
          ),
          const SizedBox(height: 20),

          const Text(
            'Thời gian kết thúc làm*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildTimeField(
            context,
            selectedTime: state.endTime,
            hintText: 'Select time',
            onTap: () => _selectEndTime(context),
            errorText: state.endTimeError,
          ),
          const SizedBox(height: 20),

          // Lý do làm thêm giờ
          const Text(
            'Lý do làm thêm giờ*',
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
                        .read<OvertimeRequestCubit>()
                        .submitOvertimeRequest(),
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
                      'Gửi đơn xin làm thêm giờ',
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
              context.read<OvertimeRequestCubit>().updateReason(value);
            },
            decoration: const InputDecoration(
              hintText: 'Nhập lý do làm thêm giờ...',
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
    OvertimeRequestFormState state,
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
              hintText: '@to tag your direct manager',
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
                context.read<OvertimeRequestCubit>().selectManager(manager);
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

  Future<void> _selectOvertimeDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
      context.read<OvertimeRequestCubit>().updateOvertimeDate(picked);
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0), // Default 6 PM
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
      context.read<OvertimeRequestCubit>().updateStartTime(picked);
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 0), // Default 8 PM
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
      context.read<OvertimeRequestCubit>().updateEndTime(picked);
    }
  }
}
