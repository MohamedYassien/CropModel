import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/text_font_transformer.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final bool enabled;
  final TextStyle? textStyle;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.focusNode,
    this.suffixIcon,
    this.enabled = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        validator: validator,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        style: textStyle ?? getDynamicStyle(context),

        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,

          errorStyle: TextStyle(
            height: 1.2, // control spacing
          ),

          helperText: ' ',

          hintStyle: TextStyle(
            color: AppColors.hintTextColor,
            fontWeight: FontWeight.w400,
          ),

          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5.w),
          ),

          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.2),
              width: 2.w,
            ),
          ),

          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5.w),
          ),

          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),

          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),

          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }
}
