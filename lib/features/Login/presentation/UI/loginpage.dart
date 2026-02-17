import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    const mockEmail = "user@example.com";
    const mockPassword = "password123";

    setState(() {
      _isLoading = false;
    });

    if (email == mockEmail && password == mockPassword) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("login_success".tr()),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/main');
          }
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("invalid_credentials".tr()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      body: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 52.w),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 121.h),

                        Image.asset(
                          "assets/images/logo.png",
                          height: 130.h,
                          width: 130.w,
                          fit: BoxFit.contain,
                          semanticLabel: 'app_logo'.tr(),
                        ),

                        SizedBox(height: 25.h),

                        Text(
                          "login".tr(),
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        TextFormField(
                          controller: _emailController,
                          textAlign: isArabic ? TextAlign.right : TextAlign.left,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !_isLoading,
                          style: TextStyle(fontSize: 16.sp),
                          decoration: InputDecoration(
                            hintText: "email_address".tr(),
                            labelText: "email_address".tr(),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                            labelStyle: TextStyle(fontSize: 16.sp),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFCDD2), width: 2.w),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 1.5.w),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 2.w),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "email_required".tr();
                            }
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );

                            if (!emailRegex.hasMatch(value.trim())) {
                              return "invalid_email".tr();
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 20.h),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textAlign: isArabic ? TextAlign.right : TextAlign.left,
                          textInputAction: TextInputAction.done,
                          enabled: !_isLoading,
                          style: TextStyle(fontSize: 16.sp),
                          onFieldSubmitted: (_) => _login(),
                          decoration: InputDecoration(
                            hintText: "password".tr(),
                            labelText: "password".tr(),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                            labelStyle: TextStyle(fontSize: 16.sp),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFCDD2), width: 2.w),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 1.5.w),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 2.w),
                            ),

                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                                size: 20.w,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              tooltip: _obscurePassword
                                  ? 'show_password'.tr()
                                  : 'hide_password'.tr(),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "password_required".tr();
                            }
                            if (value.length < 6) {
                              return "password_min_length".tr();
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isLoading ? null : () {
                            },
                            child: Text(
                              "forgot_password".tr(),
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCF2120),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            child: _isLoading
                                ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.w,
                              ),
                            )
                                : Text(
                              'login_button'.tr(),
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "new_to_cropmeal".tr(),
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: _isLoading ? null : () {
                            },
                            child: Text(
                              "register".tr(),
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}