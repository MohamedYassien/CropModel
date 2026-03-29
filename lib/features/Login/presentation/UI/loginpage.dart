import 'dart:io';
import 'package:cropmodel/core/utils/helpers.dart';
import 'package:cropmodel/features/Login/presentation/UI/widgets/SnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/shared/custom_text_field.dart';
import '../../../sign_up/presentation/UI/sign_up_presenter.dart';
import '../../data/service/SecureStorage.dart';
import '../bloc/LoginBloc.dart';
import '../bloc/LoginEvent.dart';
import '../bloc/LoginState.dart';
import '../../data/service/BiometricService.dart';
import 'MainPage.dart';
import '../../../../../core/constants/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(BuildContext context) {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    context.read<LoginBloc>().add(
      LoginWithEmailEvent(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => LoginBloc(
        biometricService: BiometricService(),
        secureStorage: SecureStorage(),
      ),
      child: Builder(
        builder: (context) {
          final state = context.watch<LoginBloc>().state;
          final bool isLoading = state is LoginLoading;

          return Scaffold(
            body: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (!mounted) return;
                if (state is LoginSuccess) {
                  if (state is LoginSuccess) {
                    AppSnackBar.show(
                      context: context,
                      message: "Login successful",
                      backgroundColor: const Color(0xFF71BC55),
                      icon: Icons.check_circle_rounded,
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainPage()),
                    );
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainPage()),
                  );
                }

                if (state is LoginFailure) {
                  AppSnackBar.show(
                    context: context,
                    message: state.message,
                    backgroundColor: const Color(0xFFEA2020),
                    icon: Icons.error_rounded,
                  );
                }

                if (state is BiometricNotAvailable) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Color(0xFFEA2020),
                      margin: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      content: Row(
                        children: [
                          Icon(Icons.error_rounded, color: Colors.white),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Biometric not available",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        ],
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 52.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 121.h),
                              Image.asset(
                                "assets/images/logo.png",
                                height: 130.h,
                                width: 130.w,
                              ),
                              SizedBox(height: 25.h),
                              Text(
                                "login".tr(),
                                style: TextStyle(
                                  fontSize: 35.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.labelTextColor,
                                ),
                              ),
                              SizedBox(height: 40.h),
                              CustomTextField(
                                hintText: "email_required".tr(),
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                    Helpers.validateEmail(value),
                              ),
                              SizedBox(height: 23.h),
                              CustomTextField(
                                hintText: "password_required".tr(),
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "password_required".tr();
                                  }

                                  if (value.trim().length < 6) {
                                    return "password_min_length".tr();
                                  }

                                  final uppercaseRegex = RegExp(r'[A-Z]');
                                  if (!uppercaseRegex.hasMatch(value)) {
                                    return "password_uppercase".tr();
                                  }

                                  final specialCharRegex = RegExp(
                                    r'[!@#$%^&*(),.?":{}|<>]',
                                  );
                                  if (!specialCharRegex.hasMatch(value)) {
                                    return "password_special_char".tr();
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),
                              Align(
                                alignment: isArabic
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "forgot_password".tr(),
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 55.h,
                                      child: ElevatedButton(
                                        onPressed: () => _login(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.buttonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18.r,
                                            ),
                                          ),
                                          elevation: 3,
                                        ),
                                        child: isLoading
                                            ? SizedBox(
                                                height: 22.h,
                                                width: 22.w,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : Text(
                                                "login_button".tr(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontFamily: 'Nunito',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  FutureBuilder<bool>(
                                    future: BiometricService()
                                        .checkBiometricAvailability(),
                                    builder: (context, snapshot) {
                                      final available = snapshot.data ?? false;
                                      if (!available)
                                        return const SizedBox.shrink();
                                      IconData icon = Platform.isIOS
                                          ? Icons.face
                                          : Icons.fingerprint;

                                      return SizedBox(
                                        width: 55.w,
                                        height: 55.h,
                                        child: IconButton(
                                          icon: Icon(
                                            icon,
                                            size: 26.sp,
                                            color: AppColors.enabledBorderColor,
                                          ),
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                                  context.read<LoginBloc>().add(
                                                    BiometricLoginEvent(),
                                                  );
                                                },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 40.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "new_to_cropmeal".tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color(0xff62707D),
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPresenter(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "register",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Nunito',
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
