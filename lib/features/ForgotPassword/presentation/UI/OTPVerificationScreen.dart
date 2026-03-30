import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/forgotPass_bloc.dart';
import '../bloc/forgotPass_event.dart';
import '../bloc/forgotPass_state.dart';
import '../../data/service/forgotpass_services.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'ResetPassword.dart';
import 'widgets/otpFields.dart';
import '../../../../../core/constants/app_colors.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String currentOtp = "";
  Timer? _timer;
  int _secondsRemaining = 10;
  bool _isTimerRunning = false;
  int otpFieldKey = 0;
  bool _isVerifying = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 10;
      _isTimerRunning = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining == 0) {
        setState(() {
          _isTimerRunning = false;
          timer.cancel();
        });
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _showSnackBar(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontFamily: 'Nunito', color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
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
          return Scaffold(
            body: BlocListener<ForgotPassBloc, ForgotPassState>(
              listener: (context, state) {
                if (state is OtpVerifiedState) {
                  _isVerifying = false;
                  _showSnackBar(context, "otp_verified_success".tr(), const Color(0xFF71BC55), Icons.check_circle);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => Resetpassword(email: widget.email)),
                  );
                }
                if (state is ForgotPassError) {
                  _isVerifying = false;
                  _showSnackBar(context, state.message, const Color(0xFFEA2020), Icons.error_outline);
                }
                if (state is OtpSentState) {
                  _showSnackBar(context, "otp_sent_success".tr(), const Color(0xFF71BC55), Icons.refresh);
                }
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      Image.asset("assets/images/otp.png", height: 200.h, width: 200.w),
                      SizedBox(height: 25.h),
                      Text(
                        "otp_verification".tr(),
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.labelTextColor,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "${"otp_subtitle".tr()} ${widget.email}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xff62707D),
                          fontFamily: 'Nunito',
                        ),
                      ),
                      SizedBox(height: 40.h),
                      IgnorePointer(
                        ignoring: _isTimerRunning,
                        child: OtpFields(
                          key: ValueKey(otpFieldKey),
                          length: 6,
                          onCompleted: (otp) => currentOtp = otp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      if (_isTimerRunning)
                        Text(
                          "00:${_secondsRemaining.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "didnt_receive_code".tr(),
                            style: TextStyle(fontSize: 13.sp, color: Colors.grey, fontFamily: 'Nunito'),
                          ),
                          TextButton(
                            onPressed: _isTimerRunning
                                ? null
                                : () {
                              setState(() {
                                currentOtp = "";
                                otpFieldKey++;
                              });
                              context.read<ForgotPassBloc>().add(SendOtpEvent(widget.email));
                              _startTimer();
                            },
                            child: Text(
                              "resend_otp".tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: _isTimerRunning ? Colors.grey : AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: (_isTimerRunning || _isVerifying)
                              ? null
                              : () {
                            if (currentOtp.length == 6) {
                              setState(() => _isVerifying = true);
                              context.read<ForgotPassBloc>().add(
                                VerifyOtpEvent(widget.email, currentOtp),
                              );
                            } else {
                              _showSnackBar(
                                context,
                                "please_enter_full_code".tr(),
                                Colors.orange,
                                Icons.warning_amber_rounded,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                          ),
                          child: _isVerifying
                              ? SizedBox(
                            height: 22.h,
                            width: 22.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            "continue".tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }
}