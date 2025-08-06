import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/leave_request/domain/repositories/leave_request_repository.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/data/models/user_model.dart';

class LeaveRequestRepositoryImpl implements LeaveRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LeaveRequestEntity _jsonToEntity(Map<String, dynamic> json) {
    try {
      print('DEBUG: Parsing leave request JSON: ${json.keys}');

      final activitiesLogJson = json['activitiesLog'] as List<dynamic>? ?? [];
      final activitiesLog = activitiesLogJson.map((logJson) {
        try {
          final logMap = logJson as Map<String, dynamic>;
          return ActivityLog(
            id: logMap['id'] as String? ?? '',
            action: logMap['action'] as String? ?? '',
            userId: logMap['userId'] as String? ?? '',
            userRole: logMap['userRole'] as String? ?? '',
            timestamp: DateTime.tryParse(logMap['timestamp'] as String? ?? '') ?? DateTime.now(),
            comment: logMap['comment'] as String?,
          );
        } catch (e) {
          print('DEBUG: Error parsing activity log: $e');
          return ActivityLog(
            id: '',
            action: 'Error',
            userId: '',
            userRole: '',
            timestamp: DateTime.now(),
            comment: 'Error parsing: $e',
          );
        }
      }).toList();

      final entity = LeaveRequestEntity(
        id: json['id'] as String? ?? '',
        idUser: json['idUser'] as String? ?? '',
        idManager: json['idManager'] as String? ?? '',
        status: _stringToStatus(json['status'] as String? ?? 'pending'),
        startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ?? DateTime.now(),
        endDate: DateTime.tryParse(json['endDate'] as String? ?? '') ?? DateTime.now(),
        startTime: _stringToTimeOfDay(json['startTime'] as String? ?? '09:00'),
        endTime: _stringToTimeOfDay(json['endTime'] as String? ?? '17:00'),
        reason: json['reason'] as String? ?? '',
        activitiesLog: activitiesLog,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );

      print('DEBUG: Successfully parsed leave request: ${entity.id}');
      return entity;
    } catch (e) {
      print('DEBUG: Error parsing leave request JSON: $e');
      print('DEBUG: JSON data: $json');
      throw Exception('Lỗi khi parse dữ liệu đơn xin nghỉ: $e');
    }
  }

  // Helper method to convert string to TimeOfDay
  TimeOfDay _stringToTimeOfDay(String timeString) {
    try {
      final parts = timeString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      print('DEBUG: Error parsing time string: $timeString, error: $e');
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  // Helper method to convert TimeOfDay to string
  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Helper method to convert status string to enum
  LeaveRequestStatus _stringToStatus(String status) {
    switch (status) {
      case 'pending':
        return LeaveRequestStatus.pending;
      case 'approved':
        return LeaveRequestStatus.approved;
      case 'rejected':
        return LeaveRequestStatus.rejected;
      case 'cancelled':
        return LeaveRequestStatus.cancelled;
      default:
        print('DEBUG: Unknown status: $status, defaulting to pending');
        return LeaveRequestStatus.pending;
    }
  }

  // Helper method to convert status enum to string
  String _statusToString(LeaveRequestStatus status) {
    switch (status) {
      case LeaveRequestStatus.pending:
        return 'pending';
      case LeaveRequestStatus.approved:
        return 'approved';
      case LeaveRequestStatus.rejected:
        return 'rejected';
      case LeaveRequestStatus.cancelled:
        return 'cancelled';
    }
  }

  @override
  Future<void> createLeaveRequest(LeaveRequestEntity leaveRequest) async {
    try {
      final activitiesLogJson = leaveRequest.activitiesLog
          .map(
            (log) => {
          'id': log.id,
          'action': log.action,
          'userId': log.userId,
          'userRole': log.userRole,
          'timestamp': log.timestamp.toIso8601String(),
          'comment': log.comment,
        },
      )
          .toList();

      final leaveRequestJson = {
        'id': leaveRequest.id,
        'idUser': leaveRequest.idUser,
        'idManager': leaveRequest.idManager,
        'status': _statusToString(leaveRequest.status),
        'startDate': leaveRequest.startDate.toIso8601String(),
        'endDate': leaveRequest.endDate.toIso8601String(),
        'startTime': _timeOfDayToString(leaveRequest.startTime),
        'endTime': _timeOfDayToString(leaveRequest.endTime),
        'reason': leaveRequest.reason,
        'activitiesLog': activitiesLogJson,
        'createdAt': leaveRequest.createdAt.toIso8601String(),
      };

      await _firestore
          .collection('leave_requests')
          .doc(leaveRequest.id)
          .set(leaveRequestJson);
    } catch (e) {
      throw Exception('Lỗi khi tạo đơn xin nghỉ: $e');
    }
  }

  @override
  Future<List<LeaveRequestEntity>> getLeaveRequestsByUser(String userId) async {
    try {
      // Use simpler query to avoid composite index requirement
      final querySnapshot = await _firestore
          .collection('leave_requests')
          .where('idUser', isEqualTo: userId)
          .get();

      // Sort locally to avoid composite index
      final results = querySnapshot.docs
          .map((doc) => _jsonToEntity(doc.data()))
          .toList();

      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return results;
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách đơn xin nghỉ: $e');
    }
  }

  @override
  Future<List<LeaveRequestEntity>> getLeaveRequestsByManager(
      String managerId,
      ) async {
    try {
     // print('DEBUG: Getting leave requests for manager: $managerId');

      final querySnapshot = await _firestore
          .collection('leave_requests')
          .where('idManager', isEqualTo: managerId)
          .get();

     // print('DEBUG: Found ${querySnapshot.docs.length} leave request documents');

      final results = <LeaveRequestEntity>[];
      for (final doc in querySnapshot.docs) {
        try {
          final data = doc.data();
         // print('DEBUG: Processing document ${doc.id} with data: ${data.keys}');

          final entity = _jsonToEntity(data);
          results.add(entity);
        } catch (e) {
        //  print('DEBUG: Error processing document ${doc.id}: $e');
          // Continue with other documents
        }
      }

      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
     // print('DEBUG: Successfully processed ${results.length} leave requests');

      return results;
    } catch (e) {
      print('DEBUG: Error in getLeaveRequestsByManager: $e');
      throw Exception('Lỗi khi lấy danh sách đơn xin nghỉ cần duyệt: $e');
    }
  }

  @override
  Future<LeaveRequestEntity?> getLeaveRequestById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection('leave_requests')
          .doc(id)
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return _jsonToEntity(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin đơn xin nghỉ: $e');
    }
  }

  @override
  Future<void> updateLeaveRequestStatus(
      String id,
      LeaveRequestStatus status,
      String? comment,
      ) async {
    try {
      print('DEBUG: LeaveRequestRepositoryImpl: Updating status for request $id to ${status.toString()}');
      final docRef = _firestore.collection('leave_requests').doc(id);

      // Get current document to update activities log
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw Exception('Không tìm thấy đơn xin nghỉ');
      }

      final currentData = docSnapshot.data()!;
      print('DEBUG: LeaveRequestRepositoryImpl: Current status: ${currentData['status']}');

      // Get current user for activity log
      final currentUser = FirebaseAuth.instance.currentUser;
      final userId = currentUser?.uid ?? 'unknown';

      // Create new activity as JSON directly
      final newActivityJson = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'action': 'Status updated to ${status.toString().split('.').last}',
        'userId': userId,
        'userRole': 'Quản lý',
        'timestamp': DateTime.now().toIso8601String(),
        'comment': comment,
      };

      // Get current activities log as JSON list
      final currentActivitiesLog =
          currentData['activitiesLog'] as List<dynamic>? ?? [];

      // Add new activity to the list
      final updatedActivitiesLog = [...currentActivitiesLog, newActivityJson];

      await docRef.update({
        'status': _statusToString(status),
        'activitiesLog': updatedActivitiesLog,
      });

      print('DEBUG: LeaveRequestRepositoryImpl: Status updated successfully to ${_statusToString(status)}');
    } catch (e) {
      print('DEBUG: LeaveRequestRepositoryImpl: Error updating status: $e');
      throw Exception('Lỗi khi cập nhật trạng thái đơn xin nghỉ: $e');
    }
  }

  @override
  Future<void> updateLeaveRequest(LeaveRequestEntity leaveRequest) async {
    try {
      final activitiesLogJson = leaveRequest.activitiesLog
          .map(
            (log) => {
          'id': log.id,
          'action': log.action,
          'userId': log.userId,
          'userRole': log.userRole,
          'timestamp': log.timestamp.toIso8601String(),
          'comment': log.comment,
        },
      )
          .toList();

      final leaveRequestJson = {
        'id': leaveRequest.id,
        'idUser': leaveRequest.idUser,
        'idManager': leaveRequest.idManager,
        'status': _statusToString(leaveRequest.status),
        'startDate': leaveRequest.startDate.toIso8601String(),
        'endDate': leaveRequest.endDate.toIso8601String(),
        'startTime': _timeOfDayToString(leaveRequest.startTime),
        'endTime': _timeOfDayToString(leaveRequest.endTime),
        'reason': leaveRequest.reason,
        'activitiesLog': activitiesLogJson,
        'createdAt': leaveRequest.createdAt.toIso8601String(),
      };

      await _firestore
          .collection('leave_requests')
          .doc(leaveRequest.id)
          .update(leaveRequestJson);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật đơn xin nghỉ: $e');
    }
  }

  @override
  Future<void> deleteLeaveRequest(String id) async {
    try {
      await _firestore.collection('leave_requests').doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa đơn xin nghỉ: $e');
    }
  }

  @override
  Future<List<UserEntity>> getManagerUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Quản lý')
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách quản lý: $e');
    }
  }
}