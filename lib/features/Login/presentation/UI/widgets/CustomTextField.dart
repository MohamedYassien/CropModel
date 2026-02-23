import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final bool enabled;
  final String hintText;
  final String labelText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: AppColors.cursorColor,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,

        labelStyle: TextStyle(
          color: AppColors.labelTextColor,
          fontSize: 16.sp,
        ),

        floatingLabelStyle: TextStyle(
          color: AppColors.labelTextColor,
          fontSize: 18.sp,
        ),

        hintStyle: TextStyle(
          color: AppColors.hintTextColor,
          fontSize: 13.sp,
        ),

        errorStyle: TextStyle(
          color: AppColors.errorColor,
          fontSize: 11.sp,
        ),

        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 10.w,
        ),

        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.enabledBorderColor,
            width: 1.5,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.focusBorderColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}