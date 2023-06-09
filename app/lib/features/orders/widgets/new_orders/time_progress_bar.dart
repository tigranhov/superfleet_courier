import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/model/order/notifiers/delivery_requests_notifier.dart';
import 'package:superfleet_courier/theme/colors.dart';

class TimeLinearProgress extends HookConsumerWidget {
  const TimeLinearProgress({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final animator = useAnimationController();
    useEffect(() {
      Future.microtask(() {
        final remainingTime = ref.read(deliveryRequestRemainingTimeProvider);
        animator.value =
            ref.read(deliveryRequestRemainingTimePercentageProvider).value ?? 0;
        animator.duration = Duration(seconds: remainingTime.value ?? 1);
        animator.forward();
      });
      return null;
    }, [animator]);

    return AnimatedBuilder(
      animation: animator,
      builder: (_, __) => LinearProgressIndicator(
        minHeight: 8,
        backgroundColor: superfleetGrey,
        color: superfleetBlue,
        value: animator.value,
      ),
    );
  }
}
