import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../bottom_navigation_bar.dart';
import '../../features/Login/presentation/UI/loginpage.dart';
import '../../features/Login/presentation/UI/widgets/showLogoutDialog.dart';
import '../../features/Profile/data/service/profile_service.dart';
import '../../features/Profile/presentation/UI/profile_presenter.dart';
import '../../features/room/presentation/UI/my_rooms_presenter.dart';
import '../constants/app_colors.dart';
import '../shared/data.dart';
import '../utils/text_font_transformer.dart';

class EndDrawer extends StatelessWidget {
  final Function(int)? onNavigate;
  const EndDrawer({super.key, this.onNavigate});

  Future<void> _ensureUserLoaded() async {
    if (AppData.instance.currentUser != null) return;
    try {
      final user = await UserService().fetchProfile();
      if (user != null) {
        AppData.instance.currentUser = user;
      }
    } catch (_) {
      // Intentionally swallow errors in drawer.
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _ensureUserLoaded(),
      builder: (context, snapshot) {
        final user = AppData.instance.currentUser;
        final bool isLoading =
            snapshot.connectionState == ConnectionState.waiting && user == null;
        return Container(
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
                SizedBox(
                  height: 50.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ProfilePresenter()),
                    );
                  },
                  child: isLoading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 68.w,
                            height: 68.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 34.r,
                          backgroundColor: const Color(0xffEEEEEE),
                          backgroundImage: (user?.profilePicture != null)
                              ? MemoryImage(user!.profilePicture!)
                              : null,
                          child: (user?.profilePicture == null)
                              ? Icon(
                                  Icons.person,
                                  size: 40.sp,
                                  color: const Color(0xff8E8E8E),
                                )
                              : null,
                        ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                if (isLoading)
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 120.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Text(
                    (user?.fullName?.isNotEmpty ?? false)
                        ? user!.fullName!
                        : ' ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                  ),
                SizedBox(
                  height: 15.h,
                ),
                if (isLoading)
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 140.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Text(
                    (user?.email?.isNotEmpty ?? false) ? user!.email! : ' ',
                    style: TextStyle(fontSize: 14.sp, color: Color(0xff8E8E8E)),
                  ),
                SizedBox(
                  height: 20.h,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.3),
                  indent: 10.w,
                  endIndent: 10.w,
                ),
                SizedBox(
                  height: 15.h,
                ),
                InkWell(
                  onTap: () {
                    onNavigate == null
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavigationBar()))
                        : onNavigate?.call(0);
                  },
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                        Text('dashboard'.tr(),
                            style: getDynamicStyle(context, size: 14.sp)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                  onTap: () {
                    onNavigate == null
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavigationBar()))
                        : onNavigate?.call(1);
                  },
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.list_alt_sharp,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                        Text(
                          'restaurants_list'.tr(),
                          style: getDynamicStyle(context, size: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyRoomsPresenter()));
                  },
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.group,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                        Text(
                          'orders_groups'.tr(),
                          style: getDynamicStyle(context, size: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey.withOpacity(0.3),
                  indent: 10.w,
                  endIndent: 10.w,
                ),
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                  onTap: () {
                    showLogoutDialog(context, () {
                      AppData.instance.clearSession();
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
                        Icon(
                          Icons.power_settings_new,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                        Text(
                          'logout'.tr(),
                          style: getDynamicStyle(context, size: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
