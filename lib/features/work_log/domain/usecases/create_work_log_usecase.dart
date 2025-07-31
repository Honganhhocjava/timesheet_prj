import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/work_log/domain/entities/work_log_entity.dart';
import 'package:timesheet_project/features/work_log/domain/repositories/work_log_repository.dart';

class CreateWorkLogUsecase implements UseCase<void, WorkLogEntity> {
  final WorkLogRepository repository;

  CreateWorkLogUsecase(this.repository);

  @override
  Future<void> call(WorkLogEntity params) async {
    return await repository.createWorkLog(params);
  }
}
