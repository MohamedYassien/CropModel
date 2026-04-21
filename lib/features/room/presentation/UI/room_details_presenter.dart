import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/features/HomePage/presentation/ui/homepage_screen.dart';
import 'package:cropmodel/features/Menu/presentation/UI/menu_screen.dart';
import 'package:cropmodel/features/room/data/model/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomDetailsPresenter extends StatefulWidget {
  final Room room;

  const RoomDetailsPresenter({super.key, required this.room});

  @override
  State<RoomDetailsPresenter> createState() => _RoomDetailsPresenterState();
}

class _RoomDetailsPresenterState extends State<RoomDetailsPresenter> {
  @override
  Widget build(BuildContext context) {
    final room = widget.room;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.w, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => homepage()),
          ),
        ),
        title: Text(
          room.name,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'Nunito',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryColor, Color(0xffFF1D1D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.meeting_room, color: Colors.white, size: 30.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.restaurantModel.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${room.orders.length} orders',
                            style: TextStyle(
                              color: Colors.white.withAlpha(220),
                              fontSize: 12.sp,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuScreen(
                        restaurantId: room.restaurantModel.id,
                        room: room,
                      ),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(
                      color: const Color.fromARGB(255, 228, 228, 228),
                    ),
                    color: const Color(0xffFAFAFA),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 49.w,
                        height: 51.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.r),
                          color: const Color(0xffF0C8C8),
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          color: AppColors.primaryColor,
                          size: 26.sp,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Browse menu',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Nunito',
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Add items to this room',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 96, 96, 96),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w200,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Users',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito',
                ),
              ),
              SizedBox(height: 10.h),
              if (room.users.isEmpty)
                Text(
                  'No users yet',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 96, 96, 96),
                    fontSize: 13.sp,
                    fontFamily: 'Nunito',
                  ),
                )
              else
                ...room.users.map(
                  (u) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: const Color.fromARGB(255, 228, 228, 228),
                        ),
                        color: Colors.white,
                      ),
                      child: Text(
                        u.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 18.h),
              Text(
                'Orders',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito',
                ),
              ),
              SizedBox(height: 10.h),
              if (room.orders.isEmpty)
                Text(
                  'No orders yet',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 96, 96, 96),
                    fontSize: 13.sp,
                    fontFamily: 'Nunito',
                  ),
                )
              else
                ...room.orders.map(
                  (o) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: const Color.fromARGB(255, 228, 228, 228),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  o.user.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),
                              Text(
                                '${o.items.length} items',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 96, 96, 96),
                                  fontSize: 12.sp,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          if (o.items.isEmpty)
                            Text(
                              'No items yet',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 96, 96, 96),
                                fontSize: 12.sp,
                                fontFamily: 'Nunito',
                              ),
                            )
                          else
                            ...o.items.map(
                              (item) => Padding(
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Nunito',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'EGP ${item.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: 6.h),
                          Divider(
                            color: const Color.fromARGB(255, 228, 228, 228),
                            height: 16.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      96,
                                      96,
                                      96,
                                    ),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),
                              Text(
                                'EGP ${o.items.fold<double>(0.0, (sum, i) => sum + i.price).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
