import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPresenter extends StatefulWidget{

  const SignUpPresenter({super.key});

  @override
  State<SignUpPresenter> createState() => _SignUpPresenterState();

}

class _SignUpPresenterState extends State<SignUpPresenter>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png'),
            ],
          ),
        ),
      ),
    );
  }

}