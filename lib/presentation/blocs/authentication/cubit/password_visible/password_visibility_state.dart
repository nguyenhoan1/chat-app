part of 'password_visibility_cubit.dart';

abstract class PasswordVisibilityState extends Equatable {
  final bool isPasswordVisible;
  const PasswordVisibilityState({this.isPasswordVisible = false});

  @override
  List<Object> get props => [isPasswordVisible];
}

class PasswordVisibilityInitial extends PasswordVisibilityState {}

class PasswordVisibilityChangedState extends PasswordVisibilityState {
  PasswordVisibilityChangedState({required super.isPasswordVisible});
}
