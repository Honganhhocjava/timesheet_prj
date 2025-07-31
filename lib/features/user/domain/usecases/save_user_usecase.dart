import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/domain/repositories/user_repository.dart';

class SaveUserUsecase implements UseCase<void, UserEntity> {
  final UserRepository _repository;

  SaveUserUsecase(this._repository);

  @override
  Future<void> call(UserEntity user) async {
    return await _repository.saveUserData(user);
  }
}
