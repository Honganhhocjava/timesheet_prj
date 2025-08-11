import 'dart:io';

import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoadedImage extends UserState {
  final UserEntity user;
  File? avatarFile;

  UserLoadedImage(this.user, this.avatarFile);
}

class UserLoaded extends UserState {
  final UserEntity user;

  UserLoaded(this.user);
}

class UserSaved extends UserState {
  final String message;

  UserSaved(this.message);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class UserNotFound extends UserState {}

class SetUser extends UserState {
  final UserEntity user;

  SetUser(this.user);
}
