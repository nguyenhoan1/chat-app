import 'package:bloc/bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/data/data_source/local/shared_preferences_data_source.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_login_params.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_register_params.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/authentication/auth_login_entity.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/usecase/authentication/%20register_usecase.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/usecase/authentication/login_usecase.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  // final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  bool isPasswordVisible = false;

  final SharedPreferencesDataSource sharedPreferencesDataSource;
  AuthenticationBloc(this.registerUseCase, this.sharedPreferencesDataSource)
      : super(const AuthenticationInitial()) {
    // on<AuthenticationLoginEvent>(onAuthLoginEvent);
    on<AuthenticationRegisterEvent>(onAuthRegisterEvent);
  }

  // void onAuthLoginEvent(
  //     AuthenticationLoginEvent event, Emitter<AuthenticationState> emit) async {
  //   try {
  //     emit(const AuthLoginLoadingState(isLoading: true));
  //     final response = await loginUseCase(event.params);
  //     emit(AuthLoginSuccessState(response: response, isLoading: false));
  //     await sharedPreferencesDataSource.setString(
  //       Constants.accessTokenKey,
  //       response.accessToken,
  //     );
  //     await sharedPreferencesDataSource.setString(
  //       Constants.refreshTokenKey,
  //       response.refreshToken,
  //     );
  //   } catch (e) {
  //     emit(AuthLoginFailedState(errorMessage: e.toString(), isLoading: false));
  //   }
  // }

 Future<void> onAuthRegisterEvent(
    AuthenticationRegisterEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthRegisterSuccessState(isLoading: true));
      await registerUseCase(event.params);
      emit(const AuthRegisterSuccessState(isLoading: false));
    } catch (e) {
      emit(AuthRegisterFailedState(errorMessage: e.toString(), isLoading: false));
    }
  }
}
