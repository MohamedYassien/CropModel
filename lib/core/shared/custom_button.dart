import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color? color;
  final Widget? child;
  final String? buttonText;
  final double? width;
  final double? height;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final BorderSide? border;
  final Color? disabledColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.child,
    this.color = AppColors.primaryColor,
    this.width = 284,
    this.height = 52,
    this.borderRadius = 15,
    this.elevation = 2,
    this.padding,
    this.border,
    this.disabledColor = Colors.grey,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return SizedBox(
      width: width?.w,
      height: height?.h,
      child: Material(
        color: isDisabled ? disabledColor : color,
        borderRadius: BorderRadius.circular(borderRadius),
        elevation: elevation,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isDisabled ? null : onPressed,
          child: Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: child ??
                  Text(
                    '$buttonText'.tr(),
                    style: TextStyle(
                      color: isDisabled ? Colors.black38 : Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}