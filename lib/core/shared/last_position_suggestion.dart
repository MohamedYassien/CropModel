import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/navigation_history_service.dart';

class LastPositionSuggestion extends StatefulWidget {
  final VoidCallback onDismiss;
  final VoidCallback? onGoBack;

  const LastPositionSuggestion(
      {super.key, required this.onDismiss, this.onGoBack});

  @override
  State<LastPositionSuggestion> createState() => _LastPositionSuggestionState();
}

class _LastPositionSuggestionState extends State<LastPositionSuggestion> {
  String? _routeName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLastPosition();
  }

  Future<void> _loadLastPosition() async {
    final history = await NavigationHistoryService().getLastPosition();
    if (mounted) {
      setState(() {
        _routeName = history['routeName'];
        _isLoading = false;
      });
    }
  }

  void _handleGoBack() {
    if (widget.onGoBack != null) {
      widget.onGoBack!();
    } else {
      widget.onDismiss();
    }
  }

  String _getDisplayName(String? route) {
    switch (route) {
      case 'restaurant_list':
        return 'restaurants_list'.tr();
      case 'restaurant_details':
        return 'restaurant_details'.tr();
      case 'menu':
        return 'menu'.tr();
      case 'cart':
        return 'cart'.tr();
      case 'room':
        return 'room'.tr();
      case 'room_details':
        return 'room_details'.tr();
      case 'profile':
        return 'profile'.tr();
      case 'my_rooms':
        return 'my_rooms_title'.tr();
      default:
        return 'previous_page'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _routeName == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xffFEF3F3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xffCF2120).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xffCF2120).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.history,
                  color: const Color(0xffCF2120),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'continue_where_left'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'you_were_at'.tr(
                          namedArgs: {'pageName': _getDisplayName(_routeName)}),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Nunito',
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: widget.onDismiss,
                child: Icon(
                  Icons.close,
                  size: 20.sp,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: ElevatedButton(
              onPressed: _handleGoBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffCF2120),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'go_back'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
