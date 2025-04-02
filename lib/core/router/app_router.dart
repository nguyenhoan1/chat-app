import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/upload_post/post_upload_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/views/authentication/login_view.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/views/authentication/register_view.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/views/home/home_view.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/views/home/widget/up_load_post_view.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/views/initial_splash/splash_view.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  static const String splashView = '/';
  static const String loginView = '/login';
  static const String homeView = '/home';
  static const String registerView = '/register';
  static const String uploadpostview = '/uploadpostview';
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    Utility.appLog(
      message: 'Current Route => ${routeSettings.name}',
      title: 'Route',
    );
    switch (routeSettings.name) {
      case splashView:
        return PageTransition(
          child: const SplashView(),
          type: PageTransitionType.fade,
        );
      case loginView:
        return PageTransition(
          child: const LoginView(),
          type: PageTransitionType.fade,
        );
      case homeView:
        return PageTransition(
          child: const HomeView(),
          type: PageTransitionType.bottomToTop,
        );
      case registerView:
        return PageTransition(
          child: const RegisterView(),
          type: PageTransitionType.fade,
        );
      case uploadpostview:
        return PageTransition(
          child: BlocProvider(
            create: (_) => PostUploadBloc(),
            child: const UploadPostView(),
          ),
          type: PageTransitionType.fade,
        );
      default:
        throw Exception("Route Not Found!");
    }
  }
}
