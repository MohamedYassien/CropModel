import 'package:cropmodel/core/shared/end_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cropmodel/core/shared/data.dart';
import '../../../RestaurantDetails/presentaion/UI/restaurant_details.dart';
import '../../data/model/restaurant_model.dart';
import '../bloc/favouriteBloc/favorites_bloc.dart';
import '../bloc/favouriteBloc/favorites_event.dart';
import '../bloc/favouriteBloc/favorites_state.dart';
import '../bloc/restaurantBloc/restaurantBloc.dart';
import '../bloc/restaurantBloc/restaurantState.dart';
import '../bloc/restaurantEvent.dart';
import 'favourite_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  const RestaurantListScreen({super.key, this.onNavigate});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RestaurantBloc()..add(LoadRestaurantsEvent())),
        BlocProvider(create: (context) => FavoritesBloc()..add(LoadFavoritesEvent())),
      ],
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Restaurants',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 20.w, color: Colors.black),
              onPressed: () => widget.onNavigate?.call(0),
            ),
            actions: [
              Builder(builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Row(
                    children: [
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const FavoriteScreen())).then((_) {
                        context.read<FavoritesBloc>().add(LoadFavoritesEvent());
                      });
                    }, icon: Icon(Icons.favorite)),
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: Icon(Icons.menu_rounded,
                            size: 40.sp, color: Colors.black),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          body: BlocBuilder<RestaurantBloc, RestaurantState>(
            builder: (context, state) {
              if (state is RestaurantLoading) {
                return _buildShimmerLoading();
              } else if (state is RestaurantLoaded) {
                final filtered = state.restaurants.where((r) {
                  if (_searchQuery.trim().isEmpty) return true;
                  final q = _searchQuery.toLowerCase();
                  return r.name.toLowerCase().contains(q) ||
                      r.location.toLowerCase().contains(q) ||
                      r.description.toLowerCase().contains(q);
                }).toList();

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search,
                              color: Colors.grey[600], size: 22.sp),
                          filled: true,
                          fillColor: const Color(0xffF7F7F7),
                          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildRestaurantList(context, filtered),
                    ),
                  ],
                );
              } else if (state is RestaurantError) {
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

  Widget _buildRestaurantList(
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
            ).then((_) {
              if (!mounted) return;
              setState(() {});
            });
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
                        InkWell(
                          onTap: () {
                            setState(() {
                              final ids = AppData.instance.starredRestaurantIds;
                              if (ids.contains(restaurant.id)) {
                                ids.remove(restaurant.id);
                              } else {
                                ids.add(restaurant.id);
                              }
                            });
                          },
                          child: Icon(
                            AppData.instance.starredRestaurantIds
                                    .contains(restaurant.id)
                                ? Icons.star
                                : Icons.star_border,
                            size: 18.w,
                            color: Colors.amber,
                          ),
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
                    BlocBuilder<FavoritesBloc, FavoritesState>(
                      builder: (context, favoritesState) {
                        bool isFavorite = false;
                        if (favoritesState is FavoritesLoaded) {
                          isFavorite = favoritesState.favoriteRestaurants
                              .any((r) => r.id == restaurant.id);
                        }

                        return IconButton(
                          onPressed: () {
                            context
                                .read<FavoritesBloc>()
                                .add(ToggleFavoriteEvent(restaurant));
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 20.w,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
    );
  }
}
