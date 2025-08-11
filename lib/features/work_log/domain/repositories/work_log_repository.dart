import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

abstract class WorkLogRepository {
  Future<void> createWorkLog(WorkLogEntity workLog);
  Future<List<UserEntity>> getManagers();
  Future<List<WorkLogEntity>> getWorkLogsByUser(String userId);
  Future<List<WorkLogEntity>> getWorkLogsByManager(String managerId);
  Future<WorkLogEntity?> getWorkLogById(String id);
  Future<void> updateWorkLogStatus(
      String id, RequestStatus status, String? comment);
}
