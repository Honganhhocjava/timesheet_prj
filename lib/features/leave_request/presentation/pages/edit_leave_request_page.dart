import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/leave_request/presentation/cubit/leave_request_cubit.dart';
import 'package:timesheet_project/features/leave_request/presentation/cubit/leave_request_state.dart';
import 'package:timesheet_project/features/leave_request/presentation/pages/top_snackbar.dart';

class EditLeaveRequestPage extends StatefulWidget {
  final LeaveRequestEntity request;

  const EditLeaveRequestPage({super.key, required this.request});

  @override
  State<EditLeaveRequestPage> createState() => _EditLeaveRequestPageState();
}

class _EditLeaveRequestPageState extends State<EditLeaveRequestPage> {
  @override
  void initState() {
    super.initState();
    // Load the request data into the form
    context.read<LeaveRequestCubit>().loadRequestForEdit(widget.request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LeaveRequestCubit>()..initializeForm(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A357D),
          title: const Text(
            'Sửa đơn nghỉ phép',
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
        body: BlocConsumer<LeaveRequestCubit, LeaveRequestState>(
          listener: (context, state) {
            if (state is LeaveRequestCreated) {
              TopSnackbar.show(context, state.message);
              Navigator.pop(
                context,
                true,
              ); // Return true to indicate refresh needed
            } else if (state is LeaveRequestError) {
              TopSnackbar.show(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is LeaveRequestFormState) {
              return _buildForm(context, state);
            }
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0A357D)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, LeaveRequestFormState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Start Date
          _buildDateField(
            context,
            selectedDate: state.startDate,
            hintText: 'Chọn ngày bắt đầu nghỉ',
            onTap: () => _selectStartDate(context),
            errorText: state.startDateError,
          ),
          const SizedBox(height: 16),

          // End Date
          _buildDateField(
            context,
            selectedDate: state.endDate,
            hintText: 'Chọn ngày kết thúc nghỉ',
            onTap: () => _selectEndDate(context),
            errorText: state.endDateError,
          ),
          const SizedBox(height: 16),

          // Start Time
          _buildTimeField(
            context,
            selectedTime: state.startTime,
            hintText: 'Chọn giờ bắt đầu nghỉ',
            onTap: () => _selectStartTime(context),
            errorText: state.startTimeError,
          ),
          const SizedBox(height: 16),

          // End Time
          _buildTimeField(
            context,
            selectedTime: state.endTime,
            hintText: 'Chọn giờ kết thúc nghỉ',
            onTap: () => _selectEndTime(context),
            errorText: state.endTimeError,
          ),
          const SizedBox(height: 16),

          // Reason
          _buildReasonField(context, state),
          const SizedBox(height: 16),

          // Manager Dropdown
          _buildManagerDropdown(context, state),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<LeaveRequestCubit>().updateLeaveRequest(
                        widget.request,
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A357D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Cập nhật đơn',
                      style: TextStyle(
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

  Widget _buildReasonField(BuildContext context, LeaveRequestFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  state.reasonError != null ? Colors.red : Colors.grey.shade300,
            ),
          ),
          child: TextFormField(
            controller: TextEditingController(text: state.reason),
            onChanged: (value) =>
                context.read<LeaveRequestCubit>().updateReason(value),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Nhập lý do nghỉ phép...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
        if (state.reasonError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              state.reasonError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildManagerDropdown(
    BuildContext context,
    LeaveRequestFormState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: state.managerError != null
                  ? Colors.red
                  : Colors.grey.shade300,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: state.selectedManager?.uid,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Chọn người duyệt',
            ),
            items: state.managers.map((manager) {
              return DropdownMenuItem(
                value: manager.uid,
                child: Text('${manager.firstName} ${manager.lastName}'),
              );
            }).toList(),
            onChanged: (value) {
              final selectedManager = state.managers.firstWhere(
                (m) => m.uid == value,
              );
              context.read<LeaveRequestCubit>().selectManager(selectedManager);
            },
          ),
        ),
        if (state.managerError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              state.managerError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final currentState = context.read<LeaveRequestCubit>().state;
    if (currentState is LeaveRequestFormState) {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: currentState.startDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (selectedDate != null) {
        context.read<LeaveRequestCubit>().updateStartDate(selectedDate);
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final currentState = context.read<LeaveRequestCubit>().state;
    if (currentState is LeaveRequestFormState) {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: currentState.endDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (selectedDate != null) {
        context.read<LeaveRequestCubit>().updateEndDate(selectedDate);
      }
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final currentState = context.read<LeaveRequestCubit>().state;
    if (currentState is LeaveRequestFormState) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime:
            currentState.startTime ?? const TimeOfDay(hour: 9, minute: 0),
      );
      if (selectedTime != null) {
        context.read<LeaveRequestCubit>().updateStartTime(selectedTime);
      }
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final currentState = context.read<LeaveRequestCubit>().state;
    if (currentState is LeaveRequestFormState) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime:
            currentState.endTime ?? const TimeOfDay(hour: 17, minute: 0),
      );
      if (selectedTime != null) {
        context.read<LeaveRequestCubit>().updateEndTime(selectedTime);
      }
    }
  }
}
