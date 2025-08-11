import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/domain/usecases/save_user_usecase.dart';
import 'package:timesheet_project/features/user/domain/usecases/get_user_usecase.dart';
import 'package:timesheet_project/features/user/domain/usecases/update_user_usecase.dart';
import 'package:timesheet_project/features/user/domain/usecases/check_user_exists_usecase.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final SaveUserUsecase _saveUserUsecase;
  final GetUserUsecase _getUserUsecase;
  final UpdateUserUsecase _updateUserUsecase;
  final CheckUserExistsUsecase _checkUserExistsUsecase;

  UserCubit(
    this._saveUserUsecase,
    this._getUserUsecase,
    this._updateUserUsecase,
    this._checkUserExistsUsecase,
  ) : super(UserInitial());

  Future<void> saveUser(UserEntity user) async {
    emit(UserLoading());
    try {
      await _saveUserUsecase(user);
      emit(UserSaved('Đã lưu thông tin người dùng thành công!'));
    } catch (e) {
      emit(UserError('Lỗi khi lưu thông tin: $e'));
    }
  }

  Future<void> getCurrentUser() async {
    emit(UserLoading());
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        UserEntity? user = await _getUserUsecase(currentUser.uid);
        if (user != null) {
          emit(UserLoaded(user));
        } else {
          emit(UserNotFound());
        }
      } else {
        emit(UserError('Không có người dùng đăng nhập'));
      }
    } catch (e) {
      emit(UserError('Lỗi khi tải thông tin người dùng: $e'));
    }
  }

  Future<void> getUserData(String uid) async {
    emit(UserLoading());
    try {
      UserEntity? user = await _getUserUsecase(uid);
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserNotFound());
      }
    } catch (e) {
      emit(UserError('Lỗi khi tải thông tin người dùng: $e'));
    }
  }

  Future<bool> checkUserExists(String uid) async {
    try {
      return await _checkUserExistsUsecase(uid);
    } catch (e) {
      emit(UserError('Lỗi kiểm tra người dùng: $e'));
      return false;
    }
  }

  // Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
  //   emit(UserLoading());
  //   try {
  //     final params = UpdateUserParams(uid: uid, updates: updates);
  //     await _updateUserUsecase(params);
  //
  //     UserEntity? updatedUser = await _getUserUsecase(uid);
  //     if (updatedUser != null) {
  //       emit(UserLoaded(updatedUser));
  //     }
  //   } catch (e) {
  //     emit(UserError('Lỗi cập nhật: $e'));
  //   }
  // }
  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    emit(UserLoading());
    try {
      await _updateUserUsecase(UpdateUserParams(uid: uid, updates: updates));
      emit(UserSaved('Đã cập nhật thành công!'));
      final updatedUser = await _getUserUsecase(uid);
      if (updatedUser != null) emit(UserLoaded(updatedUser));
    } catch (e) {
      emit(UserError('Lỗi cập nhật: $e'));
    }
  }

  void resetState() {
    emit(UserInitial());
  }

  void setUser(UserEntity user) {
    emit(UserLoaded(user));
  }

  void avatarChanged(File file) {
    final currentState = state;
    if (currentState is UserLoaded) {
      emit(UserLoadedImage(currentState.user, file));
    }
  }
}
