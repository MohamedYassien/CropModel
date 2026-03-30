import 'dart:async';
import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/core/shared/custom_button.dart';
import 'package:cropmodel/core/utils/helpers.dart';
import 'package:cropmodel/features/sign_up/presentation/UI/widgets/otp_field.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/otp/otp_bloc.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/otp/otp_event.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/otp/otp_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPPresenter extends StatefulWidget {
  final String email;

  const OTPPresenter({super.key, required this.email});

  @override
  State<OTPPresenter> createState() => _OTPPresenterState();
}

class _OTPPresenterState extends State<OTPPresenter> {
  late final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsRemaining = 0;

  int _attemptsLeft = 5;

  bool _hasResent = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 20;
    });

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String get timerText {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OTPBloc(),
      child: BlocListener<OTPBloc, OTPState>(
        listener: (context, state) {
          if (state is OTPResendSuccess) {
            setState(() {
              _hasResent = true;
              if (_attemptsLeft > 0) _attemptsLeft--;
            });
            _startTimer();
          }
        },
        child: BlocBuilder<OTPBloc, OTPState>(
          builder: (context, state) {
            return SafeArea(
              child: Scaffold(
                body: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                              ),
                              color: const Color(0xff1C1B1F),
                            ),
                          ],
                        ),
                        Image.asset('assets/images/otp_lock.png'),
                        SizedBox(height: 20.h),
                        Text(
                          'otp_verification'.tr(),
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'please_otp_code_sent_to'.tr(
                            namedArgs: {'email': widget.email},
                          ),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.hintTextColor,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: OTPField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                index: index,
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 5) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                        if (state is OTPVerifyError) ...[
                          SizedBox(height: 10.h),
                          Text(
                            state.message,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10.sp,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                        if (state is OTPResendError) ...[
                          SizedBox(height: 10.h),
                          Text(
                            state.message,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10.sp,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                        SizedBox(height: 20.h),
                        if (_secondsRemaining > 0) ...[
                          Text(
                            timerText,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'if_you_did_not_receive_code'.tr(),
                              style: TextStyle(
                                color: AppColors.hintTextColor,
                                fontSize: 12.sp,
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  (_secondsRemaining == 0 &&
                                      _attemptsLeft > 0 &&
                                      state is! OTPResendLoading)
                                  ? () {
                                      context.read<OTPBloc>().add(
                                        OTPResendButtonPressed(
                                          email: widget.email,
                                        ),
                                      );
                                    }
                                  : null,
                              child: Text(
                                'resend_the_otp'.tr(),
                                style: TextStyle(
                                  color:
                                      (_secondsRemaining == 0 &&
                                          _attemptsLeft > 0 &&
                                          state is! OTPResendLoading)
                                      ? AppColors.primaryColor
                                      : AppColors.primaryColor.withOpacity(0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_hasResent && _attemptsLeft >= 0) ...[
                          SizedBox(height: 8.h),
                          Text(
                            "attempts_left".tr(namedArgs: {'attempts': Helpers.translateNumber(_attemptsLeft.toString(), context.locale.languageCode)}),
                            style: TextStyle(
                              color: AppColors.hintTextColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                        SizedBox(height: 30.h),
                        state is OTPVerifyLoading
                            ? CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              )
                            : CustomButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  String otp = _controllers
                                      .map((c) => c.text)
                                      .join();
                                  context.read<OTPBloc>().add(
                                    OTPButtonPressed(
                                      otp: otp,
                                      email: widget.email,
                                    ),
                                  );
                                },
                              ),
                        SizedBox(height: 200.h),
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
