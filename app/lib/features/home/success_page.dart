import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:superfleet_courier/routes.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class SuccessPage extends HookWidget {
  const SuccessPage({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    useFuture(
      Future.delayed(const Duration(seconds: 3))
          .then((value) => const HomeRoute().go(context)),
    );
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Lottie.asset(
              'assets/animations/success_animation.json',
              repeat: true,
              height: 240,
              width: 240,
              options: LottieOptions(
                enableMergePaths: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
              width: 256,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: context.text16w700.copyWith(fontSize: 20),
              )),
        ],
      ),
    ));
  }
}
