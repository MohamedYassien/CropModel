import 'package:cropmodel/core/constants/app_colors.dart';
import 'package:cropmodel/core/utils/helpers.dart';
import 'package:cropmodel/features/sign_up/data/model/sign_up_request.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/custom_text_field.dart';
import '../bloc/sign_up_bloc.dart';
import '../bloc/sign_up_event.dart';
import '../bloc/sign_up_state.dart';

class SignUpPresenter extends StatefulWidget {
  const SignUpPresenter({super.key});

  @override
  State<SignUpPresenter> createState() => _SignUpPresenterState();
}

class _SignUpPresenterState extends State<SignUpPresenter> {
  final List<TextEditingController> _controllers = List.generate(
    3,
    (index) => TextEditingController(),
  );

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SignUpBloc(),
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }

            if (state is SignUpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('sign_up_success'.tr())),
              );
            }
          },
          child: BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, state) {
              return Scaffold(
                body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 80.h),
                      Image.asset('assets/images/logo.png'),
                      SizedBox(height: 30.h),
                      Text(
                        'sign_up'.tr(),
                        style: TextStyle(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.r),
                        child: CustomTextField(
                          hintText: 'full_name'.tr(),
                          controller: _controllers[0],
                          validator: (value) => Helpers.validateFullName(value),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.r),
                        child: CustomTextField(
                          hintText: 'email_address'.tr(),
                          controller: _controllers[1],
                          validator: (value) => Helpers.validateEmail(value),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.r),
                        child: CustomTextField(
                          hintText: 'phone_number'.tr(),
                          controller: _controllers[2],
                          keyboardType: TextInputType.phone,
                          validator: (value) => Helpers.validatePhone(value),
                        ),
                      ),
                      SizedBox(height: 70.h),
                      state is SignUpLoading
                          ? CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            )
                          : Container(
                              width: 284.w,
                              height: 52.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.primaryColor,
                              ),
                              child: MaterialButton(
                                child: Text(
                                  'continue'.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();

                                  if (_formKey.currentState!.validate()) {
                                    context.read<SignUpBloc>().add(
                                      SignUpButtonPressed(
                                        signUpRequest: SignUpRequest(
                                          name: _controllers[0].text,
                                          email: _controllers[1].text,
                                          phone: _controllers[2].text,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                      SizedBox(height: 100.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "have_an_account_already".tr(),
                            style: TextStyle(
                              color: Color(0xff62707D),
                              fontSize: 16.sp,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {},
                            child: Text(
                              "login".tr(),
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontFamily: 'Nunito',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
          )
        )
      );
  }
}
