import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.userName,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['userId'] ?? json['id'] ?? '').toString(),
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}
