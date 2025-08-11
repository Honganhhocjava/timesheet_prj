import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/core/usecases/usecase.dart';
import 'package:timesheet_project/features/attendance/domain/entities/notification_entity.dart';
import 'package:timesheet_project/features/attendance/domain/repositories/notification_repository.dart';

class GetNotificationsByUserUsecase
    implements UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository notificationRepository;

  GetNotificationsByUserUsecase(this.notificationRepository);

  @override
  Future<List<NotificationEntity>> call(NoParams params) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }
    print('currentUser.uid');
    print(currentUser.uid);
    return await notificationRepository
        .getNotificationsByRecipientId(currentUser.uid);
  }
}
