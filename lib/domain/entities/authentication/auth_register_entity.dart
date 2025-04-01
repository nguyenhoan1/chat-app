import 'package:equatable/equatable.dart';

class AuthRegisterEntity extends Equatable {
  final String message;

  const AuthRegisterEntity({required this.message});

  @override
  List<Object?> get props => [message];
}
