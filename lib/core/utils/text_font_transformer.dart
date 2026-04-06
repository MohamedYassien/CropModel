import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle getDynamicStyle(BuildContext context,
    {double size = 16, Color? color, FontWeight? weight}) {
  final isArabic = context.locale.languageCode == 'ar';
  return TextStyle(
    fontFamily: isArabic ? 'Cairo' : 'Nunito',
    fontSize: size.sp,
    color: color ?? Colors.black,
    fontWeight: weight ?? FontWeight.normal,
  );
}