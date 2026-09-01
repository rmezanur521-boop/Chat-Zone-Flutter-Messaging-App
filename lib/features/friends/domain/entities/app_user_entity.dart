import 'package:equatable/equatable.dart';

class AppUserEntity extends Equatable {
  final String id;
  final String userName;
  final String? email;
  final String? avatarUrl;
  final bool isOnline;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? gender;
  final DateTime? dateOfBirth;

  const AppUserEntity({
    required this.id,
    required this.userName,
    this.email,
    this.avatarUrl,
    this.isOnline = false,
    this.firstName,
    this.lastName,
    this.bio,
    this.gender,
    this.dateOfBirth,
  });

  String get fullName {
    if ((firstName ?? '').isEmpty && (lastName ?? '').isEmpty) {
      return userName;
    }
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  @override
  List<Object?> get props => [
        id,
        userName,
        email,
        avatarUrl,
        isOnline,
        firstName,
        lastName,
        bio,
        gender,
        dateOfBirth,
      ];
}
