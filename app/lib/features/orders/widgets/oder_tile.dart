import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/location_indicator.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/pulsing_border.dart';
import 'package:superfleet_courier/features/orders/widgets/order_view.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:superfleet_courier/theme/sf_theme.dart';

import '../domain/location_indicator_state.dart';
import 'address_item.dart';

class OrderTile extends HookConsumerWidget {
  const OrderTile(
      {super.key, this.width = 296, required this.order, required this.onTap});
  final double width;

  final Order order;

  final Function(Order order) onTap;
  String formatDate(DateTime? time) {
    if (time == null) return 'No Date';
    return intl.DateFormat.Hm().format(time).toString();
  }

  @override
  Widget build(BuildContext context, ref) {
    final width = this.width;
    final animationController = useAnimationController();
    return ProviderScope(
      overrides: [
        pulsingAnimationControllerProvider
            .overrideWith((ref) => animationController)
      ],
      child: GestureDetector(
        onTap: () => onTap(order),
        child: Container(
          constraints: BoxConstraints(minWidth: width),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 0.5, color: const Color(0xffCCCCCC)),
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(64, 0, 0, 0),
                  offset: Offset(0, 2),
                  blurRadius: 2,
                ),
              ]),
          child: Column(
            children: [
              _BeforeDivider(
                status: order.status ?? '!!No Status',
                isNew: true,
              ), //TODO use actual value
              const Divider(height: 0),
              const SizedBox(height: 18),
              OrderContent(order: order),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _BeforeDivider extends StatelessWidget {
  const _BeforeDivider({Key? key, required this.status, this.isNew = false})
      : super(key: key);
  final String status;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      width: double.infinity,
      child: Row(
        children: [
          const SizedBox(width: 12),
          Text(status, style: context.text14w700grey),
          if (isNew) ...[const SizedBox(width: 4), const _IsNewTag()],
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '#123456789',
              style: context.text14w700grey,
            ),
          )
        ],
      ),
    );
  }
}

class _IsNewTag extends StatelessWidget {
  const _IsNewTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47,
      height: 20,
      decoration: BoxDecoration(
        color: context.secondaryColor,
        borderRadius: BorderRadius.circular(37),
      ),
      alignment: Alignment.center,
      child: Text(
        'NEW',
        style: context.text14w700.copyWith(height: 1.3, color: Colors.white),
      ),
    );
  }
}
