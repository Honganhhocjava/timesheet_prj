import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_project/features/attendance/domain/entities/calendar_day_requests.dart';
import 'package:timesheet_project/features/attendance/presentation/cubit/calendar_requests_cubit.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:timesheet_project/features/user/domain/repositories/user_repository.dart';

import 'package:timesheet_project/core/enums/request_enums.dart';

class LeaveRequest {
  final DateTime date;
  final String note;
  final RequestStatus status;

  final String type; // thêm dòng này
  final Map<String, dynamic> request; // và dòng này

  LeaveRequest({
    required this.date,
    required this.note,
    required this.status,
    required this.type,
    required this.request,
  });
}

class TimesheetCalendarPage extends StatelessWidget {
  const TimesheetCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarRequestsCubit()..fetchAllRequests(),
      child: _TimesheetCalendarPageBody(),
    );
  }
}

class _TimesheetCalendarPageBody extends StatefulWidget {
  @override
  State<_TimesheetCalendarPageBody> createState() =>
      _TimesheetCalendarPageBodyState();
}

class _TimesheetCalendarPageBodyState
    extends State<_TimesheetCalendarPageBody> {
  DateTime focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<DateTime, CalendarDayRequests> _requestsByDay = {};

  List<LeaveRequest> _getRequestsForDay(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);
    final dayRequests = _requestsByDay[key];
    if (dayRequests == null) return [];
    final List<LeaveRequest> result = [];
    for (final req in dayRequests.leaveRequests) {
      req['type'] = 'leave';
      result.add(LeaveRequest(
        date: key,
        note: req['reason'] ?? req['note'] ?? '',
        status: _mapStatus(req['status']),
        type: 'leave',
        request: req,
      ));
    }
    for (final req in dayRequests.overtimeRequests) {
      req['type'] = 'overtime';
      result.add(LeaveRequest(
        date: key,
        note: req['reason'] ?? req['note'] ?? 'Làm thêm giờ',
        status: _mapStatus(req['status']),
        type: 'overtime',
        request: req,
      ));
    }
    for (final req in dayRequests.attendanceAdjustments) {
      req['type'] = 'attendance';
      result.add(LeaveRequest(
        date: key,
        note: req['reason'] ?? req['note'] ?? 'Điều chỉnh công',
        status: _mapStatus(req['status']),
        type: 'attendance',
        request: req,
      ));
    }
    for (final req in dayRequests.workLogs) {
      req['type'] = 'worklog';
      result.add(LeaveRequest(
        date: key,
        note: req['notes'] ?? '',
        status: _mapStatus(req['status']),
        type: 'worklog',
        request: req,
      ));
    }
    return result;
  }

  RequestStatus _mapStatus(dynamic status) {
    final s = (status ?? '').toString().toLowerCase();
    if (s == 'approved') return RequestStatus.approved;
    if (s == 'sent' || s == 'pending') return RequestStatus.pending;
    if (s == 'rejected' || s == 'cancelled') return RequestStatus.rejected;
    return RequestStatus.pending;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarRequestsCubit, CalendarRequestsState>(
      builder: (context, state) {
        if (state is CalendarRequestsLoaded) {
          _requestsByDay = state.requestsByDay;
        }
        final selectedRequests =
            _selectedDay != null ? _getRequestsForDay(_selectedDay!) : [];
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF003E83),
                  child: Column(
                    children: [
                      const SizedBox(height: 44),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Center(
                          child: Text(
                            "Timesheets",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_left,
                                color: Color(0xFF4481C6),
                              ),
                              onPressed: () {
                                setState(() {
                                  focusedDay = DateTime(
                                    focusedDay.year,
                                    focusedDay.month - 1,
                                  );
                                });
                              },
                            ),
                            Text(
                              '${DateFormat.MMMM('vi_VN').format(focusedDay)[0].toUpperCase()}${DateFormat.MMMM('vi_VN').format(focusedDay).substring(1)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_right,
                                color: Color(0xFF4481C6),
                              ),
                              onPressed: () {
                                setState(() {
                                  focusedDay = DateTime(
                                    focusedDay.year,
                                    focusedDay.month + 1,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      TableCalendar(
                        availableGestures: AvailableGestures.none,
                        headerVisible: false,
                        locale: 'vi_VN',
                        firstDay: DateTime.utc(2021, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Color(0xFF4481C6),
                            fontWeight: FontWeight.bold,
                          ),
                          weekendStyle: TextStyle(
                            color: Color(0xFF4481C6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        focusedDay: focusedDay,
                        selectedDayPredicate: (day) =>
                            _selectedDay != null &&
                            day.year == _selectedDay!.year &&
                            day.month == _selectedDay!.month &&
                            day.day == _selectedDay!.day,
                        calendarFormat: _calendarFormat,
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            this.focusedDay = focusedDay;
                          });
                        },
                        calendarStyle: const CalendarStyle(
                          defaultTextStyle: TextStyle(color: Colors.white),
                          weekendTextStyle: TextStyle(color: Colors.white),
                          outsideTextStyle: TextStyle(color: Color(0xFF4481C6)),
                          todayDecoration: BoxDecoration(
                            color: Color(0xFFC2F4FF),
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: TextStyle(color: Colors.black),
                          selectedDecoration:
                              BoxDecoration(shape: BoxShape.circle),
                          selectedTextStyle: TextStyle(color: Colors.blue),
                        ),
                        calendarBuilders: CalendarBuilders(
                          selectedBuilder: (context, day, focusedDay) {
                            final key =
                                DateTime.utc(day.year, day.month, day.day);
                            final dayRequests = _requestsByDay[key];
                            String? status;
                            if (dayRequests != null) {
                              if (dayRequests.leaveRequests.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.rejected) ||
                                  dayRequests.overtimeRequests.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.rejected) ||
                                  dayRequests.attendanceAdjustments.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.rejected) ||
                                  dayRequests.workLogs.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.rejected)) {
                                status = 'rejected';
                              } else if (dayRequests.leaveRequests.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.pending) ||
                                  dayRequests.overtimeRequests.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.pending) ||
                                  dayRequests.attendanceAdjustments.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.pending) ||
                                  dayRequests.workLogs.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.pending)) {
                                status = 'pending';
                              } else if (dayRequests.leaveRequests.isNotEmpty ||
                                  dayRequests.overtimeRequests.isNotEmpty ||
                                  dayRequests
                                      .attendanceAdjustments.isNotEmpty ||
                                  dayRequests.workLogs.isNotEmpty) {
                                status = 'approved';
                              }
                            }
                            Color bgColor;
                            switch (status) {
                              case 'pending':
                                bgColor = Color(0xFFFF9800);
                                break;
                              case 'approved':
                                bgColor = Color(0xFF19D02C);
                                break;
                              case 'rejected':
                                bgColor = Color(0xFFFA3333);
                                break;
                              default:
                                bgColor = Colors.grey.shade300;
                            }
                            return Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: bgColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(
                                  color: Color(0xFF4481C6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                          defaultBuilder: (context, day, focusedDay) {
                            final key =
                                DateTime.utc(day.year, day.month, day.day);
                            final dayRequests = _requestsByDay[key];
                            String? status;
                            if (dayRequests != null) {
                              if (dayRequests.leaveRequests.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.rejected) ||
                                  dayRequests.overtimeRequests.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.rejected) ||
                                  dayRequests.attendanceAdjustments.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.rejected) ||
                                  dayRequests.workLogs.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.rejected)) {
                                status = 'rejected';
                              } else if (dayRequests.leaveRequests.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.pending) ||
                                  dayRequests.overtimeRequests.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.pending) ||
                                  dayRequests.attendanceAdjustments.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.pending) ||
                                  dayRequests.workLogs.any((e) =>
                                      _mapStatus(e['status']) ==
                                      RequestStatus.pending)) {
                                status = 'pending';
                              } else if (dayRequests.leaveRequests.isNotEmpty ||
                                  dayRequests.overtimeRequests.isNotEmpty ||
                                  dayRequests
                                      .attendanceAdjustments.isNotEmpty ||
                                  dayRequests.workLogs.isNotEmpty) {
                                status = 'approved';
                              }
                            }
                            if (status != null) {
                              return Container(
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Color(0xFF4481C6),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      if (selectedRequests.isNotEmpty)
                        Column(
                          children: [
                            for (final req in selectedRequests)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: _RequestListTileVN(
                                  request: req.request,
                                  type: req.type,
                                  date: req.date,
                                  status: req.status.toString().split('.').last,
                                  isLogWork: req.type == 'worklog',
                                ),
                              ),
                          ],
                        )
                      else
                        Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Center(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/image/chamcong.svg',
                                  width: 60,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  // <- Text có thể là const nếu không thay đổi
                                  'Nhấn vào ngày để xem chi tiết',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RequestListTileVN extends StatelessWidget {
  final Map<String, dynamic> request;
  final String type;
  final DateTime date;
  final String status;
  final bool isLogWork;

  const _RequestListTileVN({
    required this.request,
    required this.type,
    required this.date,
    required this.status,
    this.isLogWork = false,
  });

  Future<String?> _getAvatarUrl(String userId) async {
    final repo = getIt<UserRepository>();
    final user = await repo.getUserData(userId);
    return user?.avatarUrl;
  }

  Future<String> _getName(String userId) async {
    final repo = getIt<UserRepository>();
    final user = await repo.getUserData(userId);

    if (user == null) return 'Không rõ';

    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';
    return '$firstName $lastName'.trim();
  }

  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Người dùng chưa đăng nhập');
    return user.uid;
  }

  @override
  // Widget build(BuildContext context) {
  //   final userId = request['idUser'] ?? '';
  //   return FutureBuilder<String?>(
  //     future: _getAvatarUrl(userId),
  //     builder: (context, snapshot) {
  //       final avatarUrl = snapshot.data;
  //       return Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(right: 8, top: 4),
  //             child: CircleAvatar(
  //               radius: 20,
  //               backgroundColor: Colors.grey[200],
  //               backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
  //                   ? NetworkImage(avatarUrl)
  //                   : null,
  //               child: (avatarUrl == null || avatarUrl.isEmpty)
  //                   ? Icon(Icons.person, size: 24, color: Colors.grey)
  //                   : null,
  //             ),
  //
  //           ),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 RichText(
  //                   text: TextSpan(
  //                     style: const TextStyle(
  //                         color: Color(0xFF6B7280), fontSize: 15),
  //                     children: [
  //                       const TextSpan(
  //                         text: 'Bạn đã tạo 1 yêu cầu ',
  //                         style: TextStyle(fontWeight: FontWeight.w500),
  //                       ),
  //                       TextSpan(
  //                         text: _getRequestTypeVN(type),
  //                         style: const TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             color: Color(0xFF0A357D)),
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             ' ngày ${_weekdayVN(date.weekday)} ngày ${_formatDate(date)}',
  //                         style: const TextStyle(fontWeight: FontWeight.w500),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 2),
  //                 Text(
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                   request['reason'] ??
  //                       request['note'] ??
  //                       request['notes'] ??
  //                       '',
  //                   style:
  //                       const TextStyle(fontSize: 15, color: Color(0xFF111827)),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Container(
  //                       margin: const EdgeInsets.only(top: 4, right: 8),
  //                       padding: const EdgeInsets.symmetric(
  //                           horizontal: 8, vertical: 2),
  //                       decoration: BoxDecoration(
  //                         color: _statusColorVN(status),
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       child: Text(
  //                         _statusTextVN(status),
  //                         style: const TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                     Text(
  //                       _getRequestTypeVN(type),
  //                       style: const TextStyle(
  //                           fontSize: 13,
  //                           color: Color(0xFF0A357D),
  //                           fontWeight: FontWeight.w600),
  //                     ),
  //                   ],
  //                 ),
  //                 if (isLogWork)
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 6),
  //                     child: Row(
  //                       children: [
  //                         Text('Vào: ',
  //                             style: TextStyle(
  //                                 color: Color(0xFF6B7280),
  //                                 fontWeight: FontWeight.w500)),
  //                         Text(_formatTime(request['checkInTime']),
  //                             style: TextStyle(fontWeight: FontWeight.bold)),
  //                         SizedBox(width: 16),
  //                         Container(
  //                           padding: EdgeInsets.symmetric(
  //                               horizontal: 12, vertical: 6),
  //                           decoration: BoxDecoration(
  //                             color: Color(0xFF19D02C),
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                           child: Row(
  //                             children: [
  //                               Text('Ra: ',
  //                                   style: TextStyle(color: Colors.white)),
  //                               Text(_formatTime(request['checkOutTime']),
  //                                   style: TextStyle(
  //                                       color: Colors.white,
  //                                       fontWeight: FontWeight.bold)),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    //final userId = request['idUser'] ?? '';
    final userId = getCurrentUserId();

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        _getAvatarUrl(userId),
        // _getName(userId),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // hoặc Skeleton loader tuỳ bạn
        }

        final avatarUrl = snapshot.data?[0] as String?;
        //final userName = snapshot.data?[1] as String? ?? 'Không rõ';

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 4),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? NetworkImage(avatarUrl)
                    : null,
                child: (avatarUrl == null || avatarUrl.isEmpty)
                    ? const Icon(Icons.person, size: 24, color: Colors.grey)
                    : null,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          color: Color(0xFF6B7280), fontSize: 15),
                      children: [
                        TextSpan(
                          text: 'Bạn đã tạo 1 yêu cầu ',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: _getRequestTypeVN(type),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A357D)),
                        ),
                        TextSpan(
                          text:
                              ' vào ${_weekdayVN(date.weekday)}, ngày ${_formatDate(date)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    request['reason'] ??
                        request['note'] ??
                        request['notes'] ??
                        '',
                    style:
                        const TextStyle(fontSize: 15, color: Color(0xFF111827)),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4, right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _statusColorVN(status),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _statusTextVN(status),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        _getRequestTypeVN(type),
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF0A357D),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  if (isLogWork)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Text('Vào: ',
                              style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500)),
                          Text(_formatTime(request['checkInTime']),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF19D02C),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Text('Ra: ',
                                    style: TextStyle(color: Colors.white)),
                                Text(_formatTime(request['checkOutTime']),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _getRequestTypeVN(String type) {
    switch (type) {
      case 'leave':
        return 'nghỉ phép';
      case 'overtime':
        return 'làm thêm giờ';
      case 'attendance':
        return 'điều chỉnh công';
      case 'worklog':
        return 'nhật ký công việc';
      default:
        return '';
    }
  }

  String _weekdayVN(int weekday) {
    const weekdays = ['CN', '2', '3', '4', '5', '6', '7'];
    return 'thứ ${weekdays[weekday % 7]}';
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatTime(dynamic t) {
    if (t is String && t.contains(':')) return t;
    if (t is Map && t['hour'] != null && t['minute'] != null) {
      return '${t['hour'].toString().padLeft(2, '0')}:${t['minute'].toString().padLeft(2, '0')}:00';
    }
    return '--:--:--';
  }

  Color _statusColorVN(String status) {
    // switch (status.toLowerCase()) {
    //   case 'pending':
    //     return Colors.orange;
    //   case 'approved':
    //     return Colors.green;
    //   case 'cancelled':
    //     return Colors.red;
    //   default:
    //     return Colors.orange;
    // }
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  String _statusTextVN(String status) {
    switch (status) {
      case 'approved':
        return 'đã duyệt';
      case 'rejected':
        return 'đã từ chối';
      case 'cancelled':
        return 'đã hủy';
      default:
        return 'chờ duyệt';
    }
  }
}
