import 'dart:ui';
import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({super.key});

  @override
  State<BottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<BottomNavigationBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      extendBody: true,
      body: Stack(
        children: [
          Center(child: pages[currentIndex]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.h, left: 15.w, right: 15.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(174.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(174.r),
                      color: Colors.transparent,
                    ),

                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.1),
                              ],
                              stops: const [0.0, 0.25, 0.75, 1.0],
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNavItem('Home', Icons.home_outlined, 0),
                            _buildNavItem('Restaurants', Icons.restaurant, 1),
                            _buildNavItem('Profile', Icons.person_2_outlined, 2),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                      Text('Dashboard', style: TextStyle(fontSize: 14.sp,),),
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
                      Icon(Icons.list_alt_sharp, color: AppColors.primaryColor, size: 30.sp,),
                      Text('Restaurants List', style: TextStyle(fontSize: 14.sp,),),
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
                      Text('Latest Orders', style: TextStyle(fontSize: 14.sp,),),
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
                      Text('Orders Groups', style: TextStyle(fontSize: 14.sp,),),
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
                      Text('Settings', style: TextStyle(fontSize: 14.sp,),),
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
                onTap: (){},
                child: SizedBox(
                  height: 40.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.power_settings_new, color: AppColors.primaryColor, size: 30.sp,),
                      Text('Logout', style: TextStyle(fontSize: 14.sp,),),
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

  Widget _buildNavItem(String text, IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Center(
        child: Container(
          height: 65.h,
          width: currentIndex == 1 ? 110.w : 80.w,
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xff000000).withOpacity(0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(174.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26.sp,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withOpacity(0.7),
              ),
              SizedBox(height: 6.h),
              Text(
                text,
                style: TextStyle(
                  fontSize: isSelected ? 13.sp : 12.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get pages => [
    Center(child: Text('Home')),
    Center(child: Text('Restaurants')),

    Center(child: Text('Profile')),
  ];
}
