import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_bloc_template/core/network/call_api_services.dart';
import 'package:flutter_clean_architecture_bloc_template/core/services/local_notification_services.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';
import 'package:flutter_clean_architecture_bloc_template/data/data_source/local/local_database_data_source.dart';
import 'package:flutter_clean_architecture_bloc_template/data/data_source/local/shared_preferences_data_source.dart';
import 'package:flutter_clean_architecture_bloc_template/data/data_source/remote/auth_remote_source.dart';
import 'package:flutter_clean_architecture_bloc_template/data/data_source/remote/user_remote_source.dart';
import 'package:flutter_clean_architecture_bloc_template/data/repositories/authentication/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_bloc_template/data/repositories/user/user_repository_impl.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/repositories/authentication/auth_repository.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/repositories/user/user_repository.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/usecase/authentication/login_usecase.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/usecase/user/get_profile_usecase.dart';
import 'package:flutter_clean_architecture_bloc_template/main.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/cubit/change_language/change_language_cubit.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/cubit/password_visible/password_visibility_cubit.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/home/home_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/splash_view/splash_view_cubit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initLocatorServices() async {
  /// BLOC and CUBIT
  sl.registerFactory(
    () => SplashViewCubit(sl()),
  );

  sl.registerFactory(
    () => ChangeLanguageCubit(flutterLocalization: sl()),
  );

  sl.registerFactory(
    () => PasswordVisibilityCubit(),
  );

  sl.registerFactory(
    () => AuthenticationBloc(sl(), sl()),
  );

  sl.registerFactory(() => HomeBloc(
        sl(),
        sl(),
      ));

  /// REPOSITORY
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteSource: sl()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userRemoteSource: sl()),
  );

  /// USECASE
  sl.registerLazySingleton(
    () => LoginUseCase(authRepository: sl()),
  );

  sl.registerLazySingleton(
    () => GetProfileUsecase(userRepository: sl()),
  );

  /// DATA SOURCE
  sl.registerLazySingleton<AuthRemoteSource>(
    () => AuthRemoteSourceImpl(callApiService: sl()),
  );
  sl.registerLazySingleton<UserRemoteSource>(
    () => UserRemoteSourceImpl(callApiService: sl()),
  );
  sl.registerLazySingleton<SharedPreferencesDataSource>(
    () => SharedPreferencesDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<LocalDatabaseDataSource>(
    () => LocalDatabaseDataSourceImpl(databaseService: sl()),
  );

  /// EXTERNAL
  sl.registerLazySingleton(
    () => Dio(),
  );

  sl.registerLazySingleton(
    () => CallApiService(dio: sl()),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(
    () => sharedPreferences,
  );

  sl.registerLazySingleton(
    () => MyApp(flutterLocalization: sl()),
  );

  sl.registerLazySingleton<FlutterLocalization>(
    () => FlutterLocalization.instance,
  );

  sl.registerLazySingleton(
    () => FlutterLocalNotificationsPlugin(),
  );

  sl.registerLazySingleton(
    () => BehaviorSubject<String>(),
  );

  sl.registerLazySingleton(
    () => LocalNotificationServices(
        flutterLocalNotificationsPlugin: sl(), onClickNotification: sl()),
  );

  sl.registerSingleton<Utility>(
    Utility(
      sl<SharedPreferencesDataSource>(),
      sl<FlutterLocalization>(),
    ),
  );

  await LocalNotificationServices.initialize();
}
