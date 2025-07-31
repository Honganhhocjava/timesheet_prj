import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/domain/repositories/user_repository.dart';

class GetUserUsecase implements UseCase<UserEntity?, String> {
  final UserRepository _repository;

  GetUserUsecase(this._repository);

  @override
  Future<UserEntity?> call(String uid) async {
    return await _repository.getUserData(uid);
  }
}
