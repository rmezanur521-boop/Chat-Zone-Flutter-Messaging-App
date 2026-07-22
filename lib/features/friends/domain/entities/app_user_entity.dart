import 'package:equatable/equatable.dart';

/// Represents a basic user — reused across Friends, Groups, and
/// Search screens so we don't duplicate the same shape everywhere.
class AppUserEntity extends Equatable {
  final String id;
  final String userName;
  final String? email;
  final String? avatarUrl;
  final bool isOnline;

  const AppUserEntity({
    required this.id,
    required this.userName,
    this.email,
    this.avatarUrl,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [id, userName, email, avatarUrl, isOnline];
}
