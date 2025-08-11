import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/attendance/domain/entities/notification_entity.dart';
import 'package:timesheet_project/features/attendance/domain/repositories/notification_repository.dart';

class CreateNotificationUsecase implements UseCase<void, NotificationEntity> {
  final NotificationRepository repository;

  CreateNotificationUsecase(this.repository);

  @override
  Future<void> call(NotificationEntity params) async {
    return await repository.createNotification(params);
  }
}
