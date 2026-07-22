import 'user_model.dart';

class AuthResponseModel {
  final String token;
  final UserModel user;
  final DateTime? expiresAt;

  AuthResponseModel({required this.token, required this.user, this.expiresAt});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token']?.toString() ?? '',
      user: UserModel.fromJson(json),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
    );
  }
}
