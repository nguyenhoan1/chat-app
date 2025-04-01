import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/core/localization/app_localization.dart';
import 'package:flutter_clean_architecture_bloc_template/core/router/app_router.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_color.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_register_params.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/cubit/change_language/change_language_cubit.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/authentication/cubit/password_visible/password_visibility_cubit.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_spacing.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_textfield.dart';
import 'package:flutter_localization/flutter_localization.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8 && 
           RegExp(r'[A-Za-z]').hasMatch(password) && 
           RegExp(r'[0-9]').hasMatch(password);
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;
    if (!_termsAccepted) {
      Utility.customSnackbar(
        message: "Please accept the terms and conditions",
        typeInfo: Constants.ERROR,
        context: context,
      );
      return false;
    }
    return true;
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
                  if (state is ChangedLanguagetoIdState) {
                    Utility.customSnackbar(
                        message: context.formatString(
                            LocaleData.languageState, [Constants.vietnam]),
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
                  if (state is AuthRegisterSuccessState) {
                    Utility.customSnackbar(
                      message: "Registration successful! Please login.",
                      typeInfo: Constants.SUCCESS,
                      context: context,
                    );
                    Navigator.pushReplacementNamed(
                      context,
                      AppRouter.loginView,
                    );
                  }
                  if (state is AuthRegisterFailedState) {
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 30),
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
                                  context.read<ChangeLanguageCubit>().changeLanguage(
                                        Utility.getCurrentLocalization() != Constants.eng
                                            ? Constants.eng
                                            : Constants.vi,
                                      );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        Utility.assetPathImage(
                                          fileName: Utility.getCurrentLocalization(),
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
                        
                        const SizedBox(height: 20),
                        Container(
                          width: 100,
                          height: 100,
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
                        
                        const SizedBox(height: 20),
                        Text(
                          "Create Account",
                          style: AppTheme.header1.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        Text(
                          "Join us today and get started",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 30),
                        
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
                              // Full Name field
                              CustomTextfield(
                                controller: _nameController,
                                title: "Full Name",
                                hintText: "Enter your full name",
                                prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your name";
                                  }
                                  return null;
                                }, keyboardType: TextInputType.text,
                              ),
                              
                              const VerticalSpacing(height: 20),
                              
                              // Email field
                              CustomTextfield(
                                controller: _emailController,
                                title: "Email",
                                hintText: "Enter your email address",
                                prefixIcon: const Icon(Icons.email_outlined, color: Colors.blue),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your email";
                                  }
                                  if (!_isValidEmail(value)) {
                                    return "Please enter a valid email";
                                  }
                                  return null;
                                },
                              ),
                              
                              const VerticalSpacing(height: 20),
                              BlocBuilder<PasswordVisibilityCubit, PasswordVisibilityState>(
                                builder: (context, state) => CustomTextfield(
                                  controller: _passwordController,
                                  isPassword: true,
                                  isVisiblePassword: state.isPasswordVisible,
                                  onTapPasswordVisible: () => context
                                      .read<PasswordVisibilityCubit>()
                                      .passwordVisible(state.isPasswordVisible),
                                  title: "Password",
                                  hintText: "Create a password",
                                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a password";
                                    }
                                    if (!_isValidPassword(value)) {
                                      return "Password must be at least 8 characters with letters and numbers";
                                    }
                                    return null;
                                  }, keyboardType: TextInputType.text,
                                ),
                              ),
                              
                              const VerticalSpacing(height: 20),
                              BlocBuilder<PasswordVisibilityCubit, PasswordVisibilityState>(
                                builder: (context, state) => CustomTextfield(
                                  controller: _confirmPasswordController,
                                  isPassword: true,
                                  isVisiblePassword: state.isPasswordVisible,
                                  onTapPasswordVisible: () => context
                                      .read<PasswordVisibilityCubit>()
                                      .passwordVisible(state.isPasswordVisible),
                                  title: "Confirm Password",
                                  hintText: "Confirm your password",
                                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please confirm your password";
                                    }
                                    if (value != _passwordController.text) {
                                      return "Passwords do not match";
                                    }
                                    return null;
                                  }, keyboardType: TextInputType.text,
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Terms and conditions checkbox
                              Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: _termsAccepted,
                                      onChanged: (value) {
                                        setState(() {
                                          _termsAccepted = value ?? false;
                                        });
                                      },
                                      activeColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: "I agree to the ",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "Terms of Service",
                                            style: TextStyle(
                                              color: Colors.blue.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: " and ",
                                          ),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: TextStyle(
                                              color: Colors.blue.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Register button
                              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                                builder: (context, state) => SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: state.isLoading 
                                      ? null 
                                      : () {
                                          if (_validateForm()) {
                                            final params = AuthRegisterParams(
                                              name: _nameController.text,
                                              email: _emailController.text,
                                              password: _passwordController.text,
                                            );
                                            
                                            context.read<AuthenticationBloc>().add(
                                              AuthenticationRegisterEvent(
                                                params: params,
                                              ),
                                            );
                                          }
                                        },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade600,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                                      : const Text(
                                          "Create Account",
                                          style: TextStyle(
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
                              "Already have an account?",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRouter.loginView,
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 30),
                        FutureBuilder(
                          future: Utility.getBuildNumberVersionApp(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                context.formatString(LocaleData.version, [snapshot.data!]),
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
      ),
    );
  }
}