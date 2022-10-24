import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:superfleet_courier/app/bloc/user_bloc.dart';
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
                  Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(top: 60),
                      child: Image.asset('assets/logo.png')),
                  const SizedBox(height: 40),
                  const Text(
                    'EMAIL ADDRESS',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const SFTextfield(
                    hint: 'Enter your email address',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'PASSWORD',
                    style: TextStyle(fontWeight: FontWeight.w700),
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
