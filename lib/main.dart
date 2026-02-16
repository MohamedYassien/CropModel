import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'features/example/presentation/UI/example_presenter.dart';
import 'features/example/presentation/bloc/example_bloc.dart';
import 'features/example/presentation/bloc/example_event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsPage(),
      builder: EasyLoading.init(),
    );
  }
}
