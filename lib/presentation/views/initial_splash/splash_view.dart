import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/core/router/app_router.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/permission/permission_type.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/permission/permission_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/splash_view/splash_view_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

@override
void initState() {
  super.initState();

  // Khởi tạo animation
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  context
      .read<PermissionHandlerBloc>()
      .add(RequestPermissionEvent(PermissionType.camera));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future.delayed(const Duration(seconds: 2), () {
      context.read<SplashViewCubit>().navigateToNextScreen();
    });
  });
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashViewCubit, SplashViewState>(
          listener: (context, state) {
            if (state is SplashViewNavigateToLoginState) {
              Navigator.pushNamed(context, AppRouter.loginView);
            }
            if (state is SplashViewNavigateToHomeState) {
              Navigator.pushNamed(context, AppRouter.homeView);
            }
          },
        ),
        BlocListener<PermissionHandlerBloc, PermissionHandlerState>(
          listener: (context, state) {
            if (state is PermissionHandlerSuccess) {
              Utility.customSnackbar(
                message: "Permission ${state.isGranted.toString()}",
                typeInfo: Constants.SUCCESS,
                context: context,
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Future.delayed(
                  const Duration(seconds: 1),
                  () => context.read<SplashViewCubit>().navigateToNextScreen(),
                );
              });
            }
            if (state is PermissionHandlerFailed) {
              Utility.customSnackbar(
                message: "Permission ${state.isGranted.toString()}",
                typeInfo: Constants.WARNING,
                context: context,
              );
            }
            if (state is PermissionHandlerError) {
              Utility.customSnackbar(
                  message: state.message,
                  typeInfo: Constants.ERROR,
                  context: context);
            }
            if (state is CheckPermissionHandlerFailed) {
              context
                  .read<PermissionHandlerBloc>()
                  .add(RequestPermissionEvent(PermissionType.camera));
            }
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated logo
              ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 20),
              // Welcome message
              Text(
                'Welcome to ChatApp',
                style: AppTheme.header2.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              Text('Connecting the world through chat.',
                  style: AppTheme.paragraph1),
              const SizedBox(height: 30),
              // Loading indicator
              const CupertinoActivityIndicator(
                radius: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
