import 'package:cropmodel/bottom_navigation_bar.dart';
import 'package:cropmodel/core/shared/end_drawer.dart';
import 'package:cropmodel/core/utils/text_font_transformer.dart';
import 'package:cropmodel/features/Login/presentation/UI/loginpage.dart';
import 'package:cropmodel/features/Profile/presentation/UI/profile_presenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cropmodel/features/room/presentation/UI/room_presenter.dart';
import 'package:cropmodel/core/shared/data.dart';
import 'package:cropmodel/features/room/presentation/UI/room_details_presenter.dart';
import 'package:cropmodel/features/room/presentation/UI/my_rooms_presenter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../Login/data/service/SecureStorage.dart';
import '../../../Login/presentation/UI/LoginDetails.dart';
import '../../../Login/presentation/UI/widgets/ShowBiometricDialog.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  final SecureStorage _storage = SecureStorage();
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final enabled = await _storage.isBiometricEnabled();
    final promptShown = await _storage.isBiometricPromptShown();

    if (!mounted) return;
    setState(() => _biometricEnabled = enabled);

    if (!enabled && !promptShown) {
      await _storage.setBiometricPromptShown(true);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;

        showBiometricDialog(
          context: context,
          onEnable: () async {
            await _toggleBiometric(true);
          },
          onSkip: () async {
            await _toggleBiometric(false);
          },
        );
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    await _storage.setBiometricEnabled(value);

    if (!mounted) return;
    setState(() => _biometricEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    final rooms = AppData.instance.myRooms;
    final latestRooms = rooms.reversed.take(3).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsetsDirectional.only(start: 15.w),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePresenter()),
              );
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
      body: ListView(
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoomPresenter()),
              );
            },
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
                        onPressed: () {widget.onNavigate?.call(1);},
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
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(top: 30.w, right: 20.w),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyRoomsPresenter(),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  child: Text(
                    'My rooms',
                    style: TextStyle(
                      color: Color(0xffCF2120),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color.fromARGB(255, 228, 228, 228),
                ),
                color: Color(0xffFAFAFA),
              ),
              child: rooms.isEmpty
                  ? Column(
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
                        Padding(
                          padding: EdgeInsets.only(bottom: 18.h),
                          child: Text(
                            "No previous  orders yet.\nStart Your frist order!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Nunito",
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(height: 10.h),
                        ...latestRooms.map((room) {
                          final totalItems = room.orders.fold<int>(
                            0,
                            (sum, o) => sum + o.items.length,
                          );

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RoomDetailsPresenter(room: room),
                                ),
                              ).then((_) => setState(() {}));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 8.h,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      228,
                                      228,
                                      228,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44.w,
                                      height: 44.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: const Color(0xffF0C8C8),
                                      ),
                                      child: Icon(
                                        Icons.meeting_room,
                                        color: const Color(0xffCF2120),
                                        size: 22.sp,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            room.name,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            room.restaurantModel.name,
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                255,
                                                96,
                                                96,
                                                96,
                                              ),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${room.orders.length} orders',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                              255,
                                              96,
                                              96,
                                              96,
                                            ),
                                            fontSize: 11.sp,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          '$totalItems items',
                                          style: TextStyle(
                                            color: const Color(0xffCF2120),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 10.h),
                      ],
                    ),
            ),
          ),
          SizedBox(height: 100.h,),
        ],
      ),
      endDrawer: EndDrawer(onNavigate: widget.onNavigate,)
    );
  }
}
