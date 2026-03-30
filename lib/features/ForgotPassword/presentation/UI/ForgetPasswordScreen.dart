import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Service & Bloc Imports
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

  // Enhanced SnackBar with Icons and better styling
  void _showSnackBar(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final service = ForgotpassServices();
        return ForgotPassBloc(
          sendOtpUseCase: SendOtpUseCase(service),
          verifyOtpUseCase: VerifyOtpUseCase(service),
          resetPasswordUseCase: ResetPasswordUseCase(service),
        );
      },
      child: Builder(
        builder: (context) {
          final state = context.watch<ForgotPassBloc>().state;
          final bool isLoading = state is ForgotPassLoading;

          return Scaffold(
            body: BlocListener<ForgotPassBloc, ForgotPassState>(
              listener: (context, state) {
                if (!mounted) return;

                if (state is OtpSentState) {
                  _showSnackBar(
                    context,
                    "otp_sent_success".tr(),
                    const Color(0xFF71BC55),
                    Icons.check_circle_outline,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OTPVerificationScreen(
                        email: emailController.text.trim(),
                      ),
                    ),
                  );
                }
                if (state is ForgotPassError) {
                  String displayMessage;

                  // Enhance the message based on the error content
                  if (state.message.contains('not found') ||
                      state.message.contains('404')) {
                    displayMessage = "no_account_found"
                        .tr(); // "We couldn't find an account with that email."
                  } else if (state.message.contains('network') ||
                      state.message.contains('SocketException')) {
                    displayMessage = "check_connection"
                        .tr(); // "Please check your internet connection."
                  } else if (state.message.contains('too many') ||
                      state.message.contains('429')) {
                    displayMessage = "too_many_requests"
                        .tr(); // "Too many attempts. Please try again later."
                  } else {
                    displayMessage = "something_went_wrong"
                        .tr(); // Fallback friendly message
                  }

                  _showSnackBar(
                    context,
                    displayMessage,
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
                              onPressed: () => Navigator.pop(context),
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
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ForgotPassBloc>().add(
                                  SendOtpEvent(emailController.text.trim()),
                                );
                              }
                            },
                            child: Text(
                              "continue".tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              minimumSize: Size(double.infinity, 48.h),
                            ),
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
