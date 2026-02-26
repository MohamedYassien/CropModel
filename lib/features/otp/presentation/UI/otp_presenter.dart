import 'package:cropmodel/features/example/presentation/UI/example_presenter.dart';
import 'package:cropmodel/features/otp/data/service/otp_service.dart';
import 'package:cropmodel/features/otp/domain/usecases/verify_otp_usecase.dart';
import 'package:cropmodel/features/otp/presentation/bloc/otp_bloc.dart';
import 'package:cropmodel/features/otp/presentation/bloc/otp_event.dart';
import 'package:cropmodel/features/otp/presentation/bloc/otp_state.dart';
import 'package:cropmodel/features/sign_up/presentation/UI/sign_up_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpPresenter extends StatefulWidget {
  String? email;
  OtpPresenter({super.key, this.email});

  @override
  State<OtpPresenter> createState() => _OtpPresenterState();
}

class _OtpPresenterState extends State<OtpPresenter> {
  bool isContinueEnabled = false;

  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  int secondsRemaining = 0;
  Timer? timer;

  void startTimer() {
    setState(() {
      isContinueEnabled = false;
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          isContinueEnabled = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();

    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpBloc(VerifyOtpUseCase(OtpService())),
      child: BlocListener<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state is OtpLoading) {
            print("Loading...");
          } else if (state is OtpSuccess) {
            print("OTP Verified!");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SignUpPresenter()),
            );
          } else if (state is OtpFailure) {
            print("OTP Failed: ${state.message}");
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
                size: 30.sp,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 25),
                  child: Image.asset(
                    "assets/images/Copilot_20260207_202255.png",
                    width: 300.w,
                    height: 300.h,
                  ),
                ),
                Text(
                  "OTP Verification",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.sp,
                    fontFamily: "Nunito",
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Please OTP code sent to ${widget.email ?? "Johhhn***@gmail.com"}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                    fontFamily: "Nunito",
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 50.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      child: TextField(
                        controller: controllers[index],
                        enabled: secondsRemaining == 0,
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (index < 5) {
                              FocusScope.of(
                                context,
                              ).requestFocus(focusNodes[index + 1]);
                            } else {
                              focusNodes[index].unfocus();
                            }
                          }

                          if (value.isEmpty && index > 0) {
                            FocusScope.of(
                              context,
                            ).requestFocus(focusNodes[index - 1]);
                          }

                          bool allFilled = controllers.every(
                            (controller) => controller.text.isNotEmpty,
                          );

                          setState(() {
                            isContinueEnabled = allFilled;
                          });
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20.h),
                Text(
                  secondsRemaining > 0 ? " $secondsRemaining" : "",
                  style: TextStyle(
                    color: secondsRemaining > 0
                        ? Color(0xffCF2120)
                        : Colors.grey,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "if your didn't receive code",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontFamily: "Nunito",
                      ),
                    ),
                    TextButton(
                      onPressed: secondsRemaining == 0
                          ? () {
                              setState(() {
                                secondsRemaining = 10;
                              });
                              startTimer();
                            }
                          : null,
                      child: Text(
                        "Resend the OTP",
                        style: TextStyle(
                          color: secondsRemaining == 0
                              ? const Color(0xffCF2120)
                              : Colors.grey,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    String otp = controllers.map((c) => c.text).join();
                    print("OTP submitted: $otp");
                    context.read<OtpBloc>().add(SubmitOtpEvent(otp));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(270.w, 60.h),
                    backgroundColor: const Color(0xffCF2120),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
