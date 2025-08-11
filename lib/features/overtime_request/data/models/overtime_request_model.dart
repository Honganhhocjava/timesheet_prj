import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';
import 'package:timesheet_project/core/converters/request_converters.dart';

part 'overtime_request_model.freezed.dart';
part 'overtime_request_model.g.dart';

@freezed
class OvertimeRequestModel with _$OvertimeRequestModel {
  const factory OvertimeRequestModel({
    required String id,
    required String idUser,
    required String idManager,
    @RequestStatusConverter() required RequestStatus status,
    required DateTime overtimeDate,
    required String startTime,
    required String endTime,
    required String reason,
    required List<ActivityLogModel> activitiesLog,
    required DateTime createdAt,
  }) = _OvertimeRequestModel;

  factory OvertimeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeRequestModelFromJson(json);
}

extension OvertimeRequestModelX on OvertimeRequestModel {
  OvertimeRequestEntity toEntity() {
    return OvertimeRequestEntity(
      id: id,
      idUser: idUser,
      idManager: idManager,
      status: status,
      overtimeDate: overtimeDate,
      startTime: _stringToTimeOfDay(startTime),
      endTime: _stringToTimeOfDay(endTime),
      reason: reason,
      activitiesLog: activitiesLog.map((log) => log.toEntity()).toList(),
      createdAt: createdAt,
    );
  }

  static OvertimeRequestModel fromEntity(OvertimeRequestEntity entity) {
    return OvertimeRequestModel(
      id: entity.id,
      idUser: entity.idUser,
      idManager: entity.idManager,
      status: entity.status,
      overtimeDate: entity.overtimeDate,
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

  static RequestStatus _stringToStatus(String status) {
    return status.toRequestStatus();
  }

  static String _statusToString(RequestStatus status) {
    return status.toStringValue();
  }

  static String statusToString(RequestStatus status) {
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
