import 'package:cropmodel/core/shared/end_drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../RestaurantDetails/presentaion/UI/restaurant_details.dart';
import '../../data/model/restaurant_model.dart';
import '../bloc/favouriteBloc/favorites_bloc.dart';
import '../bloc/favouriteBloc/favorites_event.dart';
import '../bloc/favouriteBloc/favorites_state.dart';

class FavoriteScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  const FavoriteScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesBloc()..add(LoadFavoritesEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'favorites'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20.w, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Builder(builder: (context) {
              return Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(Icons.menu_rounded,
                      size: 40.sp, color: Colors.black),
                ),
              );
            }),
          ],
        ),
        body: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return _buildShimmerLoading();
            } else if (state is FavoritesLoaded) {
              if (state.favoriteRestaurants.isEmpty) {
                return _buildEmptyState();
              }
              return _buildFavoriteList(context, state.favoriteRestaurants);
            } else if (state is FavoritesError) {
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
        endDrawer: EndDrawer(onNavigate: onNavigate),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.w,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16.h),
          Text(
            'no_favorites_yet'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'tap_heart_to_add_favorites'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: 100.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteList(
      BuildContext context, List<RestaurantModel> restaurants) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantDetailsScreen(
                  restaurantId: restaurant.id,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Stack(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            color: Colors.white,
                          ),
                        ),
                        Image.network(
                          restaurant.imageUrl,
                          width: 80.w,
                          height: 80.w,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const SizedBox.shrink();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80.w,
                              height: 80.w,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.broken_image,
                                size: 30.w,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        restaurant.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14.w,
                            color: Colors.red[400],
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              restaurant.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16.w,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          restaurant.rating.toString(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    IconButton(
                      onPressed: () {
                        context
                            .read<FavoritesBloc>()
                            .add(RemoveFavoriteEvent(restaurant.id));
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
