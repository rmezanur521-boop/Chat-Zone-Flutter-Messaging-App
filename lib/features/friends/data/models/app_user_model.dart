import '../../domain/entities/app_user_entity.dart';

class AppUserModel extends AppUserEntity {
  const AppUserModel({
    required super.id,
    required super.userName,
    super.email,
    super.avatarUrl,
    super.isOnline,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: (json['id'] ?? json['userId'] ?? '').toString(),
      userName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString(),
      avatarUrl: json['profilePicture']?.toString(),
      isOnline: json['isOnline'] == true,
    );
  }
}
