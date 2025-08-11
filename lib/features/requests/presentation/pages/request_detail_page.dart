import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_project/features/requests/presentation/pages/created_by_me_page.dart';
import 'package:timesheet_project/features/leave_request/presentation/pages/top_snackbar.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:timesheet_project/features/leave_request/domain/repositories/leave_request_repository.dart';
import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/overtime_request/domain/repositories/overtime_request_repository.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/repositories/attendance_adjustment_repository.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/entities/attendance_adjustment_entity.dart';
import 'package:timesheet_project/features/work_log/domain/repositories/work_log_repository.dart';
import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

class RequestDetailPage extends StatefulWidget {
  final RequestItem request;
  final bool isFromSentToMe;

  const RequestDetailPage({
    super.key,
    required this.request,
    this.isFromSentToMe = false,
  });

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  final TextEditingController _rejectionReasonController =
      TextEditingController();
  bool _isProcessing = false;
  bool _isLoading = true;

  // Detailed request data
  LeaveRequestEntity? _leaveRequest;
  OvertimeRequestEntity? _overtimeRequest;
  AttendanceAdjustmentEntity? _attendanceAdjustment;
  WorkLogEntity? _workLog;

  @override
  void initState() {
    super.initState();
    _loadDetailedRequest();
  }

  @override
  void dispose() {
    _rejectionReasonController.dispose();
    super.dispose();
  }

