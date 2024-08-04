part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeGetProfileUserEvent extends HomeEvent {}

class HomeLogoutEvent extends HomeEvent {}
