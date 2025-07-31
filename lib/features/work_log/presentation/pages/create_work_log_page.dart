import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_project/features/leave_request/presentation/pages/top_snackbar.dart';
import 'package:timesheet_project/features/work_log/presentation/cubit/work_log_cubit.dart';
import 'package:timesheet_project/features/work_log/presentation/cubit/work_log_state.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

class CreateWorkLogPage extends StatelessWidget {
  const CreateWorkLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WorkLogCubit>()..initializeForm(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A357D),
          title: const Text(
            'Log Work',
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
        body: BlocListener<WorkLogCubit, WorkLogState>(
          listener: (context, state) {
            if (state is WorkLogCreated) {
              TopSnackbar.showGreen(context, state.message);
              Navigator.pop(context);
            } else if (state is WorkLogError) {
              TopSnackbar.show(context, state.message);
            }
          },
          child: BlocBuilder<WorkLogCubit, WorkLogState>(
            builder: (context, state) {
              if (state is WorkLogFormState) {
                return _buildForm(context, state);
              } else if (state is WorkLogInitial || state is WorkLogLoading) {
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

  Widget _buildForm(BuildContext context, WorkLogFormState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ngày làm việc*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildDateField(
            context,
            selectedDate: state.workDate,
            hintText: 'Chọn ngày làm việc',
            onTap: () => _selectWorkDate(context),
            errorText: state.workDateError,
          ),
          const SizedBox(height: 20),

          const Text(
            'Giờ check-in*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildTimeField(
            context,
            selectedTime: state.checkInTime,
            hintText: 'Chọn giờ check-in',
            onTap: () => _selectCheckInTime(context),
            errorText: state.checkInTimeError,
          ),
          const SizedBox(height: 20),

          const Text(
            'Giờ check-out*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildTimeField(
            context,
            selectedTime: state.checkOutTime,
            hintText: 'Chọn giờ check-out',
            onTap: () => _selectCheckOutTime(context),
            errorText: state.checkOutTimeError,
          ),
          const SizedBox(height: 20),

          const Text(
            'Ghi chú',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 8),
          _buildNotesField(context, state.notes),
          const SizedBox(height: 20),

          // Approver
          const Text(
            'Người duyệt*',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Chọn người quản lý để duyệt work log',
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
                  : () => context.read<WorkLogCubit>().submitWorkLog(),
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
                      'Gửi Work Log',
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

  Widget _buildNotesField(BuildContext context, String notes) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        initialValue: notes,
        maxLines: 4,
        onChanged: (value) {
          context.read<WorkLogCubit>().updateNotes(value);
        },
        decoration: const InputDecoration(
          hintText: 'Nhập ghi chú về work log (tùy chọn)...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildManagerDropdown(
    BuildContext context,
    WorkLogFormState state,
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
                context.read<WorkLogCubit>().selectManager(manager);
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

  Future<void> _selectWorkDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
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
      context.read<WorkLogCubit>().updateWorkDate(picked);
    }
  }

  Future<void> _selectCheckInTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
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
      context.read<WorkLogCubit>().updateCheckInTime(picked);
    }
  }

  Future<void> _selectCheckOutTime(BuildContext context) async {
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
      context.read<WorkLogCubit>().updateCheckOutTime(picked);
    }
  }
}
