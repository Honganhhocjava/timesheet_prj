import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String firstName,
    required String lastName,
    required String phone,
    @TimestampConverter() required DateTime birthday,
    required String address,
    required String avatarUrl,
    required String role,
    @TimestampConverter() DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}


class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}

extension UserModelToEntity on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      birthday: birthday,
      address: address,
      avatarUrl: avatarUrl,
      role: role,
    );
  }
}

extension UserEntityToModel on UserEntity {
  UserModel toModel({DateTime? createdAt}) {
    return UserModel(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      birthday: birthday,
      address: address,
      avatarUrl: avatarUrl,
      role: role,
      createdAt: createdAt,
    );
  }
}
