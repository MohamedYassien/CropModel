import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Passwordchanged extends StatefulWidget {
  const Passwordchanged({super.key});

  @override
  State<Passwordchanged> createState() => _PasswordchangedState();
}

class _PasswordchangedState extends State<Passwordchanged> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "password_changed".tr(),
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                ),
                ),
                Image.asset("assets/images/success.png"),
                SizedBox(height: 70.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed:() {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      )
                    ),
                    child: Text(
                      "confirm".tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
