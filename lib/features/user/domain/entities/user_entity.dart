class UserEntity {
  final String uid;
  final String firstName;
  final String lastName;
  final String phone;
  final DateTime birthday;
  final String address;
  final String avatarUrl;
  final String role;

  const UserEntity({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthday,
    required this.address,
    required this.avatarUrl,
    required this.role,
  });

  UserEntity copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? birthday,
    String? address,
    String? avatarUrl,
    String? role,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
    );
  }

}