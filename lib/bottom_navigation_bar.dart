import 'dart:ui';
import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/core/utils/text_font_transformer.dart';
import 'package:cropmodel/features/Profile/presentation/UI/profile_presenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/HomePage/presentation/ui/homepage_screen.dart';
import 'features/Restaurant/presentation/UI/restaurant_screen.dart';

class BottomNavigationBar extends StatefulWidget {
  int index;
  BottomNavigationBar({super.key, this.index = 0});

  @override
  State<BottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<BottomNavigationBar> {

  late int currentIndex = widget.index;

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }


  List<Widget> get pages => [
    homepage(onNavigate: changePage,),
    RestaurantListScreen(onNavigate: changePage,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Center(child: pages[currentIndex]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.h, left: 15.w, right: 15.w),
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
                            _buildNavItem('home'.tr(), Icons.home_outlined, 0),
                            _buildNavItem('restaurants'.tr(), Icons.restaurant, 1),
                            _buildNavItem('profile'.tr(), Icons.person_2_outlined, 2),
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
    );
  }

  Widget _buildNavItem(String text, IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if(index == 2){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePresenter()));
        }
        else {
          setState(() {
            currentIndex = index;
          });
        }
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
                style: getDynamicStyle(context,size: isSelected ? 13.sp : 12.sp, weight: FontWeight.bold, color: AppColors.primaryColor )
              ),
            ],
          ),
        ),
      ),
    );
  }

}