  Future<void> _loadDetailedRequest() async {
    try {
      if (widget.request.isLeaveRequest) {
        final repository = getIt<LeaveRequestRepository>();
        _leaveRequest = await repository.getLeaveRequestById(widget.request.id);
      } else if (widget.request.isOvertimeRequest) {
        final repository = getIt<OvertimeRequestRepository>();
        _overtimeRequest = await repository.getOvertimeRequestById(
          widget.request.id,
        );
      } else if (widget.request.isAttendanceAdjustment) {
        final repository = getIt<AttendanceAdjustmentRepository>();
        _attendanceAdjustment = await repository.getAttendanceAdjustmentById(
          widget.request.id,
        );
      } else if (widget.request.isWorkLog) {
        final repository = getIt<WorkLogRepository>();
        _workLog = await repository.getWorkLogById(widget.request.id);
      }
    } catch (e) {
      TopSnackbar.show(context, 'Lỗi khi tải thông tin chi tiết: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isManager = widget.isFromSentToMe &&
        widget.request.status.toLowerCase() == 'pending';
    final isCreator = !widget.isFromSentToMe &&
        widget.request.status.toLowerCase() == 'pending';

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A357D),
        title: Text(
          _getRequestTitle(),
          style: const TextStyle(
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0A357D)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  _buildStatusCard(),
                  const SizedBox(height: 16),

                  // Request Details
                  _buildDetailsCard(),
                  const SizedBox(height: 16),

                  // Activity Logs (if available)
                  if (_hasActivityLogs()) _buildActivityLogsCard(),

                  // Manager Actions (only for managers on pending requests)
                  if (isManager &&
                      widget.request.status.toLowerCase() == 'pending')
                    _buildManagerActions(),

                  // Employee Actions (only for creators and pending requests)
                  if (isCreator &&
                      widget.request.status.toLowerCase() == 'pending')
                    _buildEmployeeActions(),
                ],
              ),
            ),
    );
  }

  String _getRequestTitle() {
    if (widget.request.isLeaveRequest) {
      return 'Chi tiết đơn nghỉ phép';
    } else if (widget.request.isAttendanceAdjustment) {
      return 'Chi tiết đơn điều chỉnh chấm công';
    } else if (widget.request.isOvertimeRequest) {
      return 'Chi tiết đơn làm thêm giờ';
    }
    return 'Chi tiết đơn yêu cầu';
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
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
      child: Row(
        children: [
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.request.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(widget.request.status),
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  _getStatusText(widget.request.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            'Tạo ngày: ${DateFormat('dd/MM/yyyy').format(widget.request.createdAt)}',
            style: const TextStyle(
              color: Color(0xFF0A357D),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
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
          Text(
            _getRequestTitle(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 16),

          // Display detailed information based on request type
          if (widget.request.isLeaveRequest && _leaveRequest != null)
            _buildLeaveRequestDetails(_leaveRequest!)
          else if (widget.request.isOvertimeRequest && _overtimeRequest != null)
            _buildOvertimeRequestDetails(_overtimeRequest!)
          else if (widget.request.isAttendanceAdjustment &&
              _attendanceAdjustment != null)
            _buildAttendanceAdjustmentDetails(_attendanceAdjustment!)
          else
            _buildBasicDetails(),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestDetails(LeaveRequestEntity request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Request ID
        _buildDetailRow(Icons.tag, 'Mã đơn', request.id.substring(0, 8)),

        if (widget.isFromSentToMe)
          _buildDetailRow(
            Icons.person,
            'Người gửi đơn',
            widget.request.userName,
          )
        else
          _buildDetailRow(Icons.work, 'Người quản lý', widget.request.userName),

        // Start Date+
        _buildDetailRow(
          Icons.calendar_today,
          'Ngày bắt đầu',
          DateFormat('dd/MM/yyyy').format(request.startDate),
        ),

        // End Date
        _buildDetailRow(
          Icons.calendar_today,
          'Ngày kết thúc',
          DateFormat('dd/MM/yyyy').format(request.endDate),
        ),

        // Start Time
        _buildDetailRow(
          Icons.access_time,
          'Giờ bắt đầu',
          '${request.startTime.hour.toString().padLeft(2, '0')}:${request.startTime.minute.toString().padLeft(2, '0')}',
        ),

        // End Time
        _buildDetailRow(
          Icons.access_time,
          'Giờ kết thúc',
          '${request.endTime.hour.toString().padLeft(2, '0')}:${request.endTime.minute.toString().padLeft(2, '0')}',
        ),

        // Number of days
        _buildDetailRow(
          Icons.date_range,
          'Số ngày nghỉ',
          _calculateLeaveDays(
            request.startDate,
            request.endDate,
          ).toString(),
        ),

        // Reason
        _buildDetailRow(Icons.description, 'Lý do', request.reason),
      ],
    );
  }

  Widget _buildOvertimeRequestDetails(OvertimeRequestEntity request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Request ID
        _buildDetailRow(Icons.tag, 'Mã đơn', request.id.substring(0, 8)),

        // User info - show different labels based on context
        if (widget.isFromSentToMe)
          _buildDetailRow(
            Icons.person,
            'Người gửi đơn',
            widget.request.userName,
          )
        else
          _buildDetailRow(Icons.work, 'Người quản lý', widget.request.userName),

        // Overtime Date
        _buildDetailRow(
          Icons.calendar_today,
          'Ngày làm thêm',
          DateFormat('dd/MM/yyyy').format(request.overtimeDate),
        ),

        // Start Time
        _buildDetailRow(
          Icons.access_time,
          'Giờ bắt đầu',
          '${request.startTime.hour.toString().padLeft(2, '0')}:${request.startTime.minute.toString().padLeft(2, '0')}',
        ),

        // End Time
        _buildDetailRow(
          Icons.access_time,
          'Giờ kết thúc',
          '${request.endTime.hour.toString().padLeft(2, '0')}:${request.endTime.minute.toString().padLeft(2, '0')}',
        ),

        // Overtime Hours
        _buildDetailRow(
          Icons.schedule,
          'Số giờ làm thêm',
          _calculateOvertimeHours(
            request.startTime,
            request.endTime,
          ).toString(),
        ),

        // Reason
        _buildDetailRow(Icons.description, 'Lý do', request.reason),
      ],
    );
  }

  Widget _buildAttendanceAdjustmentDetails(AttendanceAdjustmentEntity request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Request ID
        _buildDetailRow(Icons.tag, 'Mã đơn', request.id.substring(0, 8)),

        // User info - show different labels based on context
        if (widget.isFromSentToMe)
          _buildDetailRow(
            Icons.person,
            'Người gửi đơn',
            widget.request.userName,
          )
        else
          _buildDetailRow(Icons.work, 'Người quản lý', widget.request.userName),

        // Adjustment Date
        _buildDetailRow(
          Icons.calendar_today,
          'Ngày điều chỉnh',
          DateFormat('dd/MM/yyyy').format(request.adjustmentDate),
        ),

        // Original Check-in Time
        _buildDetailRow(
          Icons.login,
          'Giờ check-in gốc',
          '${request.originalCheckIn.hour.toString().padLeft(2, '0')}:${request.originalCheckIn.minute.toString().padLeft(2, '0')}',
        ),

        // Original Check-out Time
        _buildDetailRow(
          Icons.logout,
          'Giờ check-out gốc',
          '${request.originalCheckOut.hour.toString().padLeft(2, '0')}:${request.originalCheckOut.minute.toString().padLeft(2, '0')}',
        ),

        // Adjusted Check-in Time
        _buildDetailRow(
          Icons.login,
          'Giờ check-in điều chỉnh',
          '${request.adjustedCheckIn.hour.toString().padLeft(2, '0')}:${request.adjustedCheckIn.minute.toString().padLeft(2, '0')}',
        ),

        // Adjusted Check-out Time
        _buildDetailRow(
          Icons.logout,
          'Giờ check-out điều chỉnh',
          '${request.adjustedCheckOut.hour.toString().padLeft(2, '0')}:${request.adjustedCheckOut.minute.toString().padLeft(2, '0')}',
        ),

        // Reason
        _buildDetailRow(Icons.description, 'Lý do', request.reason),
      ],
    );
  }

  Widget _buildBasicDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Request ID
        _buildDetailRow(Icons.tag, 'Mã đơn', widget.request.id.substring(0, 8)),
        if (widget.isFromSentToMe)
          _buildDetailRow(
            Icons.person,
            'Người gửi đơn',
            widget.request.userName,
          )
        else
          _buildDetailRow(Icons.work, 'Người quản lý', widget.request.userName),

        if (_getDateRange().isNotEmpty)
          _buildDetailRow(Icons.calendar_today, 'Thời gian', _getDateRange()),

        // Reason
        _buildDetailRow(Icons.description, 'Lý do', widget.request.reason),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagerActions() {
    return Container(
      width: double.infinity,
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
          // const Text(
          //   'Hành động quản lý',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16,
          //     color: Color(0xFF0A357D),
          //   ),
          // ),
          // const SizedBox(height: 16),

          Row(
            children: [
              // Approve Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : () => _handleApprove(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Chấp nhận'),
                ),
              ),
              const SizedBox(width: 12),
              // Reject Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : () => _showRejectDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Từ chối'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _handleCancel(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.block),
            label: const Text('Hủy đơn'),
          ),
        ),
      ],
    );
  }

  void _handleApprove() async {
    setState(() => _isProcessing = true);

    try {
      // Get the appropriate repository based on request type
      if (widget.request.isLeaveRequest) {
        final repository = getIt<LeaveRequestRepository>();
        await repository.updateLeaveRequestStatus(
          widget.request.id,
          RequestStatus.approved,
          null,
        );
      } else if (widget.request.isOvertimeRequest) {
        final repository = getIt<OvertimeRequestRepository>();
        await repository.updateOvertimeRequestStatus(
          widget.request.id,
          RequestStatus.approved,
          null,
        );
      } else if (widget.request.isAttendanceAdjustment) {
        final repository = getIt<AttendanceAdjustmentRepository>();
        await repository.updateAttendanceAdjustmentStatus(
          widget.request.id,
          RequestStatus.approved,
          null,
        );
      } else if (widget.request.isWorkLog) {
        final repository = getIt<WorkLogRepository>();
        await repository.updateWorkLogStatus(
          widget.request.id,
          RequestStatus.approved,
          null,
        );
      }

      TopSnackbar.showGreen(context, 'Đã chấp nhận đơn thành công');
      Navigator.pop(context, true);
    } catch (e) {
      TopSnackbar.show(context, 'Lỗi khi chấp nhận đơn: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Từ chối đơn'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Vui lòng nhập lý do từ chối:'),
            const SizedBox(height: 16),
            TextField(
              controller: _rejectionReasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Nhập lý do từ chối...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_rejectionReasonController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _handleReject(_rejectionReasonController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Từ chối', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleReject(String reason) async {
    setState(() => _isProcessing = true);

    try {
      // Get the appropriate repository based on request type
      if (widget.request.isLeaveRequest) {
        final repository = getIt<LeaveRequestRepository>();
        await repository.updateLeaveRequestStatus(
          widget.request.id,
          RequestStatus.rejected,
          reason,
        );
      } else if (widget.request.isOvertimeRequest) {
        final repository = getIt<OvertimeRequestRepository>();
        await repository.updateOvertimeRequestStatus(
          widget.request.id,
          RequestStatus.rejected,
          reason,
        );
      } else if (widget.request.isAttendanceAdjustment) {
        final repository = getIt<AttendanceAdjustmentRepository>();
        await repository.updateAttendanceAdjustmentStatus(
          widget.request.id,
          RequestStatus.rejected,
          reason,
        );
      } else if (widget.request.isWorkLog) {
        final repository = getIt<WorkLogRepository>();
        await repository.updateWorkLogStatus(
          widget.request.id,
          RequestStatus.rejected,
          reason,
        );
      }

      TopSnackbar.showGreen(context, 'Đã từ chối đơn');
      Navigator.pop(context, true);
    } catch (e) {
      TopSnackbar.show(context, 'Lỗi khi từ chối đơn: $e');
      print(e);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _handleCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy đơn'),
        content: const Text('Bạn có chắc muốn hủy đơn này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hủy đơn', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isProcessing = true);

      try {
        // Get the appropriate repository based on request type
        if (widget.request.isLeaveRequest) {
          final repository = getIt<LeaveRequestRepository>();
          await repository.updateLeaveRequestStatus(
            widget.request.id,
            RequestStatus.cancelled,
            null,
          );
        } else if (widget.request.isOvertimeRequest) {
          final repository = getIt<OvertimeRequestRepository>();
          await repository.updateOvertimeRequestStatus(
            widget.request.id,
            RequestStatus.cancelled,
            null,
          );
        } else if (widget.request.isAttendanceAdjustment) {
          final repository = getIt<AttendanceAdjustmentRepository>();
          await repository.updateAttendanceAdjustmentStatus(
            widget.request.id,
            RequestStatus.cancelled,
            null,
          );
        }

        TopSnackbar.showGreen(context, 'Đã hủy đơn');
        Navigator.pop(context, true); // Return true to indicate refresh needed
      } catch (e) {
        TopSnackbar.show(context, 'Lỗi khi hủy đơn: $e');
      } finally {
        setState(() => _isProcessing = false);
      }
    }
  }

  String _getDateRange() {
    if (widget.request.isLeaveRequest && widget.request.startDate != null) {
      if (widget.request.endDate != null) {
        final isSameDay = widget.request.startDate!.year ==
                widget.request.endDate!.year &&
            widget.request.startDate!.month == widget.request.endDate!.month &&
            widget.request.startDate!.day == widget.request.endDate!.day;

        if (isSameDay) {
          return 'Ngày ${DateFormat('dd/MM/yyyy').format(widget.request.startDate!)}';
        } else {
          return 'Từ ${DateFormat('dd/MM/yyyy').format(widget.request.startDate!)} đến ${DateFormat('dd/MM/yyyy').format(widget.request.endDate!)}';
        }
      }
      return 'Ngày ${DateFormat('dd/MM/yyyy').format(widget.request.startDate!)}';
    } else if (widget.request.isAttendanceAdjustment &&
        widget.request.adjustmentDate != null) {
      return 'Ngày ${DateFormat('dd/MM/yyyy').format(widget.request.adjustmentDate!)}';
    } else if (widget.request.isOvertimeRequest &&
        widget.request.overtimeDate != null) {
      return 'Ngày ${DateFormat('dd/MM/yyyy').format(widget.request.overtimeDate!)}';
    }
    return '';
  }

  String _getTimeDetails() {
    if (widget.request.isLeaveRequest) {
      // For leave requests, we might want to show start and end times if available
      // This would require additional fields in RequestItem
      return '';
    } else if (widget.request.isOvertimeRequest) {
      // For overtime requests, we might want to show overtime hours
      return '';
    } else if (widget.request.isAttendanceAdjustment) {
      // For attendance adjustments, we might want to show the adjustment time
      return '';
    }
    return '';
  }

  int _calculateLeaveDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays + 1;
  }

  int _calculateOvertimeHours(TimeOfDay startTime, TimeOfDay endTime) {
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;
    int difference = endMinutes - startMinutes;
    return difference ~/ 60; // Convert minutes to hours
  }

  bool _hasActivityLogs() {
    return false;
  }

  Widget _buildActivityLogsCard() {
    return Container(
      width: double.infinity,
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
          const Text(
            'Lịch sử hoạt động',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF0A357D),
            ),
          ),
          const SizedBox(height: 12),
          // Activity logs will be displayed here when available
          const Text(
            'Chưa có hoạt động nào',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
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
        return 'Đang chờ duyệt';
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
}
