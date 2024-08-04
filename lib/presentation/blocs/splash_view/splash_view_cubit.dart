import 'package:bloc/bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/data/data_source/local/shared_preferences_data_source.dart';
import 'package:meta/meta.dart';

part 'splash_view_state.dart';

class SplashViewCubit extends Cubit<SplashViewState> {
  final SharedPreferencesDataSource sharedPreferencesDataSource;
  SplashViewCubit(this.sharedPreferencesDataSource) : super(SplashViewInitial());

  void navigateToNextScreen() async {
    if (await sharedPreferencesDataSource.getString(Constants.accessTokenKey) !=
        null) {
      emit(SplashViewNavigateToHomeState());
    } else {
      emit(SplashViewNavigateToLoginState());
    }
  }
}
