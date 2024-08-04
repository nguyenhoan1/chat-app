part of 'home_bloc.dart';

@immutable
abstract class HomeState {
  final bool isLoading;

  const HomeState({required this.isLoading});
}

class HomeInitial extends HomeState {
  const HomeInitial() : super(isLoading: false);
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState({required super.isLoading});
}

class HomeSuccessState extends HomeState {
  final ProfileEntity response;

  const HomeSuccessState({required this.response, required super.isLoading});
}

class HomeFailedState extends HomeState {
  final String errorMessage;

  const HomeFailedState({required this.errorMessage, required super.isLoading});
}

class HomeLogoutState extends HomeState {
  const HomeLogoutState() : super(isLoading: false);
}

class HomeLogoutFailedState extends HomeState {
  final String errorMessage;
  const HomeLogoutFailedState({required this.errorMessage})
      : super(isLoading: false);
}
