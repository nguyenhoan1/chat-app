import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/router/app_router.dart';
import 'package:flutter_clean_architecture_bloc_template/core/services/locator_services.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/app_bloc_observer.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utils/app_config.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/cubit/change_language/change_language_cubit.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/cubit/password_visible/password_visibility_cubit.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/home/home_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/permission/permission_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/splash_view/splash_view_cubit.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  await initLocatorServices();
  await AppConfig.loadEnv();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: AppConfig.firebaseOptions);
  }

  runApp(MyApp(
    flutterLocalization: sl(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.flutterLocalization});

  final FlutterLocalization flutterLocalization;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Utility.configLocalization(
      (_) {
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PermissionHandlerBloc>(
          create: (context) => PermissionHandlerBloc(
              requestPermissionUseCase: sl(),
              checkPermissionStatusUseCase: sl()),
        ),
        BlocProvider(
          create: (context) => AuthenticationBloc(sl(), sl()),
        ),
        BlocProvider(
          create: (context) => ChangeLanguageCubit(flutterLocalization: sl()),
        ),
        BlocProvider(
          create: (context) => PasswordVisibilityCubit(),
        ),
        BlocProvider(
          create: (context) => SplashViewCubit(sl()),
        ),
        BlocProvider(
          create: (context) => HomeBloc(sl(), sl()),
        )
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            title: 'Our Social Media',
            debugShowCheckedModeBanner: false,
            localizationsDelegates:
                widget.flutterLocalization.localizationsDelegates,
            supportedLocales: widget.flutterLocalization.supportedLocales,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              fontFamily: "Poppins",
              useMaterial3: false,
            ),
            initialRoute: AppRouter.splashView,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
