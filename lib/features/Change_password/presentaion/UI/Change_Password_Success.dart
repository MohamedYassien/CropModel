import 'package:cropmodel/core/shared/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../Profile/presentation/UI/profile_presenter.dart';

class ConfirmResetPasswordScreen extends StatelessWidget {
  const ConfirmResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your password has been changed",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.labelTextColor,
                ),
              ),
              SizedBox(height: 20.h),
              Image.asset(
                'assets/images/success.png',
                height: 300.h,
              ),
              SizedBox(height: 20.h),
             CustomButton(
               buttonTextKey: "continue".tr(),
               onPressed: () {
                 Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (context) => const ProfilePresenter()),
                 );
                 }
             )
            ],
          ),
        ),
      ),
    );
  }
}
