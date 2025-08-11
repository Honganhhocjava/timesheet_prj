import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';
import 'package:timesheet_project/core/converters/request_converters.dart';

part 'work_log_model.freezed.dart';
part 'work_log_model.g.dart';

@freezed
class WorkLogModel with _$WorkLogModel {
  const factory WorkLogModel({
    required String id,
    required String idUser,
    required String idManager,
    @RequestStatusConverter() required RequestStatus status,
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
      status: status,
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
      status: entity.status,
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

  static RequestStatus _statusFromString(String status) {
    return status.toRequestStatus();
  }

  static String _statusToString(RequestStatus status) {
    return status.toStringValue();
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
