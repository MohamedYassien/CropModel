import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared/app_message.dart';
import '../../../../core/shared/custom_button.dart';
import '../../../../core/shared/custom_text_field.dart';
import '../bloc/forgotPass_bloc.dart';
import '../bloc/forgotPass_event.dart';
import '../bloc/forgotPass_state.dart';
import '../../data/service/forgotpass_services.dart';

import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

import 'PasswordChanged.dart';
import '../../../../../core/constants/app_colors.dart';

class Resetpassword extends StatefulWidget {
  final String email;
  final String otp;

  const Resetpassword({super.key, required this.email, required this.otp});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return ForgotPassBloc();
      },
      child: Builder(
        builder: (context) {
          final state = context.watch<ForgotPassBloc>().state;
          final bool isLoading = state is ForgotPassLoading;

          return Scaffold(
            body: BlocListener<ForgotPassBloc, ForgotPassState>(
              listener: (context, state) {
                if (state is PasswordResetState) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Passwordchanged()),
                  );
                }

                if (state is ForgotPassError) {
                  String displayMessage;

                  if (state.message.contains('not found') ||
                      state.message.contains('404')) {
                    displayMessage = "no_account_found".tr();
                  } else if (state.message.contains('network') ||
                      state.message.contains('SocketException')) {
                    displayMessage = "check_connection".tr();
                  } else if (state.message.contains('too many') ||
                      state.message.contains('429')) {
                    displayMessage = "too_many_requests".tr();
                  } else {
                    displayMessage = "something_went_wrong".tr();
                  }

                  AppMessage.showSnackBar(
                    context,
                    displayMessage,
                    const Color(0xFFEA2020),
                    Icons.error_outline,
                  );
                }
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios),
                            ),
                          ),
                          Image.asset(
                            "assets/images/reset_pass.png",
                            height: 200.h,
                            width: 200.w,
                          ),
                          Text(
                            "reset_password_title".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.labelTextColor,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          SizedBox(height: 40.h),

                          CustomTextField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "password_required".tr();
                              }

                              if (value.length < 8) {
                                return "password_min_length".tr();
                              }

                              final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
                              if (!hasUpper) {
                                return "password_uppercase_required".tr();
                              }

                              final hasLower = RegExp(r'[a-z]').hasMatch(value);
                              if (!hasLower) {
                                return "password_lowercase_required".tr();
                              }

                              final hasNumber = RegExp(r'[0-9]').hasMatch(value);
                              if (!hasNumber) {
                                return "password_number_required".tr();
                              }

                              final hasSpecial = RegExp(
                                r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]]',
                              ).hasMatch(value);

                              if (!hasSpecial) {
                                return "password_special_char_required".tr();
                              }

                              return null;
                            },
                            hintText: 'Password',
                          ),

                          SizedBox(height: 20.h),

                          CustomTextField(
                            controller: confirmController,
                            hintText: 'Confirm Password',
                            validator: (value) {
                              if (value != passwordController.text)
                                return "passwords_do_not_match".tr();
                              return null;
                            },
                          ),

                          SizedBox(height: 40.h),
                          CustomButton(
                            buttonTextKey: "confirm".tr(),
                            onPressed: () {
                              context.read<ForgotPassBloc>().add(
                                ResetPasswordEvent(
                                  widget.email,
                                  widget.otp,
                                  passwordController.text.trim(),
                                ),
                              );
                            },
                            isLoading: state is PasswordResetLoading,
                          ),
                          SizedBox(height: 20.h),
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
