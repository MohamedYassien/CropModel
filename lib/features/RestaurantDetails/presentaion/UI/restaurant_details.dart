import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../bottom_navigation_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/text_font_transformer.dart';
import '../../../Login/presentation/UI/loginpage.dart';
import '../../../Login/presentation/UI/widgets/showLogoutDialog.dart';
import '../../../Menu/presentation/UI/menu_screen.dart';
import '../../../room/presentation/UI/my_rooms_presenter.dart';
import '../bloc/restaurant_details_bloc.dart';
import '../bloc/restaurant_details_event.dart';
import '../bloc/restaurant_details_state.dart';

class RestaurantDetailsScreen extends StatelessWidget {

  final String restaurantId;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurantId,
  });

  Future<bool> _showMapPermissionDialog(BuildContext context, String restaurantName) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Open Maps?',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Do you want to navigate to $restaurantName using Google Maps?',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Open Maps',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }



  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }


  Future<void> openInGoogleMaps(
      BuildContext context,
      double destLat,
      double destLng,
      String restaurantName,
      String address,
      ) async {
    final bool hasPermission = await _showMapPermissionDialog(context, restaurantName);
    if (!hasPermission) return;

    final Position? userPosition = await _getCurrentLocation();

    final String origin = userPosition != null
        ? '${userPosition.latitude},${userPosition.longitude}'
        : '';

    final String destCoords = '$destLat,$destLng';

    final Uri androidNavUri = Uri.parse(
      'google.navigation:q=$destCoords&mode=d',
    );

    final Uri appleUri = Uri.parse(
      'http://maps.apple.com/?saddr=$origin&daddr=$destCoords&dirflg=d',
    );

    final Uri webUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destCoords&travelmode=driving',
    );

    try {
      if (Platform.isAndroid && await canLaunchUrl(androidNavUri)) {
        await launchUrl(androidNavUri, mode: LaunchMode.externalApplication);
        return;
      }

      if (Platform.isIOS && await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri, mode: LaunchMode.externalApplication);
        return;
      }

      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No maps app available'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Map error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening maps'), backgroundColor: Colors.red),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantDetailsBloc()
        ..add(LoadRestaurantDetailsEvent(restaurantId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<RestaurantDetailsBloc, RestaurantDetailsState>(
          builder: (context, state) {
            if (state is RestaurantDetailsLoading) {
              return _buildShimmerLoading();
            } else if (state is RestaurantDetailsLoaded) {
              final restaurant = state.restaurant;

              final LatLng restaurantLocation = LatLng(
                restaurant.latitude,
                restaurant.longitude,
              );

              final Set<Marker> markers = {
                Marker(
                  markerId: MarkerId(restaurant.id),
                  position: restaurantLocation,
                  infoWindow: InfoWindow(
                    title: restaurant.name,
                    snippet: restaurant.location,
                  ),
                ),
              };

              final CameraPosition cameraPosition = CameraPosition(
                target: restaurantLocation,
                zoom: 15,
              );

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.h,
                    pinned: true,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon:Icon(
                        Icons.arrow_back_ios,
                        size: 18.w,
                        color: Colors.white,
                      ),

                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: [
                      Builder(
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                icon: Icon(Icons.menu_rounded, size: 40.sp, color: Colors.white),
                              ),
                            );
                          }
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: restaurant.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: EdgeInsets.all(16.w),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              restaurant.name,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${restaurant.rating}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                const Icon(Icons.star, color: Colors.amber),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          restaurant.description,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 24.h),

                        _buildMenuButton(context, restaurant.id),

                        SizedBox(height: 24.h),

                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          restaurant.location,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),

                        SizedBox(height: 12.h),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: SizedBox(
                            height: 200.h,
                            child: GoogleMap(
                              initialCameraPosition: cameraPosition,
                              markers: markers,

                              scrollGesturesEnabled: true,
                              zoomGesturesEnabled: true,
                              rotateGesturesEnabled: true,
                              tiltGesturesEnabled: true,

                              onTap: (LatLng position) {
                                openInGoogleMaps(
                                  context,
                                  restaurant.latitude,
                                  restaurant.longitude,
                                  restaurant.name,
                                  restaurant.location,
                                );
                              },

                              zoomControlsEnabled: true,
                              mapToolbarEnabled: true,
                              myLocationButtonEnabled: false,

                              gestureRecognizers: {
                                Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                ),
                              },

                              onMapCreated: (controller) {},
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),
                      ]),
                    ),
                  ),
                ],
              );
            } else if (state is RestaurantDetailsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(fontSize: 14.sp),
                ),
              );
            }
            return const SizedBox.shrink();
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
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigationBar(index: 1)));},
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
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => MyRoomsPresenter()));},
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
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String restaurantId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(restaurantId: restaurantId),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 22.w,
                  color: Colors.red[400],
                ),
                SizedBox(width: 12.w),
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 250.h,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30.h,
                  width: 200.w,
                  color: Colors.white,
                ),
                SizedBox(height: 12.h),
                Container(
                  height: 80.h,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home, 'Home', false),
              _buildNavItem(Icons.restaurant, 'Restaurant', true),
              _buildNavItem(Icons.person, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24.w,
          color: isSelected ? Colors.red : Colors.grey,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: isSelected ? Colors.red : Colors.grey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}