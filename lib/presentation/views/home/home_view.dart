import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/base/base_state.dart';
import 'package:flutter_clean_architecture_bloc_template/core/localization/app_localization.dart';
import 'package:flutter_clean_architecture_bloc_template/core/router/app_router.dart';
import 'package:flutter_clean_architecture_bloc_template/core/services/local_notification_services.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_color.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/home/home_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_button.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_image_network.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_spacing.dart';
import 'package:flutter_localization/flutter_localization.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends BaseState<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeGetProfileUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return bodyView();
  }

  @override
  Widget bloc() {
    return BlocConsumer<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColor.tealColorPrimary,
            ),
          );
        }
        if (state is HomeSuccessState) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.formatString(
                        LocaleData.greetingText, [state.response.name]),
                    style: AppTheme.paragraph1,
                  ),
                  const VerticalSpacing(),
                  CustomImageNetwork(imageUrl: state.response.avatar),
                  const VerticalSpacing(
                    height: 8,
                  ),
                  Text(
                    state.response.email,
                    style: AppTheme.paragraph1,
                  ),
                  const VerticalSpacing(
                    height: 8,
                  ),
                  Text(
                    "${state.response.role} - ${state.response.password}",
                    style: AppTheme.paragraph1,
                  ),
                  const VerticalSpacing(),
                  CustomButton(
                    textButton: LocaleData.logoutText.getString(context),
                    onTap: () => context.read<HomeBloc>().add(
                          HomeLogoutEvent(),
                        ),
                  ),
                  TextButton(
                      onPressed: () {
                        LocalNotificationServices.showNotification(
                          title: 'This is Title',
                          body:
                              'This is the body of notification, lorem ipsum dolor sit amet.',
                          payload: '/',
                        );
                      },
                      child: Text('Show Notif'))
                ],
              ),
            ),
          );
        }
        if (state is HomeFailedState) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
        return const SizedBox();
      },
      listener: (context, state) {
        if (state is HomeLogoutState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.loginView,
            (route) => false,
          );
        }
        if (state is HomeLogoutFailedState) {
          Utility.customAlertDialog(
            message: state.errorMessage,
            onPressed: () => Navigator.pop(context),
            context: context,
            textButton: 'Ok',
            title: "Error",
          );
        }
      },
    );
  }

  @override
  Widget bodyView() {
    return Scaffold(body: bloc());
  }

  @override
  Widget footerView() {
    return const SizedBox();
  }
}
