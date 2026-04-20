// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
//
// class RestaurantDetailsScreen extends StatefulWidget {
//   final String restaurantId;
//
//   const RestaurantDetailsScreen({
//     super.key,
//     required this.restaurantId,
//   });
//
//   @override
//   State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
// }
//
// class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<RestaurantBloc>().add(
//       FetchRestaurantDetails(widget.restaurantId),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: BlocBuilder<RestaurantBloc, RestaurantState>(
//           builder: (context, state) {
//             if (state is RestaurantLoading) {
//               return _buildLoadingShimmer();
//             }
//
//             if (state is RestaurantDetailsLoaded) {
//               final restaurant = state.restaurant!;
//               return CustomScrollView(
//                 slivers: [
//                   SliverAppBar(
//                     floating: true,
//                     backgroundColor: Colors.white,
//                     elevation: 0,
//                     leading: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.black),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     title: Text(
//                       'Restaurant details',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   SliverPadding(
//                     padding: EdgeInsets.all(16.w),
//                     sliver: SliverList(
//                       delegate: SliverChildListDelegate([
//                         // Restaurant Image
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(16.r),
//                           child: CachedNetworkImage(
//                             imageUrl: restaurant.imageUrl,
//                             height: 200.h,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => Shimmer.fromColors(
//                               baseColor: Colors.grey[300]!,
//                               highlightColor: Colors.grey[100]!,
//                               child: Container(
//                                 height: 200.h,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             errorWidget: (context, url, error) => Container(
//                               height: 200.h,
//                               color: Colors.grey[300],
//                               child: const Icon(Icons.restaurant, size: 50),
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: 16.h),
//
//                         // Name and Rating
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               restaurant.name,
//                               style: TextStyle(
//                                 fontSize: 24.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   '${restaurant.rating}',
//                                   style: TextStyle(
//                                     fontSize: 18.sp,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 SizedBox(width: 4.w),
//                                 const Icon(Icons.star, color: Colors.amber, size: 20),
//                               ],
//                             ),
//                           ],
//                         ),
//
//                         SizedBox(height: 8.h),
//
//                         // Description
//                         Text(
//                           restaurant.description,
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: Colors.grey[600],
//                             height: 1.5,
//                           ),
//                         ),
//
//                         SizedBox(height: 20.h),
//
//                         // Menu Button
//                         GestureDetector(
//                           onTap: () {
//                             // Navigate to menu when API ready
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16.w,
//                               vertical: 12.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[100],
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Icon(Icons.restaurant_menu, color: Colors.grey[700]),
//                                     SizedBox(width: 12.w),
//                                     Text(
//                                       'Menu',
//                                       style: TextStyle(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Icon(Icons.chevron_right, color: Colors.grey[600]),
//                               ],
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: 24.h),
//
//                         // Location Section with Google Map
//                         Text(
//                           'Location',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//
//                         SizedBox(height: 8.h),
//
//                         Text(
//                           restaurant.address,
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//
//                         SizedBox(height: 12.h),
//
//                         // GOOGLE MAP WIDGET
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(16.r),
//                           child: SizedBox(
//                             height: 200.h,
//                             child: GoogleMap(
//                               initialCameraPosition: state.cameraPosition,
//                               markers: state.markers,
//                               zoomControlsEnabled: true,
//                               mapToolbarEnabled: false,
//                               myLocationButtonEnabled: false,
//                               scrollGesturesEnabled: true,
//                               zoomGesturesEnabled: true,
//                               onMapCreated: (GoogleMapController controller) {
//                                 // Controller ready for future interactions
//                               },
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: 24.h),
//                       ]),
//                     ),
//                   ),
//                 ],
//               );
//             }
//
//             if (state is RestaurantError) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.error_outline, color: Colors.red, size: 60),
//                     SizedBox(height: 16.h),
//                     Text(state.message),
//                     SizedBox(height: 16.h),
//                     ElevatedButton(
//                       onPressed: () {
//                         context.read<RestaurantBloc>().add(
//                           FetchRestaurantDetails(widget.restaurantId),
//                         );
//                       },
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: SingleChildScrollView(
//         padding: EdgeInsets.all(16.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(height: 200.h, color: Colors.white),
//             SizedBox(height: 16.h),
//             Container(height: 24.h, width: 150.w, color: Colors.white),
//             SizedBox(height: 8.h),
//             Container(height: 60.h, color: Colors.white),
//             SizedBox(height: 20.h),
//             Container(height: 50.h, color: Colors.white),
//             SizedBox(height: 24.h),
//             Container(height: 18.h, width: 100.w, color: Colors.white),
//             SizedBox(height: 12.h),
//             Container(height: 200.h, color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }