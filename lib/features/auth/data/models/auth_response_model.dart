import 'user_model.dart';

class AuthResponseModel {
  final String token;
  final String refreshToken;
  final UserModel user;
  final DateTime? expiresAt;

  AuthResponseModel({
    required this.token,
    required this.refreshToken,
    required this.user,
    this.expiresAt,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      user: UserModel.fromJson(json),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
    );
  }
}
