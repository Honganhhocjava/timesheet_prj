import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/entities/attendance_adjustment_entity.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/repositories/attendance_adjustment_repository.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/data/models/user_model.dart';
import 'package:timesheet_project/features/attendance/domain/usecases/create_request_notification_usecase.dart';

class AttendanceAdjustmentRepositoryImpl
    implements AttendanceAdjustmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CreateRequestNotificationUsecase? _createNotificationUsecase;

  AttendanceAdjustmentRepositoryImpl([this._createNotificationUsecase]);

  // Helper method to convert JSON to AttendanceAdjustmentEntity
  AttendanceAdjustmentEntity _jsonToEntity(Map<String, dynamic> json) {
    final activitiesLogJson = json['activitiesLog'] as List<dynamic>? ?? [];
    final activitiesLog = activitiesLogJson.map((logJson) {
      final logMap = logJson as Map<String, dynamic>;
      return ActivityLog(
        id: logMap['id'] as String,
        action: logMap['action'] as String,
        userId: logMap['userId'] as String,
        userRole: logMap['userRole'] as String,
        timestamp: DateTime.parse(logMap['timestamp'] as String),
        comment: logMap['comment'] as String?,
      );
    }).toList();

    return AttendanceAdjustmentEntity(
      id: json['id'] as String,
      idUser: json['idUser'] as String,
      idManager: json['idManager'] as String,
      status: _stringToStatus(json['status'] as String),
      adjustmentDate: DateTime.parse(json['adjustmentDate'] as String),
      originalCheckIn: _stringToTimeOfDay(
        json['originalCheckIn'] as String? ?? '09:00',
      ),
      originalCheckOut: _stringToTimeOfDay(
        json['originalCheckOut'] as String? ?? '17:00',
      ),
      adjustedCheckIn: _stringToTimeOfDay(
        json['adjustedCheckIn'] as String? ?? '09:00',
      ),
      adjustedCheckOut: _stringToTimeOfDay(
        json['adjustedCheckOut'] as String? ?? '17:00',
      ),
      reason: json['reason'] as String,
      activitiesLog: activitiesLog,
      createdAt: DateTime.parse(json['createdAt'] as String),
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
  Future<void> createAttendanceAdjustment(
    AttendanceAdjustmentEntity adjustment,
  ) async {
    try {
      // Convert activitiesLog to JSON manually
      final activitiesLogJson = adjustment.activitiesLog
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

      // Create JSON data directly
      final adjustmentJson = {
        'id': adjustment.id,
        'idUser': adjustment.idUser,
        'idManager': adjustment.idManager,
        'status': _statusToString(adjustment.status),
        'adjustmentDate': adjustment.adjustmentDate.toIso8601String(),
        'originalCheckIn': _timeOfDayToString(adjustment.originalCheckIn),
        'originalCheckOut': _timeOfDayToString(adjustment.originalCheckOut),
        'adjustedCheckIn': _timeOfDayToString(adjustment.adjustedCheckIn),
        'adjustedCheckOut': _timeOfDayToString(adjustment.adjustedCheckOut),
        'reason': adjustment.reason,
        'activitiesLog': activitiesLogJson,
        'createdAt': adjustment.createdAt.toIso8601String(),
      };

      await _firestore
          .collection('attendance_adjustments')
          .doc(adjustment.id)
          .set(adjustmentJson);

      // Tạo notification cho manager
      if (_createNotificationUsecase != null) {
        try {
          await _createNotificationUsecase!.call(
            CreateRequestNotificationParams(
              requestId: adjustment.id,
              requestType: RequestType.attendance,
              status: RequestStatus.pending,
              userId: adjustment.idUser,
              managerId: adjustment.idManager,
              action: NotificationAction.create,
            ),
          );
        } catch (e) {
          print('DEBUG: Error creating notification: $e');
          // Không throw exception vì việc tạo notification không ảnh hưởng đến việc tạo đơn
        }
      }
    } catch (e) {
      throw Exception('Lỗi khi tạo đơn điều chỉnh chấm công: $e');
    }
  }

  @override
  Future<List<AttendanceAdjustmentEntity>> getAttendanceAdjustmentsByUser(
    String userId,
  ) async {
    try {
      // Use simpler query to avoid composite index requirement
      final querySnapshot = await _firestore
          .collection('attendance_adjustments')
          .where('idUser', isEqualTo: userId)
          .get();

      // Sort locally to avoid composite index
      final results =
          querySnapshot.docs.map((doc) => _jsonToEntity(doc.data())).toList();

      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return results;
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách đơn điều chỉnh chấm công: $e');
    }
  }

  @override
  Future<List<AttendanceAdjustmentEntity>> getAttendanceAdjustmentsByManager(
    String managerId,
  ) async {
    try {
      print(
        'DEBUG: Querying attendance_adjustments with managerId: $managerId',
      );

      final querySnapshot = await _firestore
          .collection('attendance_adjustments')
          .where('idManager', isEqualTo: managerId)
          .get();

      print(
        'DEBUG: Found ${querySnapshot.docs.length} attendance adjustment documents',
      );

      // Sort in memory to avoid index requirement
      final results =
          querySnapshot.docs.map((doc) => _jsonToEntity(doc.data())).toList();

      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print('DEBUG: Parsed ${results.length} attendance adjustment entities');

      return results;
    } catch (e) {
      print('DEBUG: Error in getAttendanceAdjustmentsByManager: $e');
      throw Exception('Lỗi khi lấy danh sách đơn điều chỉnh cần duyệt: $e');
    }
  }

  @override
  Future<AttendanceAdjustmentEntity?> getAttendanceAdjustmentById(
    String id,
  ) async {
    try {
      final docSnapshot =
          await _firestore.collection('attendance_adjustments').doc(id).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return _jsonToEntity(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin đơn điều chỉnh: $e');
    }
  }

  @override
  Future<void> updateAttendanceAdjustmentStatus(
    String id,
    RequestStatus status,
    String? comment,
  ) async {
    try {
      final docRef = _firestore.collection('attendance_adjustments').doc(id);

      // Get current document to update activities log
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw Exception('Không tìm thấy đơn điều chỉnh chấm công');
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
              requestType: RequestType.attendance,
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
      throw Exception('Lỗi khi cập nhật trạng thái đơn điều chỉnh: $e');
    }
  }

  @override
  Future<void> updateAttendanceAdjustment(
    AttendanceAdjustmentEntity adjustment,
  ) async {
    try {
      final activitiesLogJson = adjustment.activitiesLog
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

      final adjustmentJson = {
        'id': adjustment.id,
        'idUser': adjustment.idUser,
        'idManager': adjustment.idManager,
        'status': _statusToString(adjustment.status),
        'adjustmentDate': adjustment.adjustmentDate.toIso8601String(),
        'originalCheckIn': _timeOfDayToString(adjustment.originalCheckIn),
        'originalCheckOut': _timeOfDayToString(adjustment.originalCheckOut),
        'adjustedCheckIn': _timeOfDayToString(adjustment.adjustedCheckIn),
        'adjustedCheckOut': _timeOfDayToString(adjustment.adjustedCheckOut),
        'reason': adjustment.reason,
        'activitiesLog': activitiesLogJson,
        'createdAt': adjustment.createdAt.toIso8601String(),
      };

      await _firestore
          .collection('attendance_adjustments')
          .doc(adjustment.id)
          .update(adjustmentJson);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật đơn điều chỉnh chấm công: $e');
    }
  }

  @override
  Future<void> deleteAttendanceAdjustment(String id) async {
    try {
      await _firestore.collection('attendance_adjustments').doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa đơn điều chỉnh chấm công: $e');
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
