import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';
import 'package:timesheet_project/features/work_log/domain/repositories/work_log_repository.dart';
import 'package:timesheet_project/features/work_log/data/models/work_log_model.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/data/models/user_model.dart';

class WorkLogRepositoryImpl implements WorkLogRepository {
  final FirebaseFirestore firestore;

  WorkLogRepositoryImpl(this.firestore);

  @override
  Future<void> createWorkLog(WorkLogEntity workLog) async {
    try {
      final workLogData = _entityToJson(workLog);
      await firestore.collection('work_logs').doc(workLog.id).set(workLogData);
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

  String _statusToString(WorkLogStatus status) {
    switch (status) {
      case WorkLogStatus.pending:
        return 'pending';
      case WorkLogStatus.approved:
        return 'approved';
      case WorkLogStatus.rejected:
        return 'rejected';
      case WorkLogStatus.cancelled:
        return 'cancelled';
    }
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
}
