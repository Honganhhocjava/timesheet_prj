import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';
import 'package:timesheet_project/features/overtime_request/domain/repositories/overtime_request_repository.dart';

class CreateOvertimeRequestUsecase
    implements UseCase<void, OvertimeRequestEntity> {
  final OvertimeRequestRepository repository;

  CreateOvertimeRequestUsecase({required this.repository});

  @override
  Future<void> call(OvertimeRequestEntity params) async {
    return await repository.createOvertimeRequest(params);
  }
}
