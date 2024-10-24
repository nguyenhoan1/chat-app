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
    context
        .read<PermissionHandlerBloc>()
        .add(RequestPermissionEvent(PermissionType.camera));
    Future.delayed(
      const Duration(seconds: 1),
      () => context.read<SplashViewCubit>().navigateToNextScreen(),
    );
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
          },
        ),
      ],
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
