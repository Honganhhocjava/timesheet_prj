import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/domain/repositories/user_repository.dart';
import 'package:timesheet_project/features/user/data/models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveUserData(UserEntity user) async {
    try {
      final userModel = user.toModel(createdAt: DateTime.now());
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());
    } catch (e) {
      debugPrint("Lỗi khi lưu thông tin người dùng: $e");
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        data['uid'] = uid;

        final userModel = UserModel.fromJson(data);
        return userModel.toEntity();
      } else {
        debugPrint("Tài liệu không tồn tại.");
        return null;
      }
    } catch (e) {
      debugPrint("Lỗi khi đọc thông tin người dùng: $e");
      return null;
    }
  }

  @override
  Future<void> updateUserData(String uid, Map<String, dynamic> updates) async {
    try {
      if (updates.containsKey('birthday') && updates['birthday'] is DateTime) {
        updates['birthday'] = Timestamp.fromDate(updates['birthday']);
      }
      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      debugPrint("Lỗi cập nhật: $e");
      rethrow;
    }
  }

  @override
  Future<bool> userExists(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      return doc.exists;
    } catch (e) {
      debugPrint("Lỗi kiểm tra user tồn tại: $e");
      return false;
    }
  }
}
