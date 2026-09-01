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
  final bool isFriend;
  final bool isRequestSent;

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
    this.isFriend = false,
    this.isRequestSent = false,
  });

  String get fullName {
    if ((firstName ?? '').isEmpty && (lastName ?? '').isEmpty) {
      return userName;
    }
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  AppUserEntity copyWith({bool? isRequestSent}) {
    return AppUserEntity(
      id: id,
      userName: userName,
      email: email,
      avatarUrl: avatarUrl,
      isOnline: isOnline,
      firstName: firstName,
      lastName: lastName,
      bio: bio,
      gender: gender,
      dateOfBirth: dateOfBirth,
      isFriend: isFriend,
      isRequestSent: isRequestSent ?? this.isRequestSent,
    );
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
        isFriend,
        isRequestSent,
      ];
}
