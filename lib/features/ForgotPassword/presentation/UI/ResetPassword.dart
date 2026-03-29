import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/forgotPass_bloc.dart';
import '../bloc/forgotPass_state.dart';
import 'PasswordChanged.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Minimum length is 8 characters";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Must include an uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Must include a lowercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Must include a number";
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Must include a special character";
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }

    if (confirmController.text != passwordController.text) {
      return "Passwords do not match";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ForgotPassBloc, ForgotPassState>(
        listener: (context, state) {
          if (state is ForgotPassPasswordReset) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Passwordchanged()),
            );
          }

          if (state is ForgotPassError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
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
                    Image.asset("assets/images/reset_pass.png"),

                    Text(
                      "reset_password_title".tr(),
                      style: TextStyle(fontSize: 25.sp, fontFamily: 'Nunito'),
                    ),

                    SizedBox(height: 20.h),

                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "enter_pass".tr(),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: Colors.grey,
                      ),

                      validator: validatePassword,
                    ),
                    SizedBox(height: 20.h),
                    TextFormField(
                      controller: confirmController,
                      decoration: InputDecoration(
                        hintText: "enter_confirm_pass".tr(),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: Colors.grey,
                      ),
                      validator: validateConfirmPassword,
                    ),

                    SizedBox(height: 20.h),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Passwordchanged(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "confirm".tr(),
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
  }
}
