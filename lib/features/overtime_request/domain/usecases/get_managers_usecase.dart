import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/overtime_request/domain/repositories/overtime_request_repository.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

class GetManagersUsecase implements UseCase<List<UserEntity>, NoParams> {
  final OvertimeRequestRepository repository;

  GetManagersUsecase({required this.repository});

  @override
  Future<List<UserEntity>> call(NoParams params) async {
    return await repository.getManagers();
  }
}
