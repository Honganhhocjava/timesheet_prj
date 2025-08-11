import 'package:flutter/material.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

class OvertimeRequestEntity {
  final String id;
  final String idUser;
  final String idManager;
  final RequestStatus status;
  final DateTime overtimeDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String reason;
  final List<ActivityLog> activitiesLog;
  final DateTime createdAt;

  const OvertimeRequestEntity({
    required this.id,
    required this.idUser,
    required this.idManager,
    required this.status,
    required this.overtimeDate,
    required this.startTime,
    required this.endTime,
    required this.reason,
    required this.activitiesLog,
    required this.createdAt,
  });

  OvertimeRequestEntity copyWith({
    String? id,
    String? idUser,
    String? idManager,
    RequestStatus? status,
    DateTime? overtimeDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? reason,
    List<ActivityLog>? activitiesLog,
    DateTime? createdAt,
  }) {
    return OvertimeRequestEntity(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      idManager: idManager ?? this.idManager,
      status: status ?? this.status,
      overtimeDate: overtimeDate ?? this.overtimeDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      activitiesLog: activitiesLog ?? this.activitiesLog,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

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
