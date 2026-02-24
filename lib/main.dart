import 'package:cropmodel/features/Login/data/service/BiometricService.dart';
import 'package:cropmodel/features/Login/presentation/bloc/LoginBloc.dart';
import 'package:cropmodel/features/sign_up/presentation/UI/sign_up_presenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/Login/data/service/SecureStorage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(
              biometricService: BiometricService(),
              secureStorage: SecureStorage(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(388, 862),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: const SignUpPresenter(),
        );
      },
    );
  }
}
