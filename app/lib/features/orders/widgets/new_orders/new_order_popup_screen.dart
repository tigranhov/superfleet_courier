import 'package:flutter/material.dart';
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

class _TimeLinearProgress extends StatelessWidget {
  const _TimeLinearProgress();

  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator(
      minHeight: 8,
      backgroundColor: superfleetGrey,
      color: superfleetBlue,
      value: 0.5,
    );
  }
}

class _TimeText extends StatelessWidget {
  const _TimeText();

  @override
  Widget build(BuildContext context) {
    return Text('00:45',
        style: context.text14w700.copyWith(
          color: superfleetBlue,
          fontSize: 30,
          height: 1,
        ));
  }
}

class _PulsingIndicatorIcon extends ConsumerWidget {
  const _PulsingIndicatorIcon();

  @override
  Widget build(BuildContext context, ref) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
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
        GestureDetector(
          onTap: () {
            final deliveryRequest = ref.read(deliveryRequestsProvider).value!;
            NewOrderRoute(deliveryRequest.id).go(context);
          },
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: UnconstrainedBox(
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Lottie.asset(
                    'assets/animations/new_order_animation.json',
                    width: 666,
                    height: 666,
                    addRepaintBoundary: true,
                    fit: BoxFit.fill),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
