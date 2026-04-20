import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurantId,
  });

  static const Map<String, dynamic> mockData = {
    'id': '1',
    'name': 'KFC',
    'image_url':
    'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=800',
    'rating': 4.8,
    'description':
    'KFC is a popular fast-food chain known for its crispy fried chicken and a variety of meals like sandwiches and buckets.',
    'address': '123 Main Street, San Francisco, CA',
    'latitude': 37.7749,
    'longitude': -122.4194,
  };

  /// Launches Google Maps Navigation
  Future<void> openInGoogleMaps(double lat, double lng) async {
    final Uri googleMapsUri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    final Uri appleMapsUri = Uri.parse("https://maps.apple.com/?q=$lat,$lng");
    final Uri fallbackUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    try {
      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(appleMapsUri)) {
        await launchUrl(appleMapsUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Could not launch maps: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = mockData['name'];
    final String imageUrl = mockData['image_url'];
    final double rating = mockData['rating'];
    final String description = mockData['description'];
    final String address = mockData['address'];
    final double latitude = mockData['latitude'];
    final double longitude = mockData['longitude'];

    final LatLng restaurantLocation = LatLng(latitude, longitude);

    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('restaurant'),
        position: restaurantLocation,
        infoWindow: InfoWindow(
          title: name,
          snippet: address,
        ),
      ),
    };

    final CameraPosition cameraPosition = CameraPosition(
      target: restaurantLocation,
      zoom: 15,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Restaurant details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // IMAGE SECTION
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 200.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(height: 200.h, color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200.h,
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // NAME AND RATING SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$rating',
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
                    description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // LOCATION SECTION
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // UPDATED MAP SECTION
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: SizedBox(
                      height: 200.h,
                      child: GoogleMap(
                        initialCameraPosition: cameraPosition,
                        markers: markers,

                        // Allows the user to move and zoom the map
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        tiltGesturesEnabled: true,

                        // Detects clicks on the map to trigger navigation
                        onTap: (LatLng position) {
                          openInGoogleMaps(latitude, longitude);
                        },

                        // Optional UI enhancements
                        mapToolbarEnabled: true,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,

                        // Handles gesture competition with the parent CustomScrollView
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                          ),
                        },
                        onMapCreated: (controller) {},
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}