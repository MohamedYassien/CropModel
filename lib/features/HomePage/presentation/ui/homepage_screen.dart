import 'package:cropmodel/features/Profile/presentation/UI/profile_presenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/homepage_block.dart';
import '../bloc/homepage_state.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePresenter()));
            },
            child: Image.asset(
              "assets/images/profilePlaceholder2.png",
              width: 48,
              height: 47,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Corp Meal",
          style: TextStyle(
            color: Color(0xffCF2120),
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,

          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu_rounded, size: 40.sp, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 30.h),
            child: Row(
              children: [
                Image.asset("assets/images/Waiter.png"),
                SizedBox(width: 10.w),
                Text(
                  "Create Order".tr(),
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Nunito",
                  ),
                ),
              ],
            ),
          ),
          //SizedBox(height: 13),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Container(
                width: double.infinity.w,
                height: 120.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [Color(0xffCF2120), Color(0xffFF1D1D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(25.w),
                      child: Image.asset(
                        "assets/images/Meal.png",
                        width: 72.w,
                        height: 72.h,
                      ),
                    ),
                    Text(
                      "Create_New_Order_Group".tr(),
                      style: TextStyle(
                        fontSize: 26.sp,
                        color: Colors.white,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w, top: 30.h),
                child: Image.asset("assets/images/Restaurant.png"),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: Text(
                  "Restaurants".tr(),
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Nunito",
                  ),
                ),
              ),
            ],
          ),
          //SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity.w,
              height: 92.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color.fromARGB(255, 228, 228, 228),
                ),
                color: Color(0xffFAFAFA),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: 49.w,
                      height: 51.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Color(0xffF0C8C8),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/images/Restaurant.png",
                          width: 41.w,
                          height: 43.h,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Column(
                      children: [
                        Text(
                          "Browse_Restaurants".tr(),
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Nunito",
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Padding(
                          padding: EdgeInsets.only(right: 10.h),
                          child: Text(
                            "find_your_favourite_meals".tr(),
                            style: TextStyle(
                              color: Color.fromARGB(255, 96, 96, 96),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w200,
                              fontFamily: "Nunito",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.h),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.h, top: 30.w),
                child: Image.asset("assets/images/Future.png"),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 30.w),
                child: Text(
                  "Latest_Orders".tr(),
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Nunito",
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity.w,
              height: 192.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color.fromARGB(255, 228, 228, 228),
                ),
                color: Color(0xffFAFAFA),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.w),
                    child: Image.asset(
                      "assets/images/No Food.png",
                      width: 90.w,
                      height: 90.h,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    "No previous  orders yet.\nStart Your frist order!",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Nunito",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
