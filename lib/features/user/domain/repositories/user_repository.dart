import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> saveUserData(UserEntity user);
  Future<UserEntity?> getUserData(String uid);
  Future<void> updateUserData(String uid, Map<String, dynamic> updates);
  Future<bool> userExists(String uid);
}
