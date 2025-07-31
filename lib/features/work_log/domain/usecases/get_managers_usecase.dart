import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/work_log/domain/repositories/work_log_repository.dart';

class GetManagersUsecase implements UseCase<List<UserEntity>, NoParams> {
  final WorkLogRepository repository;

  GetManagersUsecase(this.repository);

  @override
  Future<List<UserEntity>> call(NoParams params) async {
    return await repository.getManagers();
  }
}
