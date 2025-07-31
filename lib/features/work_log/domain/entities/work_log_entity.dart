import 'package:flutter/material.dart';

class WorkLogEntity {
  final String id;
  final String idUser;
  final String idManager;
  final WorkLogStatus status;
  final DateTime workDate;
  final TimeOfDay checkInTime;
  final TimeOfDay checkOutTime;
  final String? notes;
  final List<ActivityLog> activitiesLog;
  final DateTime createdAt;

  const WorkLogEntity({
    required this.id,
    required this.idUser,
    required this.idManager,
    required this.status,
    required this.workDate,
    required this.checkInTime,
    required this.checkOutTime,
    this.notes,
    required this.activitiesLog,
    required this.createdAt,
  });

  WorkLogEntity copyWith({
    String? id,
    String? idUser,
    String? idManager,
    WorkLogStatus? status,
    DateTime? workDate,
    TimeOfDay? checkInTime,
    TimeOfDay? checkOutTime,
    String? notes,
    List<ActivityLog>? activitiesLog,
    DateTime? createdAt,
  }) {
    return WorkLogEntity(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      idManager: idManager ?? this.idManager,
      status: status ?? this.status,
      workDate: workDate ?? this.workDate,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      notes: notes ?? this.notes,
      activitiesLog: activitiesLog ?? this.activitiesLog,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum WorkLogStatus { pending, approved, rejected, cancelled }

class ActivityLog {
  final String id;
  final String action;
  final String userId;
  final String userRole;
  final DateTime timestamp;
  final String? comment;

  const ActivityLog({
    required this.id,
    required this.action,
    required this.userId,
    required this.userRole,
    required this.timestamp,
    this.comment,
  });

  ActivityLog copyWith({
    String? id,
    String? action,
    String? userId,
    String? userRole,
    DateTime? timestamp,
    String? comment,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      action: action ?? this.action,
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      timestamp: timestamp ?? this.timestamp,
      comment: comment ?? this.comment,
    );
  }
}
