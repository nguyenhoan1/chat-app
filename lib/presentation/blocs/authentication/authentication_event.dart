part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final AuthLoginParams params;

  AuthenticationLoginEvent({required this.params});
}