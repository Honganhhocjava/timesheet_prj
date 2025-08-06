import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:timesheet_project/features/attendance/presentation/cubit/timesheets_cubit.dart';
import 'package:timesheet_project/features/attendance/presentation/cubit/timesheets_state.dart';

class TimesheetsPage extends StatelessWidget {
  const TimesheetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<TimesheetsCubit>()..loadMonthlyData(DateTime.now()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A357D),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Timesheets',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Content Container
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: BlocBuilder<TimesheetsCubit, TimesheetsState>(
                    builder: (context, state) {
                      if (state is TimesheetsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0A357D),
                          ),
                        );
                      }

                      if (state is TimesheetsError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Lỗi: ${state.message}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<TimesheetsCubit>()
                                    .loadMonthlyData(DateTime.now()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0A357D),
                                ),
                                child: const Text(
                                  'Thử lại',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is TimesheetsLoaded) {
                        return _buildSplitLayout(context, state);
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplitLayout(BuildContext context, TimesheetsLoaded state) {
    return Column(
      children: [
        // Top section - Calendar
        Expanded(flex: 3, child: _buildTimesheetSection(context, state)),
        // Divider
        Container(height: 1, color: Colors.grey.shade300),
        // Bottom section - Day details
        Expanded(flex: 2, child: _buildDayDetailsSection(context, state)),
      ],
    );
  }

  Widget _buildTimesheetSection(BuildContext context, TimesheetsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFF0A357D)),
                onPressed: () {
                  final previousMonth = DateTime(
                    state.selectedMonth.year,
                    state.selectedMonth.month - 1,
                  );
                  context.read<TimesheetsCubit>().changeMonth(previousMonth);
                },
              ),
              Text(
                DateFormat('MMMM yyyy').format(state.selectedMonth),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A357D),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Color(0xFF0A357D)),
                onPressed: () {
                  final nextMonth = DateTime(
                    state.selectedMonth.year,
                    state.selectedMonth.month + 1,
                  );
                  context.read<TimesheetsCubit>().changeMonth(nextMonth);
                },
              ),
            ],
          ),
          //    const SizedBox(height: 8),

          // Calendar
          Divider(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      TableCalendar<AttendanceDayStatus>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: state.selectedMonth,
                        currentDay: DateTime.now(),
                        calendarFormat: CalendarFormat.month,
                        eventLoader: (day) {
                          final status = state.dayStatusMap[day];
                          return status != null ? [status] : [];
                        },
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        daysOfWeekHeight: 20,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarStyle: const CalendarStyle(
                          outsideDaysVisible: false,
                          weekendTextStyle: TextStyle(color: Colors.grey),
                          holidayTextStyle: TextStyle(color: Colors.red),
                          defaultTextStyle: TextStyle(color: Colors.black),
                          todayTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          selectedTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Color(0xFF00C2FF),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Color(0xFF0A357D),
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          leftChevronVisible: false,
                          rightChevronVisible: false,
                          titleTextStyle: TextStyle(fontSize: 0),
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            return _buildCalendarDay(context, day, state);
                          },
                          todayBuilder: (context, day, focusedDay) {
                            return _buildCalendarDay(
                              context,
                              day,
                              state,
                              isToday: true,
                            );
                          },
                          selectedBuilder: (context, day, focusedDay) {
                            return _buildCalendarDay(
                              context,
                              day,
                              state,
                              isSelected: true,
                            );
                          },
                          outsideBuilder: (context, day, focusedDay) {
                            return Container();
                          },
                        ),
                        selectedDayPredicate: (day) {
                          return state.selectedDay != null &&
                              _isSameDay(day, state.selectedDay!);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          context.read<TimesheetsCubit>().selectDay(
                            selectedDay,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      _buildLegend(),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetailsSection(BuildContext context, TimesheetsLoaded state) {
    final selectedDay = state.selectedDay;
    final dayDetails = state.dayDetails;

    if (selectedDay == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'Chọn ngày để xem chi tiết',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event, color: Color(0xFF0A357D), size: 20),
              SizedBox(width: 6.0),
              Text(
                DateFormat('dd/MM/yyyy').format(selectedDay),
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A357D),
                ),
              ),
              Spacer(),
              // Add request button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Add request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (dayDetails == null)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(child: _buildDayContent(dayDetails)),
        ],
      ),
    );
  }

  Widget _buildDayContent(DayDetails dayDetails) {
    switch (dayDetails.status) {
      case AttendanceDayStatus.hasApprovedRequest:
        return _buildApprovedDayContent(dayDetails);
      case AttendanceDayStatus.hasPendingRequest:
        return _buildPendingDayContent(dayDetails);
      case AttendanceDayStatus.hasRejectedRequest:
        return _buildRejectedDayContent(dayDetails);
      case AttendanceDayStatus.noData:
        return _buildNoDataContent();
      default:
        return _buildNormalDayContent(dayDetails);
    }
  }

  Widget _buildApprovedDayContent(DayDetails dayDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Check-in time
        Text(
          'Check-in: 09:10:20',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        SizedBox(height: 8),
        // Check-out time with green background
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Check-out: 17:00:00',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        // Request details
        if (dayDetails.hasEvents) ...[
          _buildEventSection(
            'Đơn xin nghỉ phép',
            dayDetails.leaveRequests,
            Icons.time_to_leave,
          ),
          SizedBox(height: 12),
          _buildEventSection(
            'Đơn điều chỉnh chấm công',
            dayDetails.attendanceAdjustments,
            Icons.edit_calendar,
          ),
          SizedBox(height: 12),
          _buildEventSection(
            'Đơn xin làm thêm giờ',
            dayDetails.overtimeRequests,
            Icons.access_time,
          ),
        ],
      ],
    );
  }

  Widget _buildPendingDayContent(DayDetails dayDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show request details with pending status
        if (dayDetails.hasEvents) ...[
          _buildEventSection(
            'Đơn xin nghỉ phép',
            dayDetails.leaveRequests,
            Icons.time_to_leave,
          ),
          SizedBox(height: 12),
          _buildEventSection(
            'Đơn điều chỉnh chấm công',
            dayDetails.attendanceAdjustments,
            Icons.edit_calendar,
          ),
          SizedBox(height: 12),
          _buildEventSection(
            'Đơn xin làm thêm giờ',
            dayDetails.overtimeRequests,
            Icons.access_time,
          ),
        ],
      ],
    );
  }

  Widget _buildRejectedDayContent(DayDetails dayDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show rejected request details
        if (dayDetails.hasEvents) ...[
          _buildEventSection(
            'Đơn xin nghỉ phép',
            dayDetails.leaveRequests,
            Icons.time_to_leave,
          ),
          SizedBox(height: 12),
          _buildEventSection(
            'Đơn điều chỉnh chấm công',
            dayDetails.attendanceAdjustments,
            Icons.edit_calendar,
          ),
          SizedBox(height: 12),
          _buildEventSection(
            'Đơn xin làm thêm giờ',
            dayDetails.overtimeRequests,
            Icons.access_time,
          ),
        ],
      ],
    );
  }

  Widget _buildNoDataContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            'No data',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalDayContent(DayDetails dayDetails) {
    if (!dayDetails.hasEvents) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.grey.shade400, size: 40),
            SizedBox(height: 8),
            Text(
              'Không có đơn nào cho ngày này',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  _getStatusDescription(dayDetails.status),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dayDetails.leaveRequests.isNotEmpty) ...[
            _buildEventSection(
              'Đơn xin nghỉ phép',
              dayDetails.leaveRequests,
              Icons.time_to_leave,
            ),
            SizedBox(height: 12),
          ],
          if (dayDetails.attendanceAdjustments.isNotEmpty) ...[
            _buildEventSection(
              'Đơn điều chỉnh chấm công',
              dayDetails.attendanceAdjustments,
              Icons.edit_calendar,
            ),
            SizedBox(height: 12),
          ],
          if (dayDetails.overtimeRequests.isNotEmpty) ...[
            _buildEventSection(
              'Đơn xin làm thêm giờ',
              dayDetails.overtimeRequests,
              Icons.access_time,
            ),
          ],
        ],
      ),
    );
  }

  String _getStatusDescription(AttendanceDayStatus status) {
    switch (status) {
      case AttendanceDayStatus.normal:
        return 'Ngày bình thường';
      case AttendanceDayStatus.hasApprovedRequest:
        return 'Có đơn được duyệt';
      case AttendanceDayStatus.hasPendingRequest:
        return 'Có đơn đang chờ xử lý';
      case AttendanceDayStatus.hasRejectedRequest:
        return 'Có đơn bị từ chối';
      case AttendanceDayStatus.noData:
        return 'Cần tạo đơn xin phép';
    }
  }

  Widget _buildEventSection(String title, List events, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFF0A357D), size: 18),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A357D),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ...events.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < events.length - 1 ? 8 : 0,
              ),
              child: _buildEventItem(event),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEventItem(dynamic event) {
    String status = 'Đang chờ';
    Color statusColor = Colors.orange;
    String? reason;
    String? note;

    // Handle different event types and their properties
    try {
      final eventStatus = event.status?.toString() ?? 'pending';
      switch (eventStatus) {
        case 'approved':
          status = 'Đã duyệt';
          statusColor = Colors.green;
          break;
        case 'rejected':
          status = 'Đã từ chối';
          statusColor = Colors.red;
          break;
        case 'pending':
        default:
          status = 'Đang chờ';
          statusColor = Colors.orange;
      }

      // Try to get reason and note from different entity types
      if (event.reason != null) {
        reason = event.reason.toString();
      } else if (event.leaveReason != null) {
        reason = event.leaveReason.toString();
      } else if (event.adjustmentReason != null) {
        reason = event.adjustmentReason.toString();
      } else if (event.overtimeReason != null) {
        reason = event.overtimeReason.toString();
      }

      // Remove note access since it doesn't exist in entities
      // if (event.note != null) {
      //   note = event.note.toString();
      // } else if (event.notes != null) {
      //   note = event.notes.toString();
      // }
    } catch (e) {
      // Handle any property access errors gracefully
      debugPrint('Error accessing event properties: $e');
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (reason != null && reason.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              'Lý do: $reason',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
          if (note != null && note.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              'Ghi chú: $note',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCalendarDay(
    BuildContext context,
    DateTime day,
    TimesheetsLoaded state, {
    bool isToday = false,
    bool isSelected = false,
  }) {
    final status = state.dayStatusMap[day] ?? AttendanceDayStatus.normal;
    Color? backgroundColor;
    Color textColor = Colors.black;

    switch (status) {
      case AttendanceDayStatus.hasApprovedRequest:
        backgroundColor = Colors.green.shade400;
        textColor = Colors.white;
        break;
      case AttendanceDayStatus.hasPendingRequest:
        backgroundColor = Colors.orange.shade400;
        textColor = Colors.white;
        break;
      case AttendanceDayStatus.hasRejectedRequest:
        backgroundColor = Colors.red.shade400;
        textColor = Colors.white;
        break;
      case AttendanceDayStatus.normal:
        backgroundColor = null;
        break;
      case AttendanceDayStatus.noData:
        if (day.weekday != DateTime.saturday &&
            day.weekday != DateTime.sunday) {
          backgroundColor = Colors.red.shade400;
          textColor = Colors.white;
        }
        break;
    }

    if (isToday && backgroundColor == null) {
      backgroundColor = const Color(0xFF00C2FF);
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => context.read<TimesheetsCubit>().selectDay(day),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: const Color(0xFF0A357D), width: 2)
              : isToday && backgroundColor != const Color(0xFF00C2FF)
              ? Border.all(color: const Color(0xFF00C2FF), width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: textColor,
              fontWeight: isSelected
                  ? FontWeight.bold
                  : (isToday ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(color: Colors.green.shade400, label: 'Đã duyệt'),
        _buildLegendItem(color: Colors.orange.shade400, label: 'Đang chờ'),
        _buildLegendItem(color: Colors.red.shade400, label: 'Từ chối'),
        _buildLegendItem(
          color: Colors.transparent,
          label: 'Bình thường',
          border: Border.all(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    Border? border,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: border,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
