import 'package:cropmodel/core/shared/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Service & Bloc Imports
import '../../../../core/shared/app_message.dart';
import '../../../../core/shared/custom_text_field.dart';
import '../../data/service/forgotpass_services.dart';
import '../bloc/forgotPass_bloc.dart';
import '../bloc/forgotPass_event.dart';
import '../bloc/forgotPass_state.dart';

// UseCase Imports
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

// UI & Constants
import 'OTPVerificationScreen.dart';
import '../../../../../core/constants/app_colors.dart';

class Forgetpasswordscreen extends StatefulWidget {
  const Forgetpasswordscreen({super.key});

  @override
  State<Forgetpasswordscreen> createState() => _ForgetpasswordscreenState();
}

class _ForgetpasswordscreenState extends State<Forgetpasswordscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
          return Scaffold(
            body: BlocListener<ForgotPassBloc, ForgotPassState>(
              listener: (context, state) {
                if (!mounted) return;

                if (state is OtpSentState) {

                AppMessage.showSnackBar(
                  context,
                  "otp_sent_success".tr(),
                  const Color(0xFF71BC55),
                  Icons.check_circle_outline,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OTPVerificationScreen(
                          email: emailController.text.trim(),
                        ),
                  ),
                );

                }
                 if (state is ForgotPassError) {
                   AppMessage.showSnackBar(
                     context,
                     state.message,
                     const Color(0xFFEA2020),
                     Icons.error_outline,
                   );
                }
              },
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios),
                            ),
                          ),
                          Image.asset("assets/images/forgot_pass.png"),
                          Text(
                            "forget_password_title".tr(),
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "forget_password_subtitle_line1".tr(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          Text(
                            "forget_password_subtitle_line2".tr(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Email is required";
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                            hintText: 'Enter Your Email',
                          ),
                          SizedBox(height: 20.h),
                          CustomButton(
                            buttonTextKey: "continue".tr(),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ForgotPassBloc>().add(
                                  SendOtpEvent(emailController.text.trim()),
                                );
                              }
                            },
                            isLoading: state is ForgotPassLoading,
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
