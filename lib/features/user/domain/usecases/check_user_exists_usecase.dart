import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/user/domain/repositories/user_repository.dart';

class CheckUserExistsUsecase implements UseCase<bool, String> {
  final UserRepository _repository;

  CheckUserExistsUsecase(this._repository);

  @override
  Future<bool> call(String uid) async {
    return await _repository.userExists(uid);
  }
}
