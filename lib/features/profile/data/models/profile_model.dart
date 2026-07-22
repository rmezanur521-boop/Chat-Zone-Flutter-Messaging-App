import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.userName,
    required super.email,
    super.bio,
    super.avatarUrl,
  });

  // ⚠️ Verify these keys against the actual /api/profile response.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: (json['userId'] ?? json['id'] ?? '').toString(),
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      bio: json['bio']?.toString(),
      avatarUrl: json['profilePictureUrl']?.toString() ??
          json['avatarUrl']?.toString(),
    );
  }
}
