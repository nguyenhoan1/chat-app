import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_localization/flutter_localization.dart';

part 'change_language_state.dart';

class ChangeLanguageCubit extends Cubit<ChangeLanguageState> {
  final FlutterLocalization flutterLocalization;
  ChangeLanguageCubit({required this.flutterLocalization})
      : super(ChangeLanguageInitial());

  void changeLanguage(String key) {
    try {
      flutterLocalization.translate(key);
      if (key == Constants.id) {
        emit(ChangedLanguagetoIdState());
      } else {
        emit(ChangedLanguagetoEnState());
      }
    } catch (e) {
      emit(ChangeLanguageFailedState(errorMessage: e.toString()));
    }
  }
}
