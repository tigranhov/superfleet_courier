import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/progres_bars/time_progress_bar.dart';
import 'package:superfleet_courier/widgets/top_panel.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _NewOrderTextPanel(),
            const TimeProgressBar(value: 0.5),
            const SizedBox(height: 24),
            const _TimePreview(timeText: '00 :45'),
            const SizedBox(height: 99),
            const _AnimatedPulseWidget(),
            const SizedBox(height: 131),
            _TapToSeeOrder(
              onTap: () {
                context.go('/new_order/map_view', extra: order);
              },
            )
          ],
        ),
      ),
    );
  }
}

class _NewOrderTextPanel extends StatelessWidget {
  const _NewOrderTextPanel();

  @override
  Widget build(BuildContext context) {
    return TopPanel(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'You have a new order',
          style: context.text14w700,
        ),
      ),
    );
  }
}

class _TimePreview extends StatelessWidget {
  const _TimePreview({required this.timeText});
  final String timeText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 91,
      height: 38,
      child: Text(
        timeText,
        style: const TextStyle(
            color: superfleetBlue, fontSize: 32, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _AnimatedPulseWidget extends StatelessWidget {
  const _AnimatedPulseWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 114,
      height: 114,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 30,
            child: Container(
              width: 114,
              height: 114,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(600),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: superfleetBlue,
                size: 37,
              ),
            ),
          ),
          Transform.scale(
            scale: 15,
            child: Lottie.asset('assets/animations/new_order_animation.json',
                alignment: Alignment.center, fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }
}

class _TapToSeeOrder extends StatelessWidget {
  const _TapToSeeOrder({required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 222,
        alignment: Alignment.center,
        child: Text(
          'Tap to see order',
          style:
              context.text14w700.copyWith(color: superfleetBlue, fontSize: 16),
        ),
      ),
    );
  }
}
