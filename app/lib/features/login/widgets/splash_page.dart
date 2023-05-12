import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // ref.listen(courierProvider, (previous, next) {
    //   if (next is CourierStateLoggedIn) {
    //     context.go('/home');
    //   } else if (next is CourierStateLoggedOut) {
    //     context.go('/login');
    //   }
    // });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
