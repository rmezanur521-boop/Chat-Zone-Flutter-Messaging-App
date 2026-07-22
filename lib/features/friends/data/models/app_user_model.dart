import '../../domain/entities/app_user_entity.dart';

class AppUserModel extends AppUserEntity {
  const AppUserModel({
    required super.id,
    required super.userName,
    super.email,
    super.avatarUrl,
    super.isOnline,
  });

  // ⚠️ Verify these keys against the actual backend JSON.
  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: (json['userId'] ?? json['id'] ?? '').toString(),
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString(),
      avatarUrl: json['profilePictureUrl']?.toString() ??
          json['avatarUrl']?.toString(),
      isOnline: json['isOnline'] == true,
    );
  }
}
