import 'package:cropmodel/core/shared/app_message.dart';
import 'package:cropmodel/core/shared/custom_button.dart';
import 'package:cropmodel/core/shared/custom_text_field.dart';
import 'package:cropmodel/core/utils/helpers.dart';
import 'package:cropmodel/core/utils/text_font_transformer.dart';
import 'package:cropmodel/features/Login/presentation/UI/loginpage.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/create-password/create_password_bloc.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/create-password/create_password_event.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/create-password/create_password_state.dart';

class CreatePasswordPresenter extends StatefulWidget {

  final String email;

  final String otp;

  const CreatePasswordPresenter({super.key, required this.email, required this.otp});

  @override
  State<StatefulWidget> createState() => _CreatePasswordPresenterState();
}

class _CreatePasswordPresenterState extends State<CreatePasswordPresenter> {
  final TextEditingController enterPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePasswordBloc(),
      child: Scaffold(
        body: BlocListener<CreatePasswordBloc, CreatePasswordState>(
          listener: (context, state) {
            if (state is CreatePasswordError) {
              AppMessage.showSnackBar(
                context,
                state.message,
                const Color(0xFFEA2020),
                Icons.error_outline,
              );
            }
            if (state is CreatePasswordSuccess) {
              AppMessage.showSnackBar(
                context,
                'Your_account_has_created_successfully'.tr(),
                Colors.green,
                Icons.check_circle_outline,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
          child: BlocBuilder<CreatePasswordBloc, CreatePasswordState>(
            builder: (context, state) {
              return SafeArea(
                child: Scaffold(
                  body: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h,),
                          Row(
                            children: [
                              SizedBox(width: 5.w),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                ),
                                color: const Color(0xff1C1B1F),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Image.asset('assets/images/create-password.png'),
                          SizedBox(height: 40.h),
                          Text(
                            'create_password'.tr(),
                            style: getDynamicStyle(context, size: 22)
                          ),
                          SizedBox(height: 40.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35.r),
                            child: CustomTextField(
                              enabled: state is! CreatePasswordLoading,
                              hintText: 'enter_your_password'.tr(),
                              controller: enterPasswordController,
                              validator: (value) =>
                                  Helpers.validateStrongPassword(value),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35.r),
                            child: CustomTextField(
                              hintText: 'confirm_password'.tr(),
                              controller: confirmPasswordController,
                              validator: (value) =>
                                  Helpers.validatePasswordConfirmation(
                                    enterPasswordController.text,
                                    confirmPasswordController.text,
                                  ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          CustomButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<CreatePasswordBloc>().add(
                                  CreatePasswordButtonPressed(
                                    email: widget.email,
                                    otp: widget.otp,
                                    password: enterPasswordController.text,
                                  ),
                                );
                              }
                            },
                            buttonTextKey: 'save',
                            isLoading: state is CreatePasswordLoading,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
