import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:superfleet_courier/app/bloc/user_bloc.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/widgets/text/sf_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserStateLoggedIn) {
          context.go('/home');
        }
      },
      child: Listener(
        onPointerDown: ((event) {
          FocusScope.of(context).unfocus();
        }),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        width: 130.w,
                        height: 110.h,
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(top: 40.h),
                        child: Image.asset('assets/logo.png')),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    'EMAIL ADDRESS',
                    style: context.text12w700,
                  ),
                  8.verticalSpace,
                  const SFTextfield(
                    hint: 'Enter your email address',
                  ),
                  16.verticalSpace,
                  Text(
                    'PASSWORD',
                    style: context.text12w700,
                  ),
                  const SizedBox(height: 8),
                  const SFTextfield(
                    hint: 'Enter your password',
                    obscure: true,
                    enableSuggestions: false,
                    autoCorrect: false,
                  ),
                  const SizedBox(height: 16),
                  SFButton(
                    text: 'Login',
                    width: double.infinity,
                    height: 56,
                    onPressed: () {
                      context.read<UserBloc>().add(const UserEvent.login(
                          username: 'harut.martirosyan@gmail.com',
                          password: 'Aaaa123\$'));
                    },
                  ),
                  20.verticalSpace,
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            barrierColor: superfleetGrey,
                            topRadius: Radius.circular(20.h),
                            builder: (context) {
                              return _ForgotPasswordModal();
                            },
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: context.text16grey88.copyWith(
                              color: superfleetBlue,
                              fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordModal extends StatelessWidget {
  const _ForgotPasswordModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 470.h,
        child: Column(
          children: [
            12.verticalSpace,
            Container(
                width: 39.5.w,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                  color: const Color(0xffCCCCCC),
                )),
            20.verticalSpaceFromWidth,
            SizedBox(
              height: 22.h,
              child: Text(
                'Forgot password?',
                style: context.text16grey88
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            4.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Please enter your email address and we will send you a temporary password so you can set up a new one',
                style: context.text16grey88,
                textAlign: TextAlign.center,
              ),
            ),
            16.verticalSpace,
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16.w),
              child: Text(
                'EMAIL ADDRESS',
                style: context.text12w700,
              ),
            ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const SFTextfield(
                hint: 'Enter your email address',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
