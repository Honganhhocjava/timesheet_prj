import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

abstract class WorkLogRepository {
  Future<void> createWorkLog(WorkLogEntity workLog);
  Future<List<UserEntity>> getManagers();
}
