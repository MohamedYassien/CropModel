import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared/custom_text_field.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/text_font_transformer.dart';
import '../../../Login/data/service/SecureStorage.dart';
import '../bloc/profile_block.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'crop_profile_screen.dart';
import '../dialogs/logout_dialog.dart';

class ProfilePresenter extends StatefulWidget {
  const ProfilePresenter({super.key});

  @override
  State<ProfilePresenter> createState() => _ProfilePresenterState();
}

class _ProfilePresenterState extends State<ProfilePresenter> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _isInitialized = false;
  bool _showNameError = false;
  bool _showPhoneError = false;
  final SecureStorage _storage = SecureStorage();
  bool _biometricEnabled = false;

  String _initialName = "";
  String _initialPhone = "";
  bool _initialBiometric = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldsChanged);
    _phoneNumberController.addListener(_onFieldsChanged);

    _loadBiometricStatus();

    _nameFocusNode.addListener(() {
      setState(() {
        _showNameError = _nameFocusNode.hasFocus;
      });
    });

    _phoneFocusNode.addListener(() {
      setState(() {
        _showPhoneError = _phoneFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldsChanged);
    _phoneNumberController.removeListener(_onFieldsChanged);
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadBiometricStatus() async {
    final enabled = await _storage.isBiometricEnabled();
    if (!mounted) return;
    setState(() {
      _biometricEnabled = enabled;
      _initialBiometric = enabled;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    await _storage.setBiometricEnabled(value);
    if (!mounted) return;
    setState(() {
      _biometricEnabled = value;
    });
  }

  void _onFieldsChanged() {
    setState(() {});
  }

  bool _checkHasChanges(BuildContext context) {
    final state = context.read<ProfileBloc>().state;
    Uint8List? currentTempImage;
    if (state is ProfileLoaded) {
      currentTempImage = state.tempImage;
    }

    final bool imageChanged = currentTempImage != null;
    final bool nameChanged = _nameController.text != _initialName;
    final bool phoneChanged = _phoneNumberController.text != _initialPhone;
    final bool biometricChanged = _biometricEnabled != _initialBiometric;

    return nameChanged || phoneChanged || biometricChanged || imageChanged;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc()..add(LoadProfilePressed()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (blocContext, state) {
          if (state is ProfileLoaded && !_isInitialized) {
            _nameController.text = state.user.name;
            _phoneNumberController.text = state.user.phoneNumber;
            _emailController.text = state.user.email;

            _initialName = state.user.name;
            _initialPhone = state.user.phoneNumber;
            _isInitialized = true;
          }

          if (state is ProfileUpdateSuccess) {
            setState(() {
              _initialName = _nameController.text;
              _initialPhone = _phoneNumberController.text;
              _initialBiometric = _biometricEnabled;
            });
            ScaffoldMessenger.of(blocContext).showSnackBar(
              const SnackBar(content: Text("Profile Updated!")),
            );
          }
        },
        builder: (blocContext, state) {
          if (state is ProfileLoading && !_isInitialized) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProfileError) {
            return Scaffold(
              body: Center(child: Text(state.message)),
            );
          }

          final bool isLoading = state is ProfileLoading;
          final Uint8List? tempImage = state is ProfileLoaded ? state.tempImage : null;
          final user = state is ProfileLoaded ? state.user : null;

          final bool hasChanges = _checkHasChanges(blocContext);

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
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
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            final result = await Navigator.push(
                              blocContext,
                              MaterialPageRoute(
                                builder: (context) => CropProfileScreen(
                                  initialImageBytes: tempImage ?? user?.profileImage,
                                ),
                              ),
                            );
                            if (result != null && result is Uint8List) {
                              blocContext.read<ProfileBloc>().add(ProfileImageChanged(result));
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 60.r,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: tempImage != null
                                    ? MemoryImage(tempImage)
                                    : (user?.profileImage != null
                                    ? MemoryImage(user!.profileImage!)
                                    : const AssetImage('assets/images/profilePlaceholder2.png')) as ImageProvider,
                              ),
                              Positioned(
                                bottom: -22.h,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3.w),
                                  ),
                                  child: CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: const Color(0xFFaca9a9),
                                    child: Image.asset('assets/images/cameraIcons2.png', width: 24.w, height: 24.h),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _nameController,
                                focusNode: _nameFocusNode,
                                hintText: "enter_your_name".tr(),
                                textStyle: getDynamicStyle(context, size: 18, weight: FontWeight.bold),
                                validator: (value) {
                                  if (!_showNameError) return null;
                                  return Helpers.validateFullName(value);
                                },
                                suffixIcon: Padding(
                                  padding: EdgeInsets.all(15.w),
                                  child: Image.asset(
                                    _nameFocusNode.hasFocus ? 'assets/images/editIconGray.png' : 'assets/images/editIconRed.png',
                                    width: 5.w,
                                    height: 5.h,
                                    color: _nameFocusNode.hasFocus ? AppColors.primaryColor : const Color(0xFF8E8E8E),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              CustomTextField(
                                controller: _emailController,
                                hintText: "enter_your_email".tr(),
                                enabled: false,
                              ),
                              SizedBox(height: 5.h),
                              CustomTextField(
                                controller: _phoneNumberController,
                                focusNode: _phoneFocusNode,
                                keyboardType: TextInputType.phone,
                                hintText: "enter_your_phone_number".tr(),
                                textStyle: getDynamicStyle(blocContext, size: 18, weight: FontWeight.bold),
                                validator: (value) {
                                  if (!_showPhoneError) return null;
                                  return Helpers.validatePhone(value);
                                },
                                suffixIcon: Padding(
                                  padding: EdgeInsets.all(15.w),
                                  child: Image.asset(
                                    _phoneFocusNode.hasFocus ? 'assets/images/editIconGray.png' : 'assets/images/editIconRed.png',
                                    width: 5.w,
                                    height: 5.h,
                                    color: _phoneFocusNode.hasFocus ? const Color(0xFFCF2120) : const Color(0xFF8E8E8E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 38.h),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
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
                                  Text("fingerprint_login".tr(), style: getDynamicStyle(blocContext)),
                                  const Spacer(),
                                  Switch(
                                    value: _biometricEnabled,
                                    onChanged: (value) async {
                                      await _toggleBiometric(value);
                                    },
                                    thumbColor: WidgetStateProperty.resolveWith(
                                          (states) => states.contains(WidgetState.selected) ? Colors.white : Colors.grey,
                                    ),
                                    trackColor: WidgetStateProperty.resolveWith(
                                          (states) => states.contains(WidgetState.selected) ? AppColors.primaryColor : Colors.grey.shade400,
                                    ),
                                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.grey.shade300),
                              Row(
                                children: [
                                  Icon(Icons.language_rounded, size: 30.sp, color: Colors.grey.shade600),
                                  SizedBox(width: 20.w),
                                  Text("language_switch".tr(), style: getDynamicStyle(blocContext)),
                                  const Spacer(),
                                  Switch(
                                    value: blocContext.locale.languageCode == 'ar',
                                    onChanged: (value) {
                                      blocContext.setLocale(value ? const Locale('ar') : const Locale('en'));
                                      setState(() {});
                                    },
                                    thumbColor: WidgetStateProperty.resolveWith(
                                          (states) => states.contains(WidgetState.selected) ? Colors.white : Colors.grey,
                                    ),
                                    trackColor: WidgetStateProperty.resolveWith(
                                          (states) => states.contains(WidgetState.selected) ? const Color(0xFFCF2120) : Colors.grey.shade400,
                                    ),
                                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.grey.shade300),
                              _buildListTile(
                                iconPath: 'assets/images/lockIcon.png',
                                title: "reset_password".tr(),
                                onTap: () => print("Reset password pressed!"),
                                blocContext: blocContext,
                              ),
                              Divider(color: Colors.grey.shade300),
                              _buildListTile(
                                iconPath: 'assets/images/logoutIcon.png',
                                title: "logout".tr(),
                                titleColor: Colors.red,
                                onTap: () => showLogoutDialog(blocContext),
                                blocContext: blocContext,
                              ),
                              SizedBox(height: 5.h),
                            ],
                          ),
                        ),
                        SizedBox(height: 45.h),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: (!isLoading && hasChanges)
                                ? () => blocContext.read<ProfileBloc>().add(
                              SaveProfilePressed(
                                name: _nameController.text,
                                phone: _phoneNumberController.text,
                              ),
                            )
                                : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(95.w, 45.h),
                              backgroundColor: (!isLoading && hasChanges) ? const Color(0xFFCF2120) : Colors.grey.shade400,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                            ),
                            child: isLoading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                                : Text(
                              "save".tr(),
                              style: getDynamicStyle(blocContext, color: Colors.white, size: 16),
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
        },
      ),
    );
  }

  Widget _buildListTile({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    required BuildContext blocContext,
    Color? titleColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        splashColor: Colors.red.withOpacity(0.2),
        highlightColor: Colors.red.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
          child: Row(
            children: [
              Image.asset(iconPath, width: 25.w, height: 25.h),
              SizedBox(width: 24.w),
              Text(title, style: getDynamicStyle(blocContext, color: titleColor)),
            ],
          ),
        ),
      ),
    );
  }
}