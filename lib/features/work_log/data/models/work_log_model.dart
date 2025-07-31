import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';

part 'work_log_model.freezed.dart';
part 'work_log_model.g.dart';

@freezed
class WorkLogModel with _$WorkLogModel {
  const factory WorkLogModel({
    required String id,
    required String idUser,
    required String idManager,
    required String status,
    required DateTime workDate,
    required String checkInTime,
    required String checkOutTime,
    String? notes,
    required List<ActivityLogModel> activitiesLog,
    required DateTime createdAt,
  }) = _WorkLogModel;

  factory WorkLogModel.fromJson(Map<String, dynamic> json) =>
      _$WorkLogModelFromJson(json);
}

@freezed
class ActivityLogModel with _$ActivityLogModel {
  const factory ActivityLogModel({
    required String id,
    required String action,
    required String userId,
    required String userRole,
    required DateTime timestamp,
    String? comment,
  }) = _ActivityLogModel;

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogModelFromJson(json);
}

extension WorkLogModelExtension on WorkLogModel {
  WorkLogEntity toEntity() {
    return WorkLogEntity(
      id: id,
      idUser: idUser,
      idManager: idManager,
      status: _statusFromString(status),
      workDate: workDate,
      checkInTime: _timeFromString(checkInTime),
      checkOutTime: _timeFromString(checkOutTime),
      notes: notes,
      activitiesLog: activitiesLog.map((log) => log.toEntity()).toList(),
      createdAt: createdAt,
    );
  }

  static WorkLogModel fromEntity(WorkLogEntity entity) {
    return WorkLogModel(
      id: entity.id,
      idUser: entity.idUser,
      idManager: entity.idManager,
      status: _statusToString(entity.status),
      workDate: entity.workDate,
      checkInTime: _timeToString(entity.checkInTime),
      checkOutTime: _timeToString(entity.checkOutTime),
      notes: entity.notes,
      activitiesLog: entity.activitiesLog
          .map((log) => ActivityLogModelExtension.fromEntity(log))
          .toList(),
      createdAt: entity.createdAt,
    );
  }

  static WorkLogStatus _statusFromString(String status) {
    switch (status) {
      case 'pending':
        return WorkLogStatus.pending;
      case 'approved':
        return WorkLogStatus.approved;
      case 'rejected':
        return WorkLogStatus.rejected;
      case 'cancelled':
        return WorkLogStatus.cancelled;
      default:
        return WorkLogStatus.pending;
    }
  }

  static String _statusToString(WorkLogStatus status) {
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

  static TimeOfDay _timeFromString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

extension ActivityLogModelExtension on ActivityLogModel {
  ActivityLog toEntity() {
    return ActivityLog(
      id: id,
      action: action,
      userId: userId,
      userRole: userRole,
      timestamp: timestamp,
      comment: comment,
    );
  }

  static ActivityLogModel fromEntity(ActivityLog entity) {
    return ActivityLogModel(
      id: entity.id,
      action: entity.action,
      userId: entity.userId,
      userRole: entity.userRole,
      timestamp: entity.timestamp,
      comment: entity.comment,
    );
  }
}
