import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/router/app_router.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/splash_view/splash_view_cubit.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_spacing.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () => context.read<SplashViewCubit>().navigateToNextScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashViewCubit, SplashViewState>(
      listener: (context, state) {
        if (state is SplashViewNavigateToLoginState) {
          Navigator.pushNamed(context, AppRouter.loginView);
        }
        if (state is SplashViewNavigateToHomeState) {
          Navigator.pushNamed(context, AppRouter.homeView);
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Splash View',
                style: AppTheme.header2,
              ),
              const VerticalSpacing(),
              const CupertinoActivityIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
