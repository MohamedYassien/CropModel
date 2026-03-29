import 'dart:async';

import 'package:cropmodel/features/ForgotPassword/presentation/UI/PasswordChanged.dart';
import 'package:cropmodel/features/ForgotPassword/presentation/UI/ResetPassword.dart';
import 'package:cropmodel/features/ForgotPassword/presentation/UI/widgets/otpFields.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/forgotPass_bloc.dart';
import '../bloc/forgotPass_event.dart';
import '../bloc/forgotPass_state.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  int attemptsLeft = 4;
  Timer timer = Timer(const Duration(minutes: 6), () {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      BlocListener<ForgotPassBloc, ForgotPassState>(
          listener: (context, state) {
            if (state is OtpVerifiedState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Resetpassword(),
                ),
              );
            }

            if (state is ForgotPassError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
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
                Image.asset("assets/images/otp.png"),
                Text(
                  "otp_verification".tr(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "otp_subtitle".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Nunito',
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 28.h),

                 OtpFields(
                  length: 6,
                  onCompleted: (otp) {
                    context.read<ForgotPassBloc>().add(
                      VerifyOtpEvent(widget.email, otp),
                    );
                  },
                ),

                SizedBox(height: 20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "didnt_receive_code".tr(),
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),
                    SizedBox(width: 6.w),
                    GestureDetector(
                      onTap: () {
                        context.read<ForgotPassBloc>().add(
                          SendOtpEvent(widget.email),
                        );
                      },
                      child: Text(
                        "resend_otp".tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  "$attemptsLeft ${"attempts_left".tr()}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: attemptsLeft == 0 ? Colors.red : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10.h),

                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    // onPressed: attemptsLeft == 0
                    //     ? null // disables button automatically
                    //     : () {
                    //   setState(() {
                    //     if (attemptsLeft > 0) {
                    //       attemptsLeft--;
                    //     }
                    //   });
                    //
                    // },
                    onPressed: () {
                      final otp = OtpFields.of(context)?.getOtp() ?? "";

                      context.read<ForgotPassBloc>().add(
                        VerifyOtpEvent(widget.email, otp),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "continue".tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }
}
