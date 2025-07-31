import 'package:flutter/material.dart';

class AttendanceAdjustmentEntity {
  final String id;
  final String idUser;
  final String idManager;
  final AttendanceAdjustmentStatus status;
  final DateTime adjustmentDate;
  final TimeOfDay originalCheckIn;
  final TimeOfDay originalCheckOut;
  final TimeOfDay adjustedCheckIn;
  final TimeOfDay adjustedCheckOut;
  final String reason;
  final List<ActivityLog> activitiesLog;
  final DateTime createdAt;

  const AttendanceAdjustmentEntity({
    required this.id,
    required this.idUser,
    required this.idManager,
    required this.status,
    required this.adjustmentDate,
    required this.originalCheckIn,
    required this.originalCheckOut,
    required this.adjustedCheckIn,
    required this.adjustedCheckOut,
    required this.reason,
    required this.activitiesLog,
    required this.createdAt,
  });

  AttendanceAdjustmentEntity copyWith({
    String? id,
    String? idUser,
    String? idManager,
    AttendanceAdjustmentStatus? status,
    DateTime? adjustmentDate,
    TimeOfDay? originalCheckIn,
    TimeOfDay? originalCheckOut,
    TimeOfDay? adjustedCheckIn,
    TimeOfDay? adjustedCheckOut,
    String? reason,
    List<ActivityLog>? activitiesLog,
    DateTime? createdAt,
  }) {
    return AttendanceAdjustmentEntity(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      idManager: idManager ?? this.idManager,
      status: status ?? this.status,
      adjustmentDate: adjustmentDate ?? this.adjustmentDate,
      originalCheckIn: originalCheckIn ?? this.originalCheckIn,
      originalCheckOut: originalCheckOut ?? this.originalCheckOut,
      adjustedCheckIn: adjustedCheckIn ?? this.adjustedCheckIn,
      adjustedCheckOut: adjustedCheckOut ?? this.adjustedCheckOut,
      reason: reason ?? this.reason,
      activitiesLog: activitiesLog ?? this.activitiesLog,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum AttendanceAdjustmentStatus { pending, approved, rejected, cancelled }

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
