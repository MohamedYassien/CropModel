import 'package:cropmodel/features/Login/presentation/UI/widgets/ShowBiometricDialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Profile/presentation/UI/profile_presenter.dart';
import '../../data/service/SecureStorage.dart';
import 'loginpage.dart';


class LoginDetails extends StatefulWidget {
  const LoginDetails({super.key});

  @override
  State<LoginDetails> createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {
  final SecureStorage _storage = SecureStorage();
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final enabled = await _storage.isBiometricEnabled();
    final promptShown = await _storage.isBiometricPromptShown();

    if (!mounted) return;
    setState(() => _biometricEnabled = enabled);

    if (!enabled && !promptShown) {
      await _storage.setBiometricPromptShown(true);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;

        showBiometricDialog(
          context: context,
          onEnable: () async {
            await _toggleBiometric(true);
          },
          onSkip: () async {
            await _toggleBiometric(false);
          },
        );
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    await _storage.setBiometricEnabled(value);

    if (!mounted) return;
    setState(() => _biometricEnabled = value);
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Access Biometric",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFFCF2120)),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePresenter())
              );            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(20.w),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(20.r),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.06),
            //         blurRadius: 14,
            //         offset: const Offset(0, 5),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     children: [
            //       Icon(
            //         Icons.check_circle_rounded,
            //         color: const Color(0xFFCF2120),
            //         size: 60.sp,
            //       ),
            //       SizedBox(height: 12.h),
            //       Text(
            //         "You are logged in",
            //         style: TextStyle(
            //           fontSize: 22.sp,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.black87,
            //         ),
            //       ),
            //       SizedBox(height: 20.h),
            //       SwitchListTile(
            //         contentPadding: EdgeInsets.zero,
            //         activeColor: const Color(0xFFCF2120),
            //         title: Text(
            //           "Enable Biometric Login",
            //           style: TextStyle(
            //             fontSize: 16.sp,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //         value: _biometricEnabled,
            //         onChanged: _toggleBiometric,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}