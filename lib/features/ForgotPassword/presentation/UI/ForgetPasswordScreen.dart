import 'package:cropmodel/features/ForgotPassword/presentation/UI/OTPVerificationScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/forgotPass_bloc.dart';
import '../bloc/forgotPass_event.dart';
import '../bloc/forgotPass_state.dart';

class Forgetpasswordscreen extends StatefulWidget {
  const Forgetpasswordscreen({super.key});

  @override
  State<Forgetpasswordscreen> createState() => _ForgetpasswordscreenState();
}

class _ForgetpasswordscreenState extends State<Forgetpasswordscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<ForgotPassBloc, ForgotPassState>(
          listener: (context, state) {
            if (state is OtpSentState) {
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
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
                    style: TextStyle(fontSize: 25.sp, fontFamily: 'Nunito'),
                  ),
                    
                  SizedBox(height: 10.h),
                    
                  Text(
                    "forget_password_subtitle_line1".tr(),
                    style: TextStyle(fontSize: 14.sp, fontFamily: 'Nunito'),
                  ),
                  Text(
                    "forget_password_subtitle_line2".tr(),
                    style: TextStyle(fontSize: 14.sp, fontFamily: 'Nunito'),
                  ),
                    
                  SizedBox(height: 20.h),
                    
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "email_address".tr(),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                      filled: true,
                      fillColor: Colors.grey,
                    ),
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
        )
    );
  }
}
