import 'package:timesheet_project/features/attendance_adjustment/domain/entities/attendance_adjustment_entity.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

abstract class AttendanceAdjustmentRepository {
  Future<void> createAttendanceAdjustment(
    AttendanceAdjustmentEntity adjustment,
  );
  Future<List<AttendanceAdjustmentEntity>> getAttendanceAdjustmentsByUser(
    String userId,
  );
  Future<List<AttendanceAdjustmentEntity>> getAttendanceAdjustmentsByManager(
    String managerId,
  );
  Future<AttendanceAdjustmentEntity?> getAttendanceAdjustmentById(String id);
  Future<void> updateAttendanceAdjustmentStatus(
    String id,
    AttendanceAdjustmentStatus status,
    String? comment,
  );
  Future<void> updateAttendanceAdjustment(
    AttendanceAdjustmentEntity adjustment,
  );
  Future<void> deleteAttendanceAdjustment(String id);
  Future<List<UserEntity>> getManagerUsers();
}
