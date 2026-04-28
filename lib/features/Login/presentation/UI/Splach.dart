import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/features/Login/presentation/UI/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class Splach extends StatefulWidget {
  const Splach({super.key});

  @override
  State<Splach> createState() => _SplachState();
}

class _SplachState extends State<Splach> {

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    
    Future.delayed(Duration(seconds: 3),(){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
   });
  }

  Future<void> _requestLocationPermission() async {
    try {
      // Request location permission
      final status = await Permission.location.request();
      
      if (status.isPermanentlyDenied) {
        // Show dialog to open settings if permanently denied
        _showLocationPermissionDialog();
      }
    } catch (e) {
      print('Error requesting location permission: $e');
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Required'),
          content: Text(
            'This app needs location access to provide accurate delivery time estimates. Please enable location permissions in settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Image.asset("assets/images/logo.png"),

           SizedBox(height: 20.h),
          Text("CropMeal",
            style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.labelTextColor),),
           SizedBox(height: 20.h),
          CircularProgressIndicator(
            strokeWidth: 5.w,
            color: AppColors.primaryColor,
          ),
        ]
      ),
      ),
    );
  }
}
