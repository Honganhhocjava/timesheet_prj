import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_project/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:timesheet_project/features/requests/presentation/cubit/requests_state.dart';
import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/entities/attendance_adjustment_entity.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';
import 'package:timesheet_project/features/requests/presentation/pages/request_detail_page.dart';

class CreatedByMePage extends StatefulWidget {
  const CreatedByMePage({super.key});

  @override
  State<CreatedByMePage> createState() => _CreatedByMePageState();
}

class _CreatedByMePageState extends State<CreatedByMePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RequestsCubit>()..loadCreatedByMeRequests(),
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
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {},
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
                                const Text('Created by me'),
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
                      const Tab(text: 'Sent to me'),
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
                      final managerMap = state is RequestsLoadedWithUserNames
                          ? state
                                .userMap // This contains manager names
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
                ];

                if (_selectedFilter != 'All') {
                  allRequests = allRequests.where((request) {
                    if (_selectedFilter == 'Xin nghỉ phép') {
                      return request.isLeaveRequest;
                    } else if (_selectedFilter == 'Điều chỉnh chấm công') {
                      return request.isAttendanceAdjustment;
                    } else if (_selectedFilter == 'Làm thêm giờ') {
                      return request.isOvertimeRequest;
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

  Widget _buildSentToMeTab() {
    return BlocProvider(
      create: (context) => getIt<RequestsCubit>()..loadSentToMeRequests(),
      child: Column(
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
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
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
                  final userMap = state is RequestsLoadedWithUserNames
                      ? state.userMap
                      : <String, String>{};

                  var allRequests = [
                    ...leaveRequests.map(
                      (req) => RequestItem(
                        id: req.id,
                        userName:
                            userMap[req.idUser] ??
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
                        userName:
                            userMap[adj.idUser] ??
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
                        userName:
                            userMap[req.idUser] ??
                            'User ${req.idUser.substring(0, 8)}',
                        reason: req.reason,
                        status: req.status.toString().split('.').last,
                        createdAt: req.createdAt,
                        requestType: 'overtime',
                        overtimeDate: req.overtimeDate,
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
                          }
                          return true;
                        }).toList();
                      }

                      // Sort by creation date (newest first)
                      allRequests.sort(
                        (a, b) => b.createdAt.compareTo(a.createdAt),
                      );

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
                        return _SentToMeListTile(request: request);
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: null,
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
    }
    return 'Đơn yêu cầu';
  }

  String _getDateRange(RequestItem request) {
    if (request.isLeaveRequest && request.startDate != null) {
      if (request.endDate != null) {
        final isSameDay =
            request.startDate!.year == request.endDate!.year &&
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
    }
    return '';
  }
}

class _SentToMeListTile extends StatelessWidget {
  final RequestItem request;

  const _SentToMeListTile({required this.request});

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
    if (request.isLeaveRequest) {
      return 'Đơn xin nghỉ phép';
    } else if (request.isAttendanceAdjustment) {
      return 'Đơn điều chỉnh chấm công';
    } else if (request.isOvertimeRequest) {
      return 'Đơn xin làm thêm giờ';
    }
    return 'Đơn yêu cầu';
  }

  String _getDateRange(RequestItem request) {
    if (request.isLeaveRequest && request.startDate != null) {
      if (request.endDate != null) {
        final isSameDay =
            request.startDate!.year == request.endDate!.year &&
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
    }
    return '';
  }
}

// Reuse RequestItem class from sent_to_me_page.dart
class RequestItem {
  final String id;
  final String userName; // In created by me context, this is manager name
  final String reason;
  final String status;
  final DateTime createdAt;
  final String requestType; // 'leave', 'attendance', 'overtime'
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? adjustmentDate;
  final DateTime? overtimeDate;

  bool get isLeaveRequest => requestType == 'leave';

  bool get isAttendanceAdjustment => requestType == 'attendance';

  bool get isOvertimeRequest => requestType == 'overtime';

  RequestItem({
    required this.id,
    required this.userName,
    required this.reason,
    required this.status,
    required this.createdAt,
    required this.requestType,
    this.startDate,
    this.endDate,
    this.adjustmentDate,
    this.overtimeDate,
  });

  factory RequestItem.leave(LeaveRequestEntity request, [String? managerName]) {
    return RequestItem(
      id: request.id,
      userName: managerName ?? 'Manager ${request.idManager.substring(0, 8)}',
      reason: request.reason,
      status: request.status.toString().split('.').last,
      createdAt: request.createdAt,
      requestType: 'leave',
      startDate: request.startDate,
      endDate: request.endDate,
    );
  }

  factory RequestItem.attendance(
    AttendanceAdjustmentEntity adjustment, [
    String? managerName,
  ]) {
    return RequestItem(
      id: adjustment.id,
      userName:
          managerName ?? 'Manager ${adjustment.idManager.substring(0, 8)}',
      reason: adjustment.reason,
      status: adjustment.status.toString().split('.').last,
      createdAt: adjustment.createdAt,
      requestType: 'attendance',
      adjustmentDate: adjustment.adjustmentDate,
    );
  }

  factory RequestItem.overtime(
    OvertimeRequestEntity overtime, [
    String? managerName,
  ]) {
    return RequestItem(
      id: overtime.id,
      userName: managerName ?? 'Manager ${overtime.idManager.substring(0, 8)}',
      reason: overtime.reason,
      status: overtime.status.toString().split('.').last,
      createdAt: overtime.createdAt,
      requestType: 'overtime',
      overtimeDate: overtime.overtimeDate,
    );
  }
}
