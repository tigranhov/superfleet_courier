import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:superfleet_courier/model/order/notifiers/delivery_requests_notifier.dart';
import 'package:superfleet_courier/routes.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/utilities/audio_player.dart';

import 'time_progress_bar.dart';

class NewOrderPopupScreen extends ConsumerWidget {
  const NewOrderPopupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(deliveryRequestsProvider, (previous, next) {
      Future.microtask(() {
        if (next.value == null && context.canPop()) {
          context.pop();
        }
      });
    });
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          _YouHaveANewOrder(),
          TimeLinearProgress(),
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

    final audioPlayer = ref.read(audioPlayerProvider);
    useEffect(() {
      HapticFeedback.vibrate();
      controller.forward();
      audioPlayer.play(
          AssetSource(
            'sounds/new_order_v1.mp3',
          ),
          mode: PlayerMode.lowLatency);
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
          HapticFeedback.vibrate();
          audioPlayer.seek(Duration.zero);
          audioPlayer.play(
              AssetSource(
                'sounds/new_order_v1.mp3',
              ),
              mode: PlayerMode.lowLatency);
        }
      });
      return null;
    }, [controller]);

    const size = 100.0;
    final pulseSize = MediaQuery.of(context).size.width * 2;
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
            top: 130,
            child: Container(
              width: size,
              height: size,
              clipBehavior: Clip.none,
              child: OverflowBox(
                maxHeight: double.infinity,
                maxWidth: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Lottie.asset(
                      'assets/animations/new_order_animation.json',
                      width: pulseSize,
                      height: pulseSize,
                      controller: controller,
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
              width: size,
              height: size,
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
