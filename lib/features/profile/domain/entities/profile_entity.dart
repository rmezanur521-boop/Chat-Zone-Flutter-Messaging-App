import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String userName;
  final String email;
  final String? bio;
  final String? avatarUrl;

  const ProfileEntity({
    required this.id,
    required this.userName,
    required this.email,
    this.bio,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, userName, email, bio, avatarUrl];
}
