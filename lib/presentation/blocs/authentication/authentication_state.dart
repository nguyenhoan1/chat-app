part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {
  final bool isLoading;

  const AuthenticationState({this.isLoading = false});
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial() : super(isLoading: false);
}

class AuthLoginLoadingState extends AuthenticationState {
  const AuthLoginLoadingState({required super.isLoading});
}

class AuthLoginSuccessState extends AuthenticationState {
  final AuthLoginEntity response;

  const AuthLoginSuccessState(
      {required this.response, required super.isLoading});
}

class AuthLoginFailedState extends AuthenticationState {
  final String errorMessage;

  const AuthLoginFailedState(
      {required this.errorMessage, required super.isLoading});
}

class AuthRegisterSuccessState extends AuthenticationState {
  const AuthRegisterSuccessState({required super.isLoading});
}

class AuthRegisterFailedState extends AuthenticationState {
  final String  errorMessage;

  const AuthRegisterFailedState({
    required this.errorMessage,
    required super.isLoading,
  });
}