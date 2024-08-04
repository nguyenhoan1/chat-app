import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/core/localization/app_localization.dart';
import 'package:flutter_clean_architecture_bloc_template/core/router/app_router.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_color.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_login_params.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/cubit/change_language/change_language_cubit.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/cubit/password_visible/password_visibility_cubit.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_button.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_spacing.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_textfield.dart';
import 'package:flutter_localization/flutter_localization.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController(text: 'john@mail.com');
  final _passwordController = TextEditingController(text: 'changeme');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: MultiBlocListener(
          listeners: [
            BlocListener<ChangeLanguageCubit, ChangeLanguageState>(
              listener: (context, state) {
                if (state is ChangedLanguagetoIdState) {
                  Utility.customSnackbar(
                      message: context.formatString(
                          LocaleData.languageState, [Constants.indonesia]),
                      typeInfo: Constants.SUCCESS,
                      context: context);
                }
                if (state is ChangedLanguagetoEnState) {
                  Utility.customSnackbar(
                      message: context.formatString(
                          LocaleData.languageState, [Constants.english]),
                      typeInfo: Constants.SUCCESS,
                      context: context);
                }
              },
            ),
            BlocListener<PasswordVisibilityCubit, PasswordVisibilityState>(
              listener: (context, state) {
                if (state is PasswordVisibilityChangedState) {}
              },
            ),
            BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthLoginSuccessState) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.homeView,
                    (route) => false,
                  );
                }
                if (state is AuthLoginFailedState) {
                  Utility.customAlertDialog(
                    context: context,
                    message: state.errorMessage,
                    onPressed: () => Navigator.pop(context),
                    textButton: "Ok",
                    title: "Error",
                  );
                }
              },
            )
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              InkWell(
                onTap: () {
                  context.read<ChangeLanguageCubit>().changeLanguage(
                        Utility.getCurrentLocalization() != Constants.eng
                            ? Constants.eng
                            : Constants.id,
                      );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Utility.assetPathImage(
                        fileName: Utility.getCurrentLocalization(),
                      ),
                      height: 25,
                      width: 25,
                    ),
                    Icon(Icons.language),
                  ],
                ),
              ),
              Text(
                LocaleData.loginTitle.getString(context),
                style: AppTheme.header1,
              ),
              Text(
                LocaleData.loginDesc.getString(context),
                style: AppTheme.paragraph1,
              ),
              const VerticalSpacing(
                height: 32,
              ),
              CustomTextfield(
                controller: _emailController,
                title: LocaleData.email.getString(context),
                hintText: LocaleData.emailHint.getString(context),
              ),
              const VerticalSpacing(),
              BlocBuilder<PasswordVisibilityCubit, PasswordVisibilityState>(
                builder: (context, state) => CustomTextfield(
                  controller: _passwordController,
                  isPassword: true,
                  isVisiblePassword: state.isPasswordVisible,
                  onTapPasswordVisible: () => context
                      .read<PasswordVisibilityCubit>()
                      .passwordVisible(state.isPasswordVisible),
                  title: LocaleData.password.getString(context),
                  hintText: LocaleData.passwordHint.getString(context),
                ),
              ),
              const VerticalSpacing(
                height: 36,
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) => CustomButton(
                  textButton: LocaleData.loginText.getString(context),
                  isLoading: state.isLoading,
                  onTap: () {
                    var params = AuthLoginParams(
                        email: _emailController.text,
                        password: _passwordController.text);
                    context.read<AuthenticationBloc>().add(
                          AuthenticationLoginEvent(
                            params: params,
                          ),
                        );
                  },
                ),
              ),
              Spacer(),
              FutureBuilder(
                future: Utility.getBuildNumberVersionApp(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      context
                          .formatString(LocaleData.version, [snapshot.data!]),
                      style: AppTheme.paragraph2.copyWith(
                        color: AppColor.grayColor,
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return Text(
                      LocaleData.versionNotFound,
                      style: AppTheme.paragraph2.copyWith(
                        color: AppColor.grayColor,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
