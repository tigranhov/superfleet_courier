import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                context.push('/new_order/map_view', extra: order);
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
    return Pulse(
      infinite: true,
      child: Container(
        width: 114,
        height: 114,
        color: superfleetBlue,
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
