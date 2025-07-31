import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/leave_request/domain/repositories/leave_request_repository.dart';

class UpdateLeaveRequestUseCase implements UseCase<void, LeaveRequestEntity> {
  final LeaveRequestRepository _repository;

  UpdateLeaveRequestUseCase(this._repository);

  @override
  Future<void> call(LeaveRequestEntity params) async {
    return await _repository.updateLeaveRequest(params);
  }
}
