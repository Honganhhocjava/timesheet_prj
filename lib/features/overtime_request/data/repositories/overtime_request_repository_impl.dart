import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';
import 'package:timesheet_project/features/overtime_request/domain/repositories/overtime_request_repository.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/data/models/user_model.dart';
import 'package:timesheet_project/features/attendance/domain/usecases/create_request_notification_usecase.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

class OvertimeRequestRepositoryImpl implements OvertimeRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CreateRequestNotificationUsecase? _createNotificationUsecase;

  OvertimeRequestRepositoryImpl([this._createNotificationUsecase]);

  OvertimeRequestEntity _jsonToEntity(Map<String, dynamic> json) {
    final activitiesLogJson = json['activitiesLog'] as List<dynamic>? ?? [];
    final activitiesLog = activitiesLogJson.map((logJson) {
      final logMap = logJson as Map<String, dynamic>;
      return ActivityLog(
        id: logMap['id'] as String? ?? '',
        action: logMap['action'] as String? ?? '',
        userId: logMap['userId'] as String? ?? '',
        userRole: logMap['userRole'] as String? ?? '',
        timestamp: DateTime.tryParse(logMap['timestamp'] as String? ?? '') ??
            DateTime.now(),
        comment: logMap['comment'] as String?,
      );
    }).toList();

    return OvertimeRequestEntity(
      id: json['id'] as String? ?? '',
      idUser: json['idUser'] as String? ?? '',
      idManager: json['idManager'] as String? ?? '',
      status: _stringToStatus(
          json['status'] as String? ?? RequestStatus.pending.toStringValue()),
      overtimeDate: DateTime.tryParse(json['overtimeDate'] as String? ?? '') ??
          DateTime.now(),
      startTime: _stringToTimeOfDay(json['startTime'] as String? ?? '18:00'),
      endTime: _stringToTimeOfDay(json['endTime'] as String? ?? '20:00'),
      reason: json['reason'] as String? ?? '',
      activitiesLog: activitiesLog,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  // Helper method to convert string to TimeOfDay
  TimeOfDay _stringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Helper method to convert TimeOfDay to string
  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Helper method to convert status string to enum
  RequestStatus _stringToStatus(String status) {
    return status.toRequestStatus();
  }

  // Helper method to convert status enum to string
  String _statusToString(RequestStatus status) {
    return status.toStringValue();
  }

  @override
  Future<void> createOvertimeRequest(
    OvertimeRequestEntity overtimeRequest,
  ) async {
    try {
      final activitiesLogJson = overtimeRequest.activitiesLog
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

      final overtimeRequestJson = {
        'id': overtimeRequest.id,
        'idUser': overtimeRequest.idUser,
        'idManager': overtimeRequest.idManager,
        'status': _statusToString(overtimeRequest.status),
        'overtimeDate': overtimeRequest.overtimeDate.toIso8601String(),
        'startTime': _timeOfDayToString(overtimeRequest.startTime),
        'endTime': _timeOfDayToString(overtimeRequest.endTime),
        'reason': overtimeRequest.reason,
        'activitiesLog': activitiesLogJson,
        'createdAt': overtimeRequest.createdAt.toIso8601String(),
      };

      await _firestore
          .collection('overtime_requests')
          .doc(overtimeRequest.id)
          .set(overtimeRequestJson);

      // Tạo notification cho manager
      if (_createNotificationUsecase != null) {
        try {
          await _createNotificationUsecase!.call(
            CreateRequestNotificationParams(
              requestId: overtimeRequest.id,
              requestType: RequestType.overtime,
              status: RequestStatus.pending,
              userId: overtimeRequest.idUser,
              managerId: overtimeRequest.idManager,
              action: NotificationAction.create,
            ),
          );
        } catch (e) {
          print('DEBUG: Error creating notification: $e');
          // Không throw exception vì việc tạo notification không ảnh hưởng đến việc tạo đơn
        }
      }
    } catch (e) {
      throw Exception('Lỗi khi tạo đơn xin làm thêm giờ: $e');
    }
  }

  @override
  Future<List<OvertimeRequestEntity>> getOvertimeRequestsByUser(
    String userId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('overtime_requests')
          .where('idUser', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => _jsonToEntity(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách đơn xin làm thêm giờ: $e');
    }
  }

  @override
  Future<List<OvertimeRequestEntity>> getOvertimeRequestsByManager(
    String managerId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('overtime_requests')
          .where('idManager', isEqualTo: managerId)
          .get();

      final results =
          querySnapshot.docs.map((doc) => _jsonToEntity(doc.data())).toList();

      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return results;
    } catch (e) {
      throw Exception(
        'Lỗi khi lấy danh sách đơn xin làm thêm giờ cần duyệt: $e',
      );
    }
  }

  @override
  Future<OvertimeRequestEntity?> getOvertimeRequestById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection('overtime_requests').doc(id).get();

      if (docSnapshot.exists) {
        return _jsonToEntity(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy đơn xin làm thêm giờ: $e');
    }
  }

  @override
  Future<void> updateOvertimeRequestStatus(
    String id,
    RequestStatus status,
    String? comment,
  ) async {
    try {
      print('OvertimeRequestRepositoryImpl: Updating status for request $id');
      final docRef = _firestore.collection('overtime_requests').doc(id);

      // Get current document to update activities log
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw Exception('Không tìm thấy đơn xin làm thêm giờ');
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
              requestType: RequestType.overtime,
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
      print('OvertimeRequestRepositoryImpl: Error updating status: $e');
      throw Exception('Lỗi khi cập nhật trạng thái đơn xin làm thêm giờ: $e');
    }
  }

  @override
  Future<void> updateOvertimeRequest(
    OvertimeRequestEntity overtimeRequest,
  ) async {
    try {
      final activitiesLogJson = overtimeRequest.activitiesLog
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

      final overtimeRequestJson = {
        'id': overtimeRequest.id,
        'idUser': overtimeRequest.idUser,
        'idManager': overtimeRequest.idManager,
        'status': _statusToString(overtimeRequest.status),
        'overtimeDate': overtimeRequest.overtimeDate.toIso8601String(),
        'startTime': _timeOfDayToString(overtimeRequest.startTime),
        'endTime': _timeOfDayToString(overtimeRequest.endTime),
        'reason': overtimeRequest.reason,
        'activitiesLog': activitiesLogJson,
        'createdAt': overtimeRequest.createdAt.toIso8601String(),
      };

      await _firestore
          .collection('overtime_requests')
          .doc(overtimeRequest.id)
          .update(overtimeRequestJson);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật đơn xin làm thêm giờ: $e');
    }
  }

  @override
  Future<void> deleteOvertimeRequest(String id) async {
    try {
      await _firestore.collection('overtime_requests').doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa đơn xin làm thêm giờ: $e');
    }
  }

  @override
  Future<List<UserEntity>> getManagers() async {
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
