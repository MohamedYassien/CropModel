import 'dart:io';
import 'package:cropmodel/core/shared/app_message.dart';
import 'package:cropmodel/core/utils/helpers.dart';
import 'package:cropmodel/features/Login/domain/usecases/GetCredentials.dart';
import 'package:cropmodel/features/Login/domain/usecases/LoginWithEmail.dart';
import 'package:cropmodel/features/Login/domain/usecases/SaveCredentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/shared/custom_text_field.dart';
import '../../../ForgotPassword/presentation/UI/ForgetPasswordScreen.dart';
import '../../../sign_up/presentation/UI/sign_up_presenter.dart';
import '../../data/service/LoginService.dart';
import '../../data/service/SecureStorage.dart';
import '../bloc/LoginBloc.dart';
import '../bloc/LoginEvent.dart';
import '../bloc/LoginState.dart';
import '../../data/service/BiometricService.dart';
import 'LoginDetails.dart';
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
        loginWithEmail: LoginWithEmail(LoginService()),
        saveCredentials:Savecredentials(SecureStorage()),
        getCredentials: GetCredentials(SecureStorage()),
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
                    AppMessage.showSnackBar(
                      context,
                      "Login successful",
                       const Color(0xFF71BC55),
                      Icons.check_circle_rounded,
                    );
                    Future.delayed(const Duration(seconds: 3), () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    });

                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => const LoginDetails()),
                    // );
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginDetails()),
                  );
                }

                if (state is LoginFailure) {
                  AppMessage.showSnackBar(
                    context,
                    state.message,
                  const Color(0xFFEA2020),
                  Icons.error_rounded,
                  );
                }

                if (state is BiometricNotAvailable) {
                  AppMessage.showSnackBar(
                    context,
                    "Biometric not available",
                    const Color(0xFFEA2020),
                    Icons.error_rounded,
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
                                hintText: "email_address".tr(),
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Forgetpasswordscreen(),
                                      ),
                                    );
                                  },
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
                                    future: BiometricService().checkBiometricAvailability(),
                                    builder: (context, snapshot) {
                                      final available = snapshot.data ?? false;
                                      if (!available) return const SizedBox.shrink();

                                      IconData icon = Platform.isIOS
                                          ? Icons.face_retouching_natural
                                          : Icons.fingerprint;

                                      return GestureDetector(
                                        onTap: isLoading
                                            ? null
                                            : () {
                                          context.read<LoginBloc>().add(
                                            BiometricLoginEvent(),
                                          );
                                        },
                                        child: Container(
                                          width: 55.w,
                                          height: 55.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(14.r),
                                            border: Border.all(
                                              color: const Color(0xFFF1F1F1),
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.08),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              icon,
                                              size: 26.sp,
                                              color: const Color(0xFF444444),
                                            ),
                                          ),
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
