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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isMounted = true;

  @override
  void dispose() {
    _isMounted = false;
    _emailController.dispose();
    _passwordController.dispose();
    // Xóa tất cả snackbar đang chờ xử lý khi màn hình bị hủy
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
    super.dispose();
  }

  void _showSnackbarIfMounted({required String message, required String type}) {
    if (_isMounted && mounted && context.findRenderObject() != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: type == Constants.SUCCESS
              ? Colors.green
              : (type == Constants.ERROR ? Colors.red : Colors.blue),
          duration: const Duration(seconds: 2),
        ),
      );

      // Nếu vẫn muốn sử dụng Utility.customSnackbar, bạn có thể bọc nó như sau:
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   if (_isMounted && mounted) {
      //     Utility.customSnackbar(
      //       message: message,
      //       typeInfo: type,
      //       context: context,
      //     );
      //   }
      // });
    }
  }

  void _showAlertDialogIfMounted(String errorMessage) {
    if (_isMounted && mounted && context.findRenderObject() != null) {
      Utility.customAlertDialog(
        context: context,
        message: errorMessage,
        onPressed: () => Navigator.pop(context),
        textButton: "Ok",
        title: "Error",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: MultiBlocListener(
            listeners: [
              BlocListener<ChangeLanguageCubit, ChangeLanguageState>(
                listener: (context, state) {
                  Future.delayed(Duration(milliseconds: 100), () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final currentLangCode = Utility.getCurrentLocalization();
                      final languageName = currentLangCode == Constants.vi
                          ? "TIẾNG VIỆT"
                          : "ENGLISH";

                      if (!mounted) return;

                      Utility.customSnackbar(
                        message: LocaleData.languageState
                            .getString(context)
                            .replaceFirst('%a', languageName),
                        typeInfo: Constants.SUCCESS,
                        context: context,
                      );
                    });
                  });
                },
              ),
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is AuthLoginSuccessState && mounted) {
                    // Xóa tất cả snackbar trước khi chuyển trang
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.homeView,
                      (route) => false,
                    );
                  }
                  if (state is AuthLoginFailedState) {
                    _showAlertDialogIfMounted(state.errorMessage);
                  }
                },
              )
            ],
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                context
                                    .read<ChangeLanguageCubit>()
                                    .changeLanguage(
                                      Utility.getCurrentLocalization() !=
                                              Constants.eng
                                          ? Constants.eng
                                          : Constants.vi,
                                    );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      Utility.assetPathImage(
                                        fileName:
                                            Utility.getCurrentLocalization(),
                                      ),
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.language, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        LocaleData.loginTitle.getString(context),
                        style: AppTheme.header1.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextfield(
                              controller: _emailController,
                              title: LocaleData.email.getString(context),
                              hintText: LocaleData.emailHint.getString(context),
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: Colors.blue),
                            ),
                            const VerticalSpacing(height: 20),
                            BlocBuilder<PasswordVisibilityCubit,
                                PasswordVisibilityState>(
                              builder: (context, state) => CustomTextfield(
                                controller: _passwordController,
                                isPassword: true,
                                isVisiblePassword: state.isPasswordVisible,
                                onTapPasswordVisible: () => context
                                    .read<PasswordVisibilityCubit>()
                                    .passwordVisible(state.isPasswordVisible),
                                title: LocaleData.password.getString(context),
                                hintText:
                                    LocaleData.passwordHint.getString(context),
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: Colors.blue),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<AuthenticationBloc,
                                AuthenticationState>(
                              builder: (context, state) => SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                          var params = AuthLoginParams(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          );
                                          context
                                              .read<AuthenticationBloc>()
                                              .add(
                                                AuthenticationLoginEvent(
                                                  params: params,
                                                ),
                                              );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: state.isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          LocaleData.loginText
                                              .getString(context),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      FutureBuilder(
                        future: Utility.getBuildNumberVersionApp(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              context.formatString(
                                  LocaleData.version, [snapshot.data!]),
                              style: AppTheme.paragraph2.copyWith(
                                color: AppColor.grayColor,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Text(
                              LocaleData.versionNotFound,
                              style: AppTheme.paragraph2.copyWith(
                                color: AppColor.grayColor,
                                fontSize: 12,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
