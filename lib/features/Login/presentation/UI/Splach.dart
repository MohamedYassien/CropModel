import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/features/Login/presentation/UI/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Splach extends StatefulWidget {
  const Splach({super.key});

  @override
  State<Splach> createState() => _SplachState();
}

class _SplachState extends State<Splach> {

  @override
  void initState() {
    super.initState();
   Future.delayed(Duration(seconds: 3),(){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
   });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Image.asset("assets/images/logo.png"),

           SizedBox(height: 20.h),
          Text("CropMeal",
            style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.labelTextColor),),
           SizedBox(height: 20.h),
          CircularProgressIndicator(
            strokeWidth: 5.w,
            color: AppColors.primaryColor,
          ),
        ]
      ),
      ),
    );
  }
}
