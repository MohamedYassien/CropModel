import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/core/services/navigation_history_service.dart';
import 'package:cropmodel/core/shared/data.dart';
import 'package:cropmodel/features/room/presentation/UI/room_details_presenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyRoomsPresenter extends StatefulWidget {
  const MyRoomsPresenter({super.key});

  @override
  State<MyRoomsPresenter> createState() => _MyRoomsPresenterState();
}

class _MyRoomsPresenterState extends State<MyRoomsPresenter> {
  @override
  void initState() {
    super.initState();
    NavigationHistoryService()
        .saveLastPosition('my_rooms', routeName: 'my_rooms');
  }

  @override
  Widget build(BuildContext context) {
    final rooms = AppData.instance.myRooms;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.w, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'my_rooms_title'.tr(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'Nunito',
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: rooms.isEmpty
            ? Center(
                child: Text(
                  'no_rooms_yet'.tr(),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 96, 96, 96),
                    fontSize: 13.sp,
                    fontFamily: 'Nunito',
                  ),
                ),
              )
            : ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  final totalItems = room.orders.fold<int>(
                    0,
                    (sum, o) => sum + o.items.length,
                  );

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoomDetailsPresenter(room: room),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: const Color.fromARGB(255, 228, 228, 228),
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: const Color(0xffF0C8C8),
                            ),
                            child: Icon(
                              Icons.meeting_room,
                              color: AppColors.primaryColor,
                              size: 22.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  room.restaurantModel.name,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color:
                                        const Color.fromARGB(255, 96, 96, 96),
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${room.orders.length} orders',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color.fromARGB(255, 96, 96, 96),
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '$totalItems items',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
