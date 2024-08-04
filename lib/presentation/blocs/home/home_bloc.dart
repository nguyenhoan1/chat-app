import 'package:bloc/bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/data/data_source/local/shared_preferences_data_source.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/user/profile_entity.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/usecase/user/get_profile_usecase.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProfileUsecase getProfileUsecase;
  final SharedPreferencesDataSource sharedPreferencesDataSource;
  HomeBloc(this.getProfileUsecase, this.sharedPreferencesDataSource)
      : super(const HomeInitial()) {
    on<HomeGetProfileUserEvent>(onHomeGetProfileUserEvent);
    on<HomeLogoutEvent>(onHomeLogoutEvent);
  }

  void onHomeGetProfileUserEvent(
      HomeGetProfileUserEvent event, Emitter<HomeState> emit) async {
    try {
      String? token =
          await sharedPreferencesDataSource.getString(Constants.accessTokenKey);
      emit(const HomeLoadingState(isLoading: true));
      var response = await getProfileUsecase(token!);
      emit(HomeSuccessState(response: response, isLoading: false));
    } catch (e) {
      emit(HomeFailedState(errorMessage: e.toString(), isLoading: false));
    }
  }

  void onHomeLogoutEvent(HomeLogoutEvent event, Emitter<HomeState> emit) async {
    try {
      await sharedPreferencesDataSource.clearUserData();
      emit(const HomeLogoutState());
    } catch (e) {
      emit(HomeLogoutFailedState(errorMessage: e.toString()));
    }
  }
}
