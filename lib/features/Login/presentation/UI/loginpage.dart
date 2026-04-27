import 'dart:io';
import 'package:cropmodel/bottom_navigation_bar.dart';
import 'package:cropmodel/core/shared/app_message.dart';
import 'package:cropmodel/core/utils/helpers.dart';
import 'package:cropmodel/features/Login/domain/usecases/GetCredentials.dart';
import 'package:cropmodel/features/Login/domain/usecases/LoginWithEmail.dart';
import 'package:cropmodel/features/Login/domain/usecases/SaveCredentials.dart';
import 'package:flutter/material.dart' hide BottomNavigationBar;
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
import '../../../../../core/constants/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _showPasswordIcon = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _passwordFocusNode.addListener(() {
      setState(() {
        _showPasswordIcon = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(
        LoginWithEmailEvent(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => LoginBloc(
        loginWithEmail: LoginWithEmail(LoginService()),
        saveCredentials: Savecredentials(SecureStorage()),
        getCredentials: GetCredentials(SecureStorage()),
        biometricService: BiometricService(),
        secureStorage: SecureStorage(),
      ),
      child: Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              AppMessage.showSnackBar(
                context,
                "Login successful",
                const Color(0xFF71BC55),
                Icons.check_circle_rounded,
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => BottomNavigationBar()),
              );
            } else if (state is LoginFailure) {
              AppMessage.showSnackBar(
                context,
                state.message,
                const Color(0xFFEA2020),
                Icons.error_rounded,
              );
            } else if (state is BiometricNotAvailable) {
              AppMessage.showSnackBar(
                context,
                "Biometric not available",
                const Color(0xFFEA2020),
                Icons.error_rounded,
              );
            }
          },
          builder: (context, state) {
            final bool isLoading = state is LoginLoading;

            return SingleChildScrollView(
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
                            SizedBox(height: 120.h),
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

                            /// EMAIL FIELD (no icon)
                            CustomTextField(
                              hintText: "email_address".tr(),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              enabled: !isLoading,
                              validator: (value) => Helpers.validateEmail(value),
                            ),

                            SizedBox(height: 16.h),


                            CustomTextField(
                              hintText: "password_required".tr(),
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              focusNode: _passwordFocusNode,
                              enabled: !isLoading,
                              suffixIcon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: _showPasswordIcon
                                    ? IconButton(
                                  key: const ValueKey('visible'),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 24.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                  onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword,
                                  ),
                                )
                                    : const SizedBox(
                                  key: ValueKey('hidden'),
                                ),
                              ),
                            ),

                            SizedBox(height: 12.h),

                            Align(
                              alignment: isArabic
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                      const Forgetpasswordscreen()),
                                ),
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

                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () => _login(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.buttonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.r),
                                        ),
                                      ),
                                      child: isLoading
                                          ? SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child:
                                        const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                          : Text(
                                        "login_button".tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FutureBuilder<bool>(
                                    future: BiometricService()
                                        .checkBiometricAvailability(),
                                    builder: (context, snapshot) {
                                      if (!(snapshot.data ?? false)) {
                                        return const SizedBox.shrink();
                                      }

                                      return Row(
                                        children: [
                                          SizedBox(width: 12.w),
                                          InkWell(
                                            onTap: isLoading
                                                ? null
                                                : () => context
                                                .read<LoginBloc>()
                                                .add(
                                                BiometricLoginEvent()),
                                            child: Container(
                                              width: 56.w,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(14.r),
                                                border: Border.all(
                                                    color:
                                                    const Color(0xFFF1F1F1)),
                                              ),
                                              child: Icon(
                                                Platform.isIOS
                                                    ? Icons
                                                    .face_retouching_natural
                                                    : Icons.fingerprint,
                                                size: 28.sp,
                                                color:
                                                const Color(0xFF444444),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.only(bottom: 30.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "new_to_cropmeal".tr(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xff62707D),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                      const SignUpPresenter()),
                                ),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
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
            );
          },
        ),
      ),
    );
  }
}