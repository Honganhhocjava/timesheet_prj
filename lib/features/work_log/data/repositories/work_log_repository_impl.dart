import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';
import 'package:timesheet_project/features/work_log/domain/repositories/work_log_repository.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/data/models/user_model.dart';
import 'package:timesheet_project/features/attendance/domain/usecases/create_request_notification_usecase.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

class WorkLogRepositoryImpl implements WorkLogRepository {
  final FirebaseFirestore firestore;
  final CreateRequestNotificationUsecase? _createNotificationUsecase;

  WorkLogRepositoryImpl(this.firestore, [this._createNotificationUsecase]);

  @override
  Future<void> createWorkLog(WorkLogEntity workLog) async {
    try {
      final workLogData = _entityToJson(workLog);
      await firestore.collection('work_logs').doc(workLog.id).set(workLogData);

      // Tạo notification cho manager
      if (_createNotificationUsecase != null) {
        try {
          await _createNotificationUsecase!.call(
            CreateRequestNotificationParams(
              requestId: workLog.id,
              requestType: RequestType.worklog,
              status: RequestStatus.pending,
              userId: workLog.idUser,
              managerId: workLog.idManager,
              action: NotificationAction.create,
            ),
          );
        } catch (e) {
          print('DEBUG: Error creating notification: $e');
          // Không throw exception vì việc tạo notification không ảnh hưởng đến việc tạo đơn
        }
      }
    } catch (e) {
      throw Exception('Failed to create work log: $e');
    }
  }

  Map<String, dynamic> _entityToJson(WorkLogEntity entity) {
    final activitiesLogJson = entity.activitiesLog.map((log) {
      return {
        'id': log.id,
        'action': log.action,
        'userId': log.userId,
        'userRole': log.userRole,
        'timestamp': log.timestamp.toIso8601String(),
        'comment': log.comment,
      };
    }).toList();

    return {
      'id': entity.id,
      'idUser': entity.idUser,
      'idManager': entity.idManager,
      'status': _statusToString(entity.status),
      'workDate': entity.workDate.toIso8601String(),
      'checkInTime': _timeToString(entity.checkInTime),
      'checkOutTime': _timeToString(entity.checkOutTime),
      'notes': entity.notes,
      'activitiesLog': activitiesLogJson,
      'createdAt': entity.createdAt.toIso8601String(),
    };
  }

  String _statusToString(RequestStatus status) {
    return status.toStringValue();
  }

  String _timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Future<List<UserEntity>> getManagers() async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: 'Quản lý')
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get managers: $e');
    }
  }

  @override
  Future<List<WorkLogEntity>> getWorkLogsByUser(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('work_logs')
          .where('idUser', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => _jsonToEntity(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get work logs by user: $e');
    }
  }

  @override
  Future<List<WorkLogEntity>> getWorkLogsByManager(String managerId) async {
    try {
      final querySnapshot = await firestore
          .collection('work_logs')
          .where('idManager', isEqualTo: managerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => _jsonToEntity(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get work logs by manager: $e');
    }
  }

  @override
  Future<WorkLogEntity?> getWorkLogById(String id) async {
    try {
      final docSnapshot = await firestore.collection('work_logs').doc(id).get();

      if (docSnapshot.exists) {
        return _jsonToEntity(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get work log by id: $e');
    }
  }

  WorkLogEntity _jsonToEntity(Map<String, dynamic> json) {
    final activitiesLog = (json['activitiesLog'] as List<dynamic>?)
            ?.map((log) => ActivityLog(
                  id: log['id'],
                  action: log['action'],
                  userId: log['userId'],
                  userRole: log['userRole'],
                  timestamp: DateTime.parse(log['timestamp']),
                  comment: log['comment'],
                ))
            .toList() ??
        [];

    return WorkLogEntity(
      id: json['id'],
      idUser: json['idUser'],
      idManager: json['idManager'],
      status: _stringToStatus(json['status']),
      workDate: DateTime.parse(json['workDate']),
      checkInTime: _stringToTime(json['checkInTime']),
      checkOutTime: _stringToTime(json['checkOutTime']),
      notes: json['notes'],
      activitiesLog: activitiesLog,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  RequestStatus _stringToStatus(String status) {
    return status.toRequestStatus();
  }

  TimeOfDay _stringToTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  Future<void> updateWorkLogStatus(
      String id, RequestStatus status, String? comment) async {
    try {
      final docRef = firestore.collection('work_logs').doc(id);

      // Get current document to update activities log
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw Exception('Không tìm thấy work log');
      }

      final currentData = docSnapshot.data()!;

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

      // Tạo notification cho user khi duyệt đơn
      if (_createNotificationUsecase != null) {
        try {
          await _createNotificationUsecase!.call(
            CreateRequestNotificationParams(
              requestId: id,
              requestType: RequestType.worklog,
              status: status,
              userId: currentData['idUser'] ?? '',
              managerId: currentData['idManager'] ?? '',
              action: NotificationAction.approve,
            ),
          );
        } catch (e) {
          print('DEBUG: Error creating notification: $e');
          // Không throw exception vì việc tạo notification không ảnh hưởng đến việc duyệt đơn
        }
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật trạng thái work log: $e');
    }
  }
}
