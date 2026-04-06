import 'package:cropmodel/core/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/shared/custom_text_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/Change_password_bloc.dart';
import '../bloc/Change_password_event.dart';
import '../bloc/Change_password_state.dart';
import 'Change_Password_Success.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();


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
      body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
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
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                    ),

                    Image.asset(
                      'assets/images/reset_password.png',
                      height: 200.h,
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'Change Your Password'.tr(),
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
                      hintText: "Enter current password".tr(),
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
                    SizedBox(height: 30.h),
                    CustomTextField(
                      hintText: "New password".tr(),
                      controller: _newpasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "password_required".tr();
                        if (value.length < 8) return "password_min_length".tr();
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),
                    CustomTextField(
                      hintText: "Confirm your password".tr(),
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password Required".tr();
                        }
                        if (value != _newpasswordController.text) {
                          return "Passwords Do Not Match".tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50.h),
                    CustomButton(
                      buttonTextKey: "continue".tr(),
                      onPressed: state is ResetPasswordLoading
                          ? null
                          : () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ChangePasswordBloc>().add(
                            ConfirmResetPasswordEvent(newPassword: _passwordController.text),
                          );
                        }
                      },
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
