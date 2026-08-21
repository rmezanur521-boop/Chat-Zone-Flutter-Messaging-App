import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String userName;
  final String email;
  final String firstName;
  final String lastName;
  final String? bio;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? avatarUrl;

  const ProfileEntity({
    required this.id,
    required this.userName,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.bio,
    this.gender,
    this.dateOfBirth,
    this.avatarUrl,
  });

  String get fullName {
    final combined = '$firstName $lastName'.trim();
    return combined.isEmpty ? userName : combined;
  }

  @override
  List<Object?> get props => [
        id,
        userName,
        email,
        firstName,
        lastName,
        bio,
        gender,
        dateOfBirth,
        avatarUrl,
      ];
}
