part of 'change_language_cubit.dart';

abstract class ChangeLanguageState extends Equatable {
  const ChangeLanguageState();

  @override
  List<Object> get props => [];
}

class ChangeLanguageInitial extends ChangeLanguageState {}

class ChangeLanguageSuccessState extends ChangeLanguageState {
  final String currentLocale;

  ChangeLanguageSuccessState({required this.currentLocale});
}

class ChangedLanguagetoIdState extends ChangeLanguageState {}

class ChangedLanguagetoEnState extends ChangeLanguageState {}

class ChangeLanguageFailedState extends ChangeLanguageState {
  final String errorMessage;

  ChangeLanguageFailedState({required this.errorMessage});
}
