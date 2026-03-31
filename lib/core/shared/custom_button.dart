import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {

  final void Function()? onPressed;
  final bool? canVerify;
  final bool? state;

  const CustomButton({super.key, this.onPressed , this.canVerify = true, this.state = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 284.w,
      height: 52.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: canVerify! && !state! ? AppColors.primaryColor : Colors.grey.shade400,
      ),
      child: MaterialButton(
        onPressed: canVerify! ? onPressed : null,
        child: state!
            ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)
            : Text(
          'continue'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        )
      ),
    );
  }
}