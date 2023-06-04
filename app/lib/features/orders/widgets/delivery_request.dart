import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/routes.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class DeliveryRequest extends ConsumerWidget {
  const DeliveryRequest({
    super.key,
    required this.order,
    this.height = 48,
  });
  final double height;
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        NewOrderRoute(order.id).go(context);
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: superfleetBlue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(width: 12),
          Text('Delivery Request',
              style: context.text14w700.copyWith(color: Colors.white)),
          const Expanded(child: SizedBox()),
          Icon(
            SuperIcons.watchlater,
            color: Colors.white.withAlpha(122),
            size: 20,
          ),
          const SizedBox(width: 6),
          Text('00:45',
              style: context.text14w700.copyWith(color: Colors.white)),
          const SizedBox(width: 12)
        ]),
      ),
    );
  }
}
