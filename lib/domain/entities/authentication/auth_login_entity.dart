import 'package:equatable/equatable.dart';

class AuthLoginEntity extends Equatable {
  final String accessToken;
  final String refreshToken;

  const AuthLoginEntity({required this.accessToken, required this.refreshToken});
  @override
  List<Object?> get props => [accessToken, refreshToken];
}