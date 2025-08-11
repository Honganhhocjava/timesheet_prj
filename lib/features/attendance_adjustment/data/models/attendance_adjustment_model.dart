import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/entities/attendance_adjustment_entity.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';
import 'package:timesheet_project/core/converters/request_converters.dart';

part 'attendance_adjustment_model.freezed.dart';
part 'attendance_adjustment_model.g.dart';

@freezed
class AttendanceAdjustmentModel with _$AttendanceAdjustmentModel {
  const factory AttendanceAdjustmentModel({
    required String id,
    required String idUser,
    required String idManager,
    @RequestStatusConverter() required RequestStatus status,
    required DateTime adjustmentDate,
    required String originalCheckIn,
    required String originalCheckOut,
    required String adjustedCheckIn,
    required String adjustedCheckOut,
    required String reason,
    required List<ActivityLogModel> activitiesLog,
    required DateTime createdAt,
  }) = _AttendanceAdjustmentModel;

  factory AttendanceAdjustmentModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceAdjustmentModelFromJson(json);
}

extension AttendanceAdjustmentModelX on AttendanceAdjustmentModel {
  AttendanceAdjustmentEntity toEntity() {
    return AttendanceAdjustmentEntity(
      id: id,
      idUser: idUser,
      idManager: idManager,
      status: status,
      adjustmentDate: adjustmentDate,
      originalCheckIn: _stringToTimeOfDay(originalCheckIn),
      originalCheckOut: _stringToTimeOfDay(originalCheckOut),
      adjustedCheckIn: _stringToTimeOfDay(adjustedCheckIn),
      adjustedCheckOut: _stringToTimeOfDay(adjustedCheckOut),
      reason: reason,
      activitiesLog: activitiesLog.map((log) => log.toEntity()).toList(),
      createdAt: createdAt,
    );
  }

  static AttendanceAdjustmentModel fromEntity(
    AttendanceAdjustmentEntity entity,
  ) {
    return AttendanceAdjustmentModel(
      id: entity.id,
      idUser: entity.idUser,
      idManager: entity.idManager,
      status: entity.status,
      adjustmentDate: entity.adjustmentDate,
      originalCheckIn: _timeOfDayToString(entity.originalCheckIn),
      originalCheckOut: _timeOfDayToString(entity.originalCheckOut),
      adjustedCheckIn: _timeOfDayToString(entity.adjustedCheckIn),
      adjustedCheckOut: _timeOfDayToString(entity.adjustedCheckOut),
      reason: entity.reason,
      activitiesLog: entity.activitiesLog
          .map((log) => ActivityLogModelX.fromEntity(log))
          .toList(),
      createdAt: entity.createdAt,
    );
  }

  static TimeOfDay _stringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static RequestStatus _stringToStatus(String status) {
    return status.toRequestStatus();
  }

  static String _statusToString(RequestStatus status) {
    return status.toStringValue();
  }
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

extension ActivityLogModelX on ActivityLogModel {
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
