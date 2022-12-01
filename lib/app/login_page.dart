import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:superfleet_courier/app/bloc/courier_bloc.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/widgets/text/sf_textfield.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourierBloc, CourierState>(
      listener: (context, state) {
        if (state is CourierStateLoggedIn) {
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
                        width: 130,
                        height: 110,
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 40),
                        child: Image.asset('assets/logo.png')),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'EMAIL ADDRESS',
                    style: context.text12w700,
                  ),
                  const SizedBox(height: 8),
                  const SFTextfield(
                    hint: 'Enter your email address',
                  ),
                  const SizedBox(height: 16),
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
                      context.read<CourierBloc>().add(const CourierEvent.login(
                          username: 'harut.martirosyan@gmail.com',
                          password: 'Aaaa123\$'));
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            barrierColor: superfleetGrey,
                            topRadius: const Radius.circular(20),
                            builder: (context) {
                              return const _ForgotPasswordModal();
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

class _ForgotPasswordModal extends HookWidget {
  const _ForgotPasswordModal();
  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final hasFocusState = useState(false);
    useEffect(() {
      focusNode.addListener(() {
        hasFocusState.value = focusNode.hasFocus;
      });
      return;
    }, [focusNode]);
    return GestureDetector(
      onTap: (() => focusNode.unfocus()),
      behavior: HitTestBehavior.opaque,
      child: Material(
        child: SizedBox(
          height: 470,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                  width: 39.5,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                    color: const Color(0xffCCCCCC),
                  )),
              const SizedBox(height: 20),
              SizedBox(
                height: 22,
                child: Text(
                  'Forgot password?',
                  style: context.text16grey88.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: hasFocusState.value ? 0 : null,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Please enter your email address and we will send you a temporary password so you can set up a new one',
                    style: context.text16grey88,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'EMAIL ADDRESS',
                  style: context.text12w700,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SFTextfield(
                  focusNode: focusNode,
                  hint: 'Enter your email address',
                ),
              ),
              const SizedBox(height: 16),
              SFButton(
                  text: 'Send new password',
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  onPressed: () {}),
              const SizedBox(height: 16),
              SFButton(
                text: 'Cancel',
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                inverse: true,
                onPressed: () {},
              ),

            ],
          ),
        ),
      ),
    );
  }
}
