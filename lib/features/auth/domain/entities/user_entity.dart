import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String userName;
  final String email;

  const UserEntity({
    required this.id,
    required this.userName,
    required this.email,
  });

  @override
  List<Object?> get props => [id, userName, email];
}
