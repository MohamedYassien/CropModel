import 'package:cropmodel/core/services/navigation_history_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/features/room/presentation/bloc/room_bloc.dart';
import 'package:cropmodel/features/room/presentation/bloc/room_event.dart';
import 'package:cropmodel/features/room/presentation/bloc/room_state.dart';
import 'package:cropmodel/features/room/presentation/UI/room_details_presenter.dart';

class RoomPresenter extends StatefulWidget {
  @override
  State<RoomPresenter> createState() => _RoomPresenterState();
}

class _RoomPresenterState extends State<RoomPresenter> {
  final TextEditingController _roomNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    NavigationHistoryService().saveLastPosition('room', routeName: 'room');
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoomBloc()..add(RoomStarted()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20.w, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'create_order'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<RoomBloc, RoomState>(
          builder: (context, state) {
            if (state.loadingRestaurants) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.errorMessage != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Text(
                          state.errorMessage!,
                          style: TextStyle(
                            color: AppColors.errorColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    Text(
                      'restaurant'.tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFA),
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: const Color.fromARGB(255, 228, 228, 228),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: state.selectedRestaurant,
                          items: state.restaurants
                              .map(
                                (r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(
                                    r.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              context.read<RoomBloc>().add(
                                    RestaurantSelected(value),
                                  );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Room',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: _roomNameController,
                      cursorColor: AppColors.cursorColor,
                      decoration: InputDecoration(
                        hintText: 'Enter room name',
                        hintStyle: TextStyle(
                          color: AppColors.hintTextColor,
                          fontFamily: 'Nunito',
                        ),
                        filled: true,
                        fillColor: const Color(0xffFAFAFA),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.r),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 228, 228, 228),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.r),
                          borderSide: const BorderSide(
                            color: AppColors.focusBorderColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                        onPressed: () {
                          final name = _roomNameController.text.trim();
                          if (name.isEmpty) return;
                          final selected = state.selectedRestaurant;
                          if (selected == null) return;

                          final createdRoom =
                              context.read<RoomBloc>().createRoomSync(
                                    roomName: name,
                                    restaurant: selected,
                                  );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RoomDetailsPresenter(room: createdRoom),
                            ),
                          );
                          _roomNameController.clear();
                        },
                        child: Text(
                          'Create Room',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 22.h),
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
