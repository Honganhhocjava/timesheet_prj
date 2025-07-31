import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/repositories/attendance_adjustment_repository.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

class GetManagersUsecase implements UseCase<List<UserEntity>, NoParams> {
  final AttendanceAdjustmentRepository repository;

  GetManagersUsecase(this.repository);

  @override
  Future<List<UserEntity>> call(NoParams params) async {
    return await repository.getManagerUsers();
  }
}
