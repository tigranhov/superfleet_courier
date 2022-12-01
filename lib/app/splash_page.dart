import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:superfleet_courier/app/bloc/courier_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    final state = context.read<CourierBloc>().state;
    if (state is CourierStateLoggedIn) {
      context.go('/home');
    } else if (state is CourierStateLoggedOut) {
      context.go('/login');
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourierBloc, CourierState>(
      listener: (context, state) {
        if (state is CourierStateLoggedIn) {
          context.go('/home');
        } else if (state is CourierStateLoggedOut) {
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
