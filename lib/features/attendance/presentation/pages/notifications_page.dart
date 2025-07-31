import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timesheet_project/features/requests/presentation/pages/request_detail_page.dart';
import 'package:timesheet_project/features/requests/presentation/pages/created_by_me_page.dart';

class NotificationItem {
  final String id;
  final String type; // 'leave', 'overtime', 'attendance', 'worklog'
  final String senderId;
  final String senderName;
  final String senderAvatarUrl;
  final String title; // Tên loại đơn
  final DateTime createdAt;
  final String status; // pending/approved/rejected/cancelled
  final String reason;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? adjustmentDate;
  final DateTime? overtimeDate;

  NotificationItem({
    required this.id,
    required this.type,
    required this.senderId,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.title,
    required this.createdAt,
    required this.status,
    required this.reason,
    this.startDate,
    this.endDate,
    this.adjustmentDate,
    this.overtimeDate,
  });

  RequestItem toRequestItem() {
    return RequestItem(
      id: id,
      userName: senderName,
      reason: reason,
      status: status,
      createdAt: createdAt,
      requestType: type,
      startDate: startDate,
      endDate: endDate,
      adjustmentDate: adjustmentDate,
      overtimeDate: overtimeDate,
    );
  }
}

Future<List<NotificationItem>> fetchAllNotificationsForCurrentUser() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];
  final userId = user.uid;
  final firestore = FirebaseFirestore.instance;

  // Get current user info to determine role
  final userDoc = await firestore.collection('users').doc(userId).get();
  final userData = userDoc.data();
  final userRole = userData?['role'] ?? 'Nhân viên';

  print('DEBUG: Current user role: $userRole');
  print('DEBUG: Current user ID: $userId');

  // Determine if user is manager or employee
  final isManager = userRole == 'Quản lý';
  final fieldToQuery = isManager ? 'idManager' : 'idUser';

  print('DEBUG: Is manager: $isManager');
  print('DEBUG: Field to query: $fieldToQuery');

  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    return doc.data();
  }

  final leaveDocs = await firestore
      .collection('leave_requests')
      .where(fieldToQuery, isEqualTo: userId)
      .get();
  final overtimeDocs = await firestore
      .collection('overtime_requests')
      .where(fieldToQuery, isEqualTo: userId)
      .get();
  final attendanceDocs = await firestore
      .collection('attendance_adjustments')
      .where(fieldToQuery, isEqualTo: userId)
      .get();

  print('DEBUG: Found ${leaveDocs.docs.length} leave requests');
  print('DEBUG: Found ${overtimeDocs.docs.length} overtime requests');
  print('DEBUG: Found ${attendanceDocs.docs.length} attendance requests');

  final List<NotificationItem> notifications = [];

  Future<void> addNotificationsFromDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    String type,
    String title,
  ) async {
    for (final doc in docs) {
      final data = doc.data();
      final status = data['status'] ?? 'pending';

      print('DEBUG: Processing $type request ${doc.id} with status: $status');

      // For employees, only show notifications for status changes (not pending)
      if (!isManager) {
        if (status == 'pending') {
          print('DEBUG: Skipping pending request for employee');
          continue; // Skip pending requests for employees
        }
        print('DEBUG: Including non-pending request for employee');
      }

      final senderId = data['idUser'] ?? '';
      final managerId = data['idManager'] ?? '';

      // Get user info based on role
      String displayName;
      String avatarUrl;
      if (isManager) {
        // Manager viewing requests sent to them - show sender info
        final senderInfo = await getUserInfo(senderId);
        displayName =
            ((senderInfo?['firstName'] ?? '') +
                    ' ' +
                    (senderInfo?['lastName'] ?? ''))
                .trim();
        avatarUrl = senderInfo?['avatarUrl'] ?? '';
        print('DEBUG: Manager view - showing sender: $displayName');
      } else {
        // Employee viewing their own requests - show manager info
        final managerInfo = await getUserInfo(managerId);
        displayName =
            ((managerInfo?['firstName'] ?? '') +
                    ' ' +
                    (managerInfo?['lastName'] ?? ''))
                .trim();
        avatarUrl = managerInfo?['avatarUrl'] ?? '';
        print('DEBUG: Employee view - showing manager: $displayName');
      }

      // Parse dates based on type
      DateTime? startDate, endDate, adjustmentDate, overtimeDate;
      if (type == 'leave') {
        startDate = DateTime.tryParse(data['startDate'] ?? '');
        endDate = DateTime.tryParse(data['endDate'] ?? '');
      } else if (type == 'attendance') {
        adjustmentDate = DateTime.tryParse(data['adjustmentDate'] ?? '');
      } else if (type == 'overtime') {
        overtimeDate = DateTime.tryParse(data['overtimeDate'] ?? '');
      }

      notifications.add(
        NotificationItem(
          id: doc.id,
          type: type,
          senderId: isManager ? senderId : managerId,
          senderName: displayName,
          senderAvatarUrl: avatarUrl,
          title: title,
          createdAt:
              DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
          status: status,
          reason: data['reason'] ?? '',
          startDate: startDate,
          endDate: endDate,
          adjustmentDate: adjustmentDate,
          overtimeDate: overtimeDate,
        ),
      );

      print('DEBUG: Added notification for $type request');
    }
  }

  await addNotificationsFromDocs(leaveDocs.docs, 'leave', 'Đơn nghỉ phép');
  await addNotificationsFromDocs(
    overtimeDocs.docs,
    'overtime',
    'Đơn làm thêm giờ',
  );
  await addNotificationsFromDocs(
    attendanceDocs.docs,
    'attendance',
    'Đơn điều chỉnh chấm công',
  );

  print('DEBUG: Total notifications found: ${notifications.length}');

  notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return notifications;
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationItem>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = fetchAllNotificationsForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: const Color(0xFF0A357D),
      ),
      body: FutureBuilder<List<NotificationItem>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return const Center(child: Text('Chưa có thông báo nào'));
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final item = notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: item.senderAvatarUrl.isNotEmpty
                      ? NetworkImage(item.senderAvatarUrl)
                      : null,
                  child: item.senderAvatarUrl.isEmpty
                      ? Text(
                          item.senderName.isNotEmpty ? item.senderName[0] : '?',
                        )
                      : null,
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.senderName}  ${DateFormat('dd/MM/yyyy HH:mm').format(item.createdAt)}',
                ),
                trailing: _buildStatusBadge(item.status),
                onTap: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  final isManager = user != null && item.senderId != user.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestDetailPage(
                        request: item.toRequestItem(),
                        isFromSentToMe:
                            isManager, // true nếu là manager, false nếu là nhân viên
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'approved':
        color = Colors.green;
        text = 'Đã duyệt';
        break;
      case 'rejected':
        color = Colors.red;
        text = 'Từ chối';
        break;
      case 'cancelled':
        color = Colors.grey;
        text = 'Đã hủy';
        break;
      default:
        color = Colors.orange;
        text = 'Chờ duyệt';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
