import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_project/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:timesheet_project/features/requests/presentation/cubit/requests_state.dart';
import 'package:timesheet_project/features/requests/presentation/pages/created_by_me_page.dart';
import 'package:timesheet_project/features/requests/presentation/pages/request_detail_page.dart';

class SentToMePage extends StatefulWidget {
  const SentToMePage({super.key});

  @override
  State<SentToMePage> createState() => _SentToMePageState();
}

class _SentToMePageState extends State<SentToMePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  late final RequestsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<RequestsCubit>()
      ..loadSentToMeRequests()
      ..loadCreatedByMeRequests();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A357D),
          title: const Text(
            'Lists of request',
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
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.settings, color: Colors.white),
              onSelected: (value) {
                _cubit.updateStatusFilter(value);
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'all', child: Text('Tất cả trạng thái')),
                PopupMenuItem(value: 'pending', child: Text('Đang chờ')),
                PopupMenuItem(value: 'approved', child: Text('Đã duyệt')),
                PopupMenuItem(value: 'rejected', child: Text('Từ chối')),
                PopupMenuItem(value: 'cancelled', child: Text('Đã hủy')),
              ],
            ),
          ],
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFF00C2FF),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    dividerColor: Colors.transparent,
                    tabs: [
                      const Tab(text: 'Created by me'),
                      BlocBuilder<RequestsCubit, RequestsState>(
                        builder: (context, state) {
                          int count = 0;
                          if (state is RequestsLoaded) {
                            count = state.totalCount;
                          }
                          return Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Sent to me'),
                                if (count > 0) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      count.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Created by me tab
            _buildCreatedByMeTab(),
            // Sent to me tab
            _buildSentToMeTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSentToMeTab() {
    return Column(
      children: [
        // Filter Tabs
        SizedBox(
          height: 60,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Xin nghỉ phép'),
                _buildFilterChip('Điều chỉnh chấm công'),
                _buildFilterChip('Làm thêm giờ'),
                _buildFilterChip('Nhật ký công việc'),
              ],
            ),
          ),
        ),
        // Request List
        Expanded(
          child: BlocBuilder<RequestsCubit, RequestsState>(
            builder: (context, state) {
              print('DEBUG: Current state type: ${state.runtimeType}');

              if (state is RequestsLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0A357D)),
                );
              }

              if (state is RequestsError) {
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
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<RequestsCubit>()
                            .loadSentToMeRequests(),
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

              if (state is RequestsLoaded ||
                  state is RequestsLoadedWithUserNames) {
                final leaveRequests = state is RequestsLoadedWithUserNames
                    ? state.leaveRequests
                    : (state as RequestsLoaded).leaveRequests;
                final attendanceAdjustments =
                    state is RequestsLoadedWithUserNames
                        ? state.attendanceAdjustments
                        : (state as RequestsLoaded).attendanceAdjustments;
                final overtimeRequests = state is RequestsLoadedWithUserNames
                    ? state.overtimeRequests
                    : (state as RequestsLoaded).overtimeRequests;
                final workLogs = state is RequestsLoadedWithUserNames
                    ? state.workLogs
                    : (state as RequestsLoaded).workLogs;
                final userMap = state is RequestsLoadedWithUserNames
                    ? state.userMap
                    : <String, String>{};

                var allRequests = [
                  ...leaveRequests.map(
                    (req) => RequestItem(
                      id: req.id,
                      userName: userMap[req.idUser] ??
                          'User ${req.idUser.substring(0, 8)}',
                      reason: req.reason,
                      status: req.status.toString().split('.').last,
                      createdAt: req.createdAt,
                      requestType: 'leave',
                      startDate: req.startDate,
                      endDate: req.endDate,
                    ),
                  ),
                  ...attendanceAdjustments.map(
                    (adj) => RequestItem(
                      id: adj.id,
                      userName: userMap[adj.idUser] ??
                          'User ${adj.idUser.substring(0, 8)}',
                      reason: adj.reason,
                      status: adj.status.toString().split('.').last,
                      createdAt: adj.createdAt,
                      requestType: 'attendance',
                      adjustmentDate: adj.adjustmentDate,
                    ),
                  ),
                  ...overtimeRequests.map(
                    (req) => RequestItem(
                      id: req.id,
                      userName: userMap[req.idUser] ??
                          'User ${req.idUser.substring(0, 8)}',
                      reason: req.reason,
                      status: req.status.toString().split('.').last,
                      createdAt: req.createdAt,
                      requestType: 'overtime',
                      overtimeDate: req.overtimeDate,
                    ),
                  ),
                  ...workLogs.map(
                    (workLog) => RequestItem(
                      id: workLog.id,
                      userName: userMap[workLog.idUser] ??
                          'User ${workLog.idUser.substring(0, 8)}',
                      reason: workLog.notes ??
                          'Work log for ${DateFormat('dd/MM/yyyy').format(workLog.workDate)}',
                      status: workLog.status.toString().split('.').last,
                      createdAt: workLog.createdAt,
                      requestType: 'work_log',
                      workDate: workLog.workDate,
                    ),
                  ),
                ];

                if (_selectedFilter != 'All') {
                  allRequests = allRequests.where((request) {
                    if (_selectedFilter == 'Xin nghỉ phép') {
                      return request.isLeaveRequest;
                    } else if (_selectedFilter == 'Điều chỉnh chấm công') {
                      return request.isAttendanceAdjustment;
                    } else if (_selectedFilter == 'Làm thêm giờ') {
                      return request.isOvertimeRequest;
                    } else if (_selectedFilter == 'Nhật ký công việc') {
                      return request.isWorkLog;
                    }
                    return true;
                  }).toList();
                }

                // Sort by creation date (newest first)
                allRequests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (allRequests.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          color: Colors.grey,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Không có đơn nào được gửi cho bạn',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<RequestsCubit>().loadSentToMeRequests();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: allRequests.length,
                    itemBuilder: (context, index) {
                      final request = allRequests[index];
                      return _RequestListTile(request: request);
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCreatedByMeTab() {
    return Column(
      children: [
        // Filter Tabs
        SizedBox(
          height: 60,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Xin nghỉ phép'),
                _buildFilterChip('Điều chỉnh chấm công'),
                _buildFilterChip('Làm thêm giờ'),
                _buildFilterChip('Nhật ký công việc'),
              ],
            ),
          ),
        ),
        // Request List
        Expanded(
          child: BlocBuilder<RequestsCubit, RequestsState>(
            builder: (context, state) {
              if (state is RequestsLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0A357D)),
                );
              }

              if (state is RequestsError) {
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
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<RequestsCubit>()
                            .loadCreatedByMeRequests(),
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

              if (state is RequestsLoaded ||
                  state is RequestsLoadedWithUserNames) {
                final leaveRequests = state is RequestsLoadedWithUserNames
                    ? state.leaveRequests
                    : (state as RequestsLoaded).leaveRequests;
                final attendanceAdjustments =
                    state is RequestsLoadedWithUserNames
                        ? state.attendanceAdjustments
                        : (state as RequestsLoaded).attendanceAdjustments;
                final overtimeRequests = state is RequestsLoadedWithUserNames
                    ? state.overtimeRequests
                    : (state as RequestsLoaded).overtimeRequests;
                final workLogs = state is RequestsLoadedWithUserNames
                    ? state.workLogs
                    : (state as RequestsLoaded).workLogs;
                final managerMap = state is RequestsLoadedWithUserNames
                    ? state.userMap // This contains manager names
                    : <String, String>{};

                var allRequests = [
                  ...leaveRequests.map(
                    (req) => RequestItem.leave(req, managerMap[req.idManager]),
                  ),
                  ...attendanceAdjustments.map(
                    (adj) =>
                        RequestItem.attendance(adj, managerMap[adj.idManager]),
                  ),
                  ...overtimeRequests.map(
                    (req) =>
                        RequestItem.overtime(req, managerMap[req.idManager]),
                  ),
                  ...workLogs.map(
                    (workLog) => RequestItem.workLog(
                        workLog, managerMap[workLog.idManager]),
                  ),
                ];

                if (_selectedFilter != 'All') {
                  allRequests = allRequests.where((request) {
                    if (_selectedFilter == 'Xin nghỉ phép') {
                      return request.isLeaveRequest;
                    } else if (_selectedFilter == 'Điều chỉnh chấm công') {
                      return request.isAttendanceAdjustment;
                    } else if (_selectedFilter == 'Làm thêm giờ') {
                      return request.isOvertimeRequest;
                    } else if (_selectedFilter == 'Nhật ký công việc') {
                      return request.isWorkLog;
                    }
                    return true;
                  }).toList();
                }
                allRequests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (allRequests.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          color: Colors.grey,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Bạn chưa tạo đơn nào',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<RequestsCubit>().loadCreatedByMeRequests();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: allRequests.length,
                    itemBuilder: (context, index) {
                      final request = allRequests[index];
                      return _CreatedByMeListTile(request: request);
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        showCheckmark: false,
        selectedColor: const Color(0xFF0A357D),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF0A357D),
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? const Color(0xFF0A357D) : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

//   Widget _buildCreatedByMeTab() {
//     return Column(
//       children: [
//         // Filter Tabs
//         SizedBox(
//           height: 60,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 _buildFilterChip('All'),
//                 _buildFilterChip('Xin nghỉ phép'),
//                 _buildFilterChip('Điều chỉnh chấm công'),
//                 _buildFilterChip('Làm thêm giờ'),
//               ],
//             ),
//           ),
//         ),
//         // Request List
//         Expanded(
//           child: BlocBuilder<RequestsCubit, RequestsState>(
//             builder: (context, state) {
//               if (state is RequestsLoading) {
//                 return const Center(
//                   child: CircularProgressIndicator(color: Color(0xFF0A357D)),
//                 );
//               }
//
//               if (state is RequestsError) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.error_outline,
//                         color: Colors.red,
//                         size: 64,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Lỗi: ${state.message}',
//                         style: const TextStyle(color: Colors.red, fontSize: 16),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () => context
//                             .read<RequestsCubit>()
//                             .loadCreatedByMeRequests(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF0A357D),
//                         ),
//                         child: const Text(
//                           'Thử lại',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//
//               if (state is RequestsLoaded ||
//                   state is RequestsLoadedWithUserNames) {
//                 final leaveRequests = state is RequestsLoadedWithUserNames
//                     ? state.leaveRequests
//                     : (state as RequestsLoaded).leaveRequests;
//                 final attendanceAdjustments =
//                     state is RequestsLoadedWithUserNames
//                     ? state.attendanceAdjustments
//                     : (state as RequestsLoaded).attendanceAdjustments;
//                 final overtimeRequests = state is RequestsLoadedWithUserNames
//                     ? state.overtimeRequests
//                     : (state as RequestsLoaded).overtimeRequests;
//                 final managerMap = state is RequestsLoadedWithUserNames
//                     ? state.userMap
//                     : <String, String>{};
//
//                 var allRequests = [
//                   ...leaveRequests.map(
//                     (req) => RequestItem.leave(req, managerMap[req.idManager]),
//                   ),
//                   ...attendanceAdjustments.map(
//                     (adj) =>
//                         RequestItem.attendance(adj, managerMap[adj.idManager]),
//                   ),
//                   ...overtimeRequests.map(
//                     (req) =>
//                         RequestItem.overtime(req, managerMap[req.idManager]),
//                   ),
//                 ];
//
//                 // Filter requests based on selected filter
//                 if (_selectedFilter != 'All') {
//                   allRequests = allRequests.where((request) {
//                     if (_selectedFilter == 'Xin nghỉ phép') {
//                       return request.isLeaveRequest;
//                     } else if (_selectedFilter == 'Điều chỉnh chấm công') {
//                       return request.isAttendanceAdjustment;
//                     } else if (_selectedFilter == 'Làm thêm giờ') {
//                       return request.isOvertimeRequest;
//                     }
//                     return true;
//                   }).toList();
//                 }
//
//                 // Sort by creation date (newest first)
//                 allRequests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//
//                 if (allRequests.isEmpty) {
//                   return const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.inbox_outlined,
//                           size: 64,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'Không có đơn nào được tạo',
//                           style: TextStyle(fontSize: 16, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: allRequests.length,
//                   itemBuilder: (context, index) {
//                     final request = allRequests[index];
//                     return _RequestListTile(request: request);
//                   },
//                 );
//               }
//
//               return const Center(child: Text('Không có dữ liệu'));
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
}

class _CreatedByMeListTile extends StatelessWidget {
  final RequestItem request;

  const _CreatedByMeListTile({required this.request});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status and date
            Row(
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(request.status),
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusText(request.status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('dd/MM/yyyy').format(request.createdAt),
                  style: const TextStyle(
                    color: Color(0xFF0A357D),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Request Title
            Text(
              _getRequestTitle(request),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0A357D),
              ),
            ),
            const SizedBox(height: 8),

            // Request Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Gửi đến: ${request.userName}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.description,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Lý do: ${request.reason}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (_getDateRange(request).isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getDateRange(request),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RequestDetailPage(request: request, isFromSentToMe: false),
      ),
    );

    // If result is true, refresh the list
    if (result == true && context.mounted) {
      context.read<RequestsCubit>().loadCreatedByMeRequests();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'cancelled':
        return Icons.block;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Đang chờ';
      case 'approved':
        return 'Đã duyệt';
      case 'rejected':
        return 'Từ chối';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không rõ';
    }
  }

  String _getRequestTitle(RequestItem request) {
    if (request.isLeaveRequest) {
      return 'Đơn xin nghỉ phép';
    } else if (request.isAttendanceAdjustment) {
      return 'Đơn điều chỉnh chấm công';
    } else if (request.isOvertimeRequest) {
      return 'Đơn xin làm thêm giờ';
    } else if (request.isWorkLog) {
      return 'Nhật ký công việc';
    }
    return 'Đơn yêu cầu';
  }

  String _getDateRange(RequestItem request) {
    if (request.isLeaveRequest && request.startDate != null) {
      if (request.endDate != null) {
        final isSameDay = request.startDate!.year == request.endDate!.year &&
            request.startDate!.month == request.endDate!.month &&
            request.startDate!.day == request.endDate!.day;

        if (isSameDay) {
          return DateFormat('dd/MM/yyyy').format(request.startDate!);
        } else {
          return '${DateFormat('dd/MM/yyyy').format(request.startDate!)} - ${DateFormat('dd/MM/yyyy').format(request.endDate!)}';
        }
      }
      return DateFormat('dd/MM/yyyy').format(request.startDate!);
    } else if (request.isAttendanceAdjustment &&
        request.adjustmentDate != null) {
      return DateFormat('dd/MM/yyyy').format(request.adjustmentDate!);
    } else if (request.isOvertimeRequest && request.overtimeDate != null) {
      return DateFormat('dd/MM/yyyy').format(request.overtimeDate!);
    } else if (request.isWorkLog && request.workDate != null) {
      return DateFormat('dd/MM/yyyy').format(request.workDate!);
    }
    return '';
  }
}

class _RequestListTile extends StatelessWidget {
  final RequestItem request;

  const _RequestListTile({required this.request});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status and date
            Row(
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(request.status),
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusText(request.status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('dd/MM/yyyy').format(request.createdAt),
                  style: const TextStyle(
                    color: Color(0xFF0A357D),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Request Title
            Text(
              _getRequestTitle(request),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0A357D),
              ),
            ),
            const SizedBox(height: 8),

            // Request Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Gửi từ: ${request.userName}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.description,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Lý do: ${request.reason}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (_getDateRange(request).isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getDateRange(request),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RequestDetailPage(request: request, isFromSentToMe: true),
      ),
    );

    // If result is true, refresh the list
    if (result == true && context.mounted) {
      context.read<RequestsCubit>().loadSentToMeRequests();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'cancelled':
        return Icons.block;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Đang chờ';
      case 'approved':
        return 'Đã duyệt';
      case 'rejected':
        return 'Từ chối';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không rõ';
    }
  }

  String _getRequestTitle(RequestItem request) {
    String baseTitle = '';
    if (request.isLeaveRequest) {
      baseTitle = 'Đơn xin nghỉ phép';
    } else if (request.isAttendanceAdjustment) {
      baseTitle = 'Đơn điều chỉnh chấm công';
    } else if (request.isOvertimeRequest) {
      baseTitle = 'Đơn xin làm thêm giờ';
    } else if (request.isWorkLog) {
      baseTitle = 'Nhật ký công việc';
    } else {
      baseTitle = 'Đơn yêu cầu';
    }

    // Add status information to the title
    if (request.status.toLowerCase() == 'rejected') {
      return '$baseTitle bị từ chối';
    } else if (request.status.toLowerCase() == 'approved') {
      return '$baseTitle được duyệt';
    } else if (request.status.toLowerCase() == 'cancelled') {
      return '$baseTitle bị hủy';
    } else {
      return baseTitle;
    }
  }

  String _getDateRange(RequestItem request) {
    if (request.isLeaveRequest && request.startDate != null) {
      if (request.endDate != null) {
        final isSameDay = request.startDate!.year == request.endDate!.year &&
            request.startDate!.month == request.endDate!.month &&
            request.startDate!.day == request.endDate!.day;

        if (isSameDay) {
          return DateFormat('dd/MM/yyyy').format(request.startDate!);
        } else {
          return '${DateFormat('dd/MM/yyyy').format(request.startDate!)} - ${DateFormat('dd/MM/yyyy').format(request.endDate!)}';
        }
      }
      return DateFormat('dd/MM/yyyy').format(request.startDate!);
    } else if (request.isAttendanceAdjustment &&
        request.adjustmentDate != null) {
      return DateFormat('dd/MM/yyyy').format(request.adjustmentDate!);
    } else if (request.isOvertimeRequest && request.overtimeDate != null) {
      return DateFormat('dd/MM/yyyy').format(request.overtimeDate!);
    } else if (request.isWorkLog && request.workDate != null) {
      return DateFormat('dd/MM/yyyy').format(request.workDate!);
    }
    return '';
  }
}
