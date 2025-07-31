import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';

part 'leave_request_model.freezed.dart';
part 'leave_request_model.g.dart';

@freezed
class LeaveRequestModel with _$LeaveRequestModel {
  const factory LeaveRequestModel({
    required String id,
    required String idUser,
    required String idManager,
    required String status,
    required DateTime startDate,
    required DateTime endDate,
    required String startTime,
    required String endTime,
    required String reason,
    required List<ActivityLogModel> activitiesLog,
    required DateTime createdAt,
  }) = _LeaveRequestModel;

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestModelFromJson(json);
}

extension LeaveRequestModelX on LeaveRequestModel {
  LeaveRequestEntity toEntity() {
    return LeaveRequestEntity(
      id: id,
      idUser: idUser,
      idManager: idManager,
      status: _stringToStatus(status),
      startDate: startDate,
      endDate: endDate,
      startTime: _stringToTimeOfDay(startTime),
      endTime: _stringToTimeOfDay(endTime),
      reason: reason,
      activitiesLog: activitiesLog.map((log) => log.toEntity()).toList(),
      createdAt: createdAt,
    );
  }

  static LeaveRequestModel fromEntity(LeaveRequestEntity entity) {
    return LeaveRequestModel(
      id: entity.id,
      idUser: entity.idUser,
      idManager: entity.idManager,
      status: _statusToString(entity.status),
      startDate: entity.startDate,
      endDate: entity.endDate,
      startTime: _timeOfDayToString(entity.startTime),
      endTime: _timeOfDayToString(entity.endTime),
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

  static LeaveRequestStatus _stringToStatus(String status) {
    switch (status) {
      case 'pending':
        return LeaveRequestStatus.pending;
      case 'approved':
        return LeaveRequestStatus.approved;
      case 'rejected':
        return LeaveRequestStatus.rejected;
      case 'cancelled':
        return LeaveRequestStatus.cancelled;
      default:
        return LeaveRequestStatus.pending;
    }
  }

  static String _statusToString(LeaveRequestStatus status) {
    switch (status) {
      case LeaveRequestStatus.pending:
        return 'pending';
      case LeaveRequestStatus.approved:
        return 'approved';
      case LeaveRequestStatus.rejected:
        return 'rejected';
      case LeaveRequestStatus.cancelled:
        return 'cancelled';
    }
  }

  static String statusToString(LeaveRequestStatus status) {
    return _statusToString(status);
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
