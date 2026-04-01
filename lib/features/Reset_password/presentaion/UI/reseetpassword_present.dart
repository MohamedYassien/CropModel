import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/shared/custom_text_field.dart';
import '../../../../core/constants/app_colors.dart';

import '../bloc/reset_password_bloc.dart';
import '../bloc/reset_password_event.dart';
import '../bloc/reset_password_state.dart';
import 'confirm_reset_password.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ConfirmResetPasswordScreen()),
            );
          } else if (state is ResetPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 60.h),
                    Image.asset(
                      'assets/images/reset_password.png',
                      height: 150.h,
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'Reset Your Password'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.labelTextColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Nunito",
                      ),
                    ),
                    SizedBox(height: 60.h),

                    CustomTextField(
                      hintText: "Enter your password".tr(),
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Password Required".tr();
                        if (value.trim().length < 6) return "Password Min Length".tr();

                        final uppercaseRegex = RegExp(r'[A-Z]');
                        if (!uppercaseRegex.hasMatch(value)) return "Password Uppercase".tr();

                        final specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
                        if (!specialCharRegex.hasMatch(value)) return "Password Special Char".tr();

                        return null;
                      },
                    ),
                    SizedBox(height: 45.h),

                    CustomTextField(
                      hintText: "Confirm your password".tr(),
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password Required".tr();
                        }
                        if (value != _passwordController.text) {
                          return "Passwords Do Not Match".tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: ElevatedButton(
                        onPressed: state is ResetPasswordLoading
                            ? null
                            : () {
                          if (_passwordController.text != _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Passwords do not match!")),
                            );
                            return;
                          }
                          context.read<ResetPasswordBloc>().add(
                            ConfirmResetPasswordEvent(newPassword: _passwordController.text),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        child: state is ResetPasswordLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                            : Text(
                          'Confirm',
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontFamily: "Nunito"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}