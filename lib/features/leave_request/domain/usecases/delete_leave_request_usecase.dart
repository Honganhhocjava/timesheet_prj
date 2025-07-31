import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/leave_request/domain/repositories/leave_request_repository.dart';

class DeleteLeaveRequestUseCase implements UseCase<void, String> {
  final LeaveRequestRepository _repository;

  DeleteLeaveRequestUseCase(this._repository);

  @override
  Future<void> call(String params) async {
    return await _repository.deleteLeaveRequest(params);
  }
}
