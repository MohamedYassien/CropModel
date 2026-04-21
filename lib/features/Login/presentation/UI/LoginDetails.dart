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
          ],
        ),
      ),
    );
  }
}