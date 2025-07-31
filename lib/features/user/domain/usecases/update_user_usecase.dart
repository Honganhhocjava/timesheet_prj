import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/user/domain/repositories/user_repository.dart';

class UpdateUserParams {
  final String uid;
  final Map<String, dynamic> updates;

  UpdateUserParams({required this.uid, required this.updates});
}

class UpdateUserUsecase implements UseCase<void, UpdateUserParams> {
  final UserRepository _repository;

  UpdateUserUsecase(this._repository);

  @override
  Future<void> call(UpdateUserParams params) async {
    return await _repository.updateUserData(params.uid, params.updates);
  }
}
