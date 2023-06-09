import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:superfleet_courier/model/order/notifiers/delivery_requests_notifier.dart';
import 'package:superfleet_courier/routes.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class NewOrderPopupScreen extends ConsumerWidget {
  const NewOrderPopupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          _YouHaveANewOrder(),
          _TimeLinearProgress(),
          SizedBox(height: 24),
          _TimeText(),
          Expanded(child: _PulsingIndicatorIcon()),
        ]),
      ),
    );
  }
}

class _YouHaveANewOrder extends StatelessWidget {
  const _YouHaveANewOrder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      child: Text(
        'YOU HAVE A NEW ORDER',
        style: context.text14w700,
      ),
    );
  }
}

class _TimeLinearProgress extends ConsumerWidget {
  const _TimeLinearProgress();

  @override
  Widget build(BuildContext context, ref) {
    final remainingPercentage =
        ref.watch(deliveryRequestRemainingTimePercentageProvider);
    return LinearProgressIndicator(
      minHeight: 8,
      backgroundColor: superfleetGrey,
      color: superfleetBlue,
      value: remainingPercentage.value ?? 0,
    );
  }
}

class _TimeText extends ConsumerWidget {
  const _TimeText();

  @override
  Widget build(BuildContext context, ref) {
    final remainingTime = ref.watch(deliveryRequestRemainingTimeProvider);
    return Text(remainingTime.toMMSS(),
        style: context.text14w700.copyWith(
          color: superfleetBlue,
          fontSize: 30,
          height: 1,
        ));
  }
}

class _PulsingIndicatorIcon extends HookConsumerWidget {
  const _PulsingIndicatorIcon();

  @override
  Widget build(BuildContext context, ref) {
    final controller =
        useAnimationController(duration: const Duration(seconds: 3));
    useEffect(() {
      HapticFeedback.vibrate();
      controller.forward();
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
          HapticFeedback.vibrate();
        }
      });
      return null;
    }, [controller]);

    return GestureDetector(
      onTap: () {
        final deliveryRequest = ref.read(deliveryRequestsProvider).value!;
        NewOrderRoute(deliveryRequest.id).go(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 115,
            child: Container(
              width: 114,
              height: 114,
              clipBehavior: Clip.none,
              child: OverflowBox(
                maxHeight: double.infinity,
                maxWidth: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Lottie.asset(
                      'assets/animations/new_order_animation.json',
                      width: 1600,
                      height: 1600,
                      addRepaintBoundary: true,
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Positioned(
            top: 345,
            child: TextButton(
              onPressed: null,
              child: Text(
                'Tap to see order',
                style: context.text16w700.copyWith(color: superfleetBlue),
              ),
            ),
          ),
          Positioned(
            top: 130,
            child: Container(
              width: 114,
              height: 114,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(600),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: superfleetBlue,
                size: 37,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
