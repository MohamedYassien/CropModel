
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/text_font_transformer.dart';
import '../../../Login/presentation/UI/loginpage.dart';
import '../../../Login/presentation/UI/widgets/showLogoutDialog.dart';

class RestaurantListScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  const RestaurantListScreen({super.key, required this.onNavigate});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading:  IconButton(
          onPressed: () {widget.onNavigate?.call(0);},
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Restaurants', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Builder(
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(right: 5.w),
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return const RestaurantCard();
        },
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

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            'https://upload.wikimedia.org/wikipedia/en/thumb/b/bf/KFC_logo.svg/1200px-KFC_logo.svg.png',
            height: 120,
            width: 120,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(width: 120, height: 120, color: Colors.grey[200]),
          ),
        ),
        const SizedBox(width: 16),
        // Info Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "KFC",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: const [
                      Text("4.8", style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "Crispy fried chicken & combos",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.location_on_outlined, color: Colors.red, size: 16),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "MAADI, CAIRO (1.2 miles)",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}