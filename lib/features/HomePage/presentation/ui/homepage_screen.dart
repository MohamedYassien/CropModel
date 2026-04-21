import 'package:cropmodel/bottom_navigation_bar.dart';
import 'package:cropmodel/core/utils/text_font_transformer.dart';
import 'package:cropmodel/features/Login/presentation/UI/loginpage.dart';
import 'package:cropmodel/features/Profile/presentation/UI/profile_presenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../Login/presentation/UI/LoginDetails.dart';
import '../../../Login/presentation/UI/widgets/showLogoutDialog.dart';
import '../bloc/homepage_block.dart';
import '../bloc/homepage_state.dart';

class homepage extends StatefulWidget {
  final Function(int)? onNavigate;
  const homepage({super.key, this.onNavigate});

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
          padding: EdgeInsetsDirectional.only(start: 15.w),
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
          Builder(
            builder: (context) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 5.w),
                child: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(Icons.menu_rounded, size: 40.sp, color: Colors.black),
                ),
              );
            }
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20.w, top: 30.h),
            child: Row(
              children: [
                Image.asset("assets/images/Waiter.png"),
                SizedBox(width: 10.w),
                Text(
                  "Create_Order".tr(),
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
                padding: EdgeInsetsDirectional.only(start: 20.w, top: 30.h),
                child: Image.asset("assets/images/Restaurant.png"),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 30.h),
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
          GestureDetector(
    onTap: (){
    widget.onNavigate?.call(1);
    },
            child: Padding(
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
                            padding: EdgeInsetsDirectional.only(start: 10.h),
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
                      padding: EdgeInsetsDirectional.only(end: 10.h),
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
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 20.h, top: 30.w),
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
                    "No_previous_orders_yet_Start_Your_frist_order".tr(),
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
      endDrawer: Container(
        margin: EdgeInsets.only(top: 60.h, right: 2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: Colors.white.withOpacity(0.9),
        ),
        height: 800.h,
        width: 214.w,
        child: Drawer(
          child: Column(
            children: [
              SizedBox(height: 50.h,),
              Container(
                height: 68.h,
                width: 68.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffEEEEEE)
                ),
                child: Icon(Icons.person, size: 40.sp, color: Color(0xff8E8E8E),),
              ),
              SizedBox(height: 15.h),
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000),
                ),
              ),
              SizedBox(height: 15.h),
              Text('johnDoe@gmail.com', style: TextStyle(fontSize: 14.sp, color: Color(0xff8E8E8E)),),
              SizedBox(height: 20.h,),
              Divider(
                thickness: 1,
                color: Colors.grey.withOpacity(0.3),
                indent: 10.w,
                endIndent: 10.w,
              ),
              SizedBox(height: 15.h,),
              InkWell(
                onTap: (){},
                child: SizedBox(
                  height: 40.h,
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.home_outlined, color: AppColors.primaryColor, size: 30.sp,),
                      Text('dashboard'.tr(),
                        style: getDynamicStyle(context, size: 14.sp)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              InkWell(
                onTap: (){widget.onNavigate?.call(1);},
                child: SizedBox(
                  height: 40.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.list_alt_sharp, color: AppColors.primaryColor, size: 30.sp,),
                      Text('restaurants_list'.tr(), style: getDynamicStyle(context, size: 14.sp),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              InkWell(
                onTap: (){},
                child: SizedBox(
                  height: 40.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.history, color: AppColors.primaryColor, size: 30.sp,),
                      Text('latest_orders'.tr(), style: getDynamicStyle(context, size: 14.sp),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              InkWell(
                onTap: (){},
                child: SizedBox(
                  height: 40.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.group, color: AppColors.primaryColor, size: 30.sp,),
                      Text('orders_groups'.tr(), style: getDynamicStyle(context, size: 14.sp),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              InkWell(
                onTap: (){},
                child: SizedBox(
                  height: 40.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.settings, color: AppColors.primaryColor, size: 30.sp,),
                      Text('settings'.tr(), style: getDynamicStyle(context, size: 14.sp),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              Divider(
                thickness: 2,
                color: Colors.grey.withOpacity(0.3),
                indent: 10.w,
                endIndent: 10.w,
              ),
              SizedBox(height: 20.h,),
              InkWell(
                onTap: () {
                  showLogoutDialog(context, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  });
                },
                child: SizedBox(
                  height: 40.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.power_settings_new, color: AppColors.primaryColor, size: 30.sp,),
                      Text('logout'.tr(), style: getDynamicStyle(context, size: 14.sp),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
