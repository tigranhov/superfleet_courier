import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:superfleet_courier/app/bloc/user_bloc.dart';
import 'package:superfleet_courier/model/user.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    final state = context.read<UserBloc>().state;
    if (state is UserStateLoggedIn) {
      context.go('/home');
    } else if (state is UserStateLoggedOut) {
      context.go('/login');
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserStateLoggedIn) {
          context.go('/home');
        } else if (state is UserStateLoggedOut) {
          context.go('/login');
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
