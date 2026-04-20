import 'package:cropmodel/features/Login/presentation/UI/Splach.dart';
import 'package:cropmodel/features/Change_password/presentaion/bloc/Change_password_bloc.dart';
import 'package:cropmodel/features/Login/presentation/UI/loginpage.dart';
import 'package:cropmodel/features/RestaurantDetails/presentaion/UI/map_test_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/service_locator.dart';
import 'features/RestaurantDetails/presentaion/UI/restaurant_details_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupServiceLocator();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),

      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<ChangePasswordBloc>(),
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
          home: RestaurantDetailsScreen(restaurantId: '1'),
        );
      },
    );
  }
}
