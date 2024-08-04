import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int id;
  final String email;
  final String password;
  final String name;
  final String role;
  final String avatar;

  const ProfileEntity(
      {required this.id,
      required this.email,
      required this.password,
      required this.name,
      required this.role,
      required this.avatar});
  @override
  List<Object?> get props => [id, email, password, name, role, avatar];
}
