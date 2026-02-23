import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/text_font_transformer.dart';
import 'crop_profile_screen.dart';

class ProfilePresenter extends StatefulWidget {
  const ProfilePresenter({super.key});

  @override
  State<ProfilePresenter> createState() => _ProfilePresenterState();
}

class _ProfilePresenterState extends State<ProfilePresenter> {
  Uint8List? myCroppedProfileImage;
  Uint8List? _profileImageBytes;
  bool _hasChanges = false;
  String _initialName = '';
  String _initialPhone = '';
  bool fingerprintEnabled = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initialName = '';
    _initialPhone = '';
    _nameController.text = _initialName;
    _phoneNumberController.text = _initialPhone;
    _nameController.addListener(_checkForChanges);
    _phoneNumberController.addListener(_checkForChanges);
    _nameFocusNode.addListener(() {
      setState(() {});
    });
    _phoneFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkForChanges);
    _phoneNumberController.removeListener(_checkForChanges);
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final changed =
        _nameController.text != _initialName ||
            _phoneNumberController.text != _initialPhone;

    if (changed != _hasChanges) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  void _showLogoutPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/warningIcon.png',
                  width: 40.w,
                  height: 40.h,
                ),
                SizedBox(height: 12.h),
                Text(
                  "confirm_logout_message".tr(),
                  textAlign: TextAlign.center,
                  style: getDynamicStyle(context, size: 16),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFFCF2120)),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "cancel".tr(),
                          style: getDynamicStyle(
                              context, size: 16, color: const Color(0xFFCF2120)),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCF2120),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          print("Logged out");
                        },
                        child: Text(
                          "logout".tr(),
                          style: getDynamicStyle(context, size: 16, color: Colors.white),
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 22.w),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Text(
          "profile".tr(),
          style: getDynamicStyle(context, size: 24, weight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          _nameFocusNode.unfocus();
          _phoneFocusNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 31.w),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: (_profileImageBytes != null)
                            ? MemoryImage(_profileImageBytes!)
                            : const AssetImage(
                            'assets/images/profilePlaceholder2.png')
                        as ImageProvider,
                      ),
                      Positioned(
                        bottom: -22.h,
                        child: GestureDetector(
                          onTap: () async {
                            final dynamic result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CropProfileScreen(
                                  initialImageBytes: _profileImageBytes,
                                ),
                              ),
                            );

                            if (result != null && result is Uint8List) {
                              setState(() {
                                _profileImageBytes = result;
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                              Border.all(color: Colors.white, width: 3.w),
                            ),
                            child: CircleAvatar(
                              radius: 20.r,
                              backgroundColor: const Color(0xFFaca9a9),
                              child: Image.asset(
                                'assets/images/cameraIcons2.png',
                                width: 24.w,
                                height: 24.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    focusNode: _nameFocusNode,
                    controller: _nameController,
                    style: getDynamicStyle(context),
                    decoration: InputDecoration(
                      labelText: "full_name".tr(),
                      labelStyle: getDynamicStyle(context, color: Colors.grey),
                      hintText: "enter_your_name".tr(),
                      hintStyle: getDynamicStyle(context, color: Colors.grey),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(15.w),
                        child: GestureDetector(
                          onTap: () {
                            print("Editing: ${_nameController.text}");
                          },
                          child: Image.asset(
                            _nameFocusNode.hasFocus
                                ? 'assets/images/editIconGray.png'
                                : 'assets/images/editIconRed.png',
                            width: 5.w,
                            height: 5.h,
                            fit: BoxFit.contain,
                            color: _nameFocusNode.hasFocus
                                ? const Color(0xFFCF2120)
                                : const Color(0xFF8E8E8E),
                          ),
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5.w,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red.withOpacity(0.2),
                          width: 2.w,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  TextField(
                    controller: _emailController,
                    enabled: false,
                    style: getDynamicStyle(context, color: const Color(0xFF8E8E8E)),
                    decoration: InputDecoration(
                      labelText: "email".tr(),
                      labelStyle: getDynamicStyle(context, color: Colors.grey),
                      hintText: "enter_your_email".tr(),
                      hintStyle: getDynamicStyle(context, color: Colors.grey),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5.w,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5.w,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  TextField(
                    focusNode: _phoneFocusNode,
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    style: getDynamicStyle(context),
                    decoration: InputDecoration(
                      labelText: "phone_number".tr(),
                      labelStyle: getDynamicStyle(context, color: Colors.grey),
                      hintText: "enter_your_phone_number".tr(),
                      hintStyle: getDynamicStyle(context, color: Colors.grey),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(15.w),
                        child: GestureDetector(
                          onTap: () {
                            print("Editing: ${_nameController.text}");
                          },
                          child: Image.asset(
                            _phoneFocusNode.hasFocus
                                ? 'assets/images/editIconGray.png'
                                : 'assets/images/editIconRed.png',
                            width: 5.w,
                            height: 5.h,
                            fit: BoxFit.contain,
                            color: _phoneFocusNode.hasFocus
                                ? const Color(0xFFCF2120)
                                : const Color(0xFF8E8E8E),
                          ),
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5.w,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red.withOpacity(0.2),
                          width: 2.w,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                    width: 400.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFf8f8f8),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.fingerprint, size: 30.sp),
                            SizedBox(width: 20.w),
                            Text("fingerprint_login".tr(), style: getDynamicStyle(context)),
                            const Spacer(),
                            Switch(
                              value: fingerprintEnabled,
                              onChanged: (value) {
                                setState(() {
                                  fingerprintEnabled = value;
                                });
                              },
                              thumbColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.white;
                                }
                                return Colors.grey;
                              }),
                              trackColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return const Color(0xFFCF2120);
                                }
                                return Colors.grey.shade400;
                              }),
                              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey.shade300),
                        Row(
                          children: [
                            Icon(Icons.language_rounded, size: 30.sp, color: Colors.grey.shade600,),
                            SizedBox(width: 20.w),
                            Text("language_switch".tr(), style: getDynamicStyle(context)),
                            const Spacer(),
                            Switch(
                              value: context.locale.languageCode == 'ar',
                              onChanged: (value) {
                                context.setLocale(value ? const Locale('ar') : const Locale('en'));
                              },
                              thumbColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.white;
                                }
                                return Colors.grey;
                              }),
                              trackColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return const Color(0xFFCF2120);
                                }
                                return Colors.grey.shade400;
                              }),
                              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey.shade300),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () {
                              print("Reset password pressed!");
                            },
                            splashColor: Colors.red.withOpacity(0.2),
                            highlightColor: Colors.red.withOpacity(0.1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
                              child: Row(
                                children: [
                                  Image.asset('assets/images/lockIcon.png', width: 25.w, height: 25.h),
                                  SizedBox(width: 20.w),
                                  Text("reset_password".tr(), style: getDynamicStyle(context)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () {
                              print("Logout pressed!");
                              _showLogoutPopup();
                            },
                            splashColor: Colors.red.withOpacity(0.2),
                            highlightColor: Colors.red.withOpacity(0.1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
                              child: Row(
                                children: [
                                  Image.asset('assets/images/logoutIcon.png', width: 25.w, height: 25.h),
                                  SizedBox(width: 20.w),
                                  Text(
                                    "logout".tr(),
                                    style: getDynamicStyle(context, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 80.h),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: ElevatedButton(
                        onPressed: _hasChanges
                            ? () {
                          print("Saved!");
                          setState(() {
                            _initialName = _nameController.text;
                            _initialPhone = _phoneNumberController.text;
                            _hasChanges = false;
                          });
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(95.w, 45.h),
                          backgroundColor:
                          _hasChanges ? const Color(0xFFCF2120) : const Color(0x33CF2120),
                          disabledBackgroundColor: const Color(0x33CF2120),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        child: Text(
                          "save".tr(),
                          style: getDynamicStyle(context, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}