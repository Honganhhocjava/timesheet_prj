import 'package:timesheet_project/features/overtime_request/domain/entities/overtime_request_entity.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

abstract class OvertimeRequestRepository {
  Future<void> createOvertimeRequest(OvertimeRequestEntity overtimeRequest);
  Future<List<OvertimeRequestEntity>> getOvertimeRequestsByUser(String userId);
  Future<List<OvertimeRequestEntity>> getOvertimeRequestsByManager(
    String managerId,
  );
  Future<OvertimeRequestEntity?> getOvertimeRequestById(String id);
  Future<List<UserEntity>> getManagers();
  Future<void> updateOvertimeRequestStatus(
    String id,
    OvertimeRequestStatus status,
    String? comment,
  );
  Future<void> updateOvertimeRequest(OvertimeRequestEntity overtimeRequest);
  Future<void> deleteOvertimeRequest(String id);
}
