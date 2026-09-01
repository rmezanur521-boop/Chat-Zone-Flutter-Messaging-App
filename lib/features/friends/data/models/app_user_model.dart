import '../../domain/entities/app_user_entity.dart';

class AppUserModel extends AppUserEntity {
  const AppUserModel({
    required super.id,
    required super.userName,
    super.email,
    super.avatarUrl,
    super.isOnline,
    super.firstName,
    super.lastName,
    super.bio,
    super.gender,
    super.dateOfBirth,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: (json['id'] ?? json['userId'] ?? '').toString(),
      userName:
          json['fullName']?.toString() ?? json['userName']?.toString() ?? '',
      email: json['email']?.toString(),
      avatarUrl: json['profilePicture']?.toString(),
      isOnline: json['isOnline'] == true,
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      bio: json['bio']?.toString(),
      gender: json['gender']?.toString(),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'].toString())
          : null,
    );
  }
}
