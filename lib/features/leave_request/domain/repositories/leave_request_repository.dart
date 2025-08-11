import 'package:timesheet_project/features/leave_request/domain/entities/leave_request_entity.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

abstract class LeaveRequestRepository {
  Future<void> createLeaveRequest(LeaveRequestEntity leaveRequest);
  Future<List<LeaveRequestEntity>> getLeaveRequestsByUser(String userId);
  Future<List<LeaveRequestEntity>> getLeaveRequestsByManager(String managerId);
  Future<LeaveRequestEntity?> getLeaveRequestById(String id);
  Future<void> updateLeaveRequestStatus(
    String id,
    RequestStatus status,
    String? comment,
  );
  Future<void> updateLeaveRequest(LeaveRequestEntity leaveRequest);
  Future<void> deleteLeaveRequest(String id);
  Future<List<UserEntity>> getManagerUsers();
}
