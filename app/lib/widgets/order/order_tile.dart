import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:superfleet_courier/model/order.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

import 'address_item.dart';

class OrderTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final width = this.width;
    return GestureDetector(
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
            ),
            const Divider(height: 0),
            ...order.from.map((e) => AdressItem(
                address: e.location?.addressString() ?? 'No Address',
                isPickup: true,
                time: formatDate(e.availableFrom))),
            AdressItem(
              address: order.to.location?.addressString() ?? 'No Address',
              isPickup: false,
              time: formatDate(order.deliverUntil),
              drawLine: false,
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}

class _BeforeDivider extends StatelessWidget {
  const _BeforeDivider({Key? key, required this.status}) : super(key: key);
  final String status;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(status, style: context.text12w700grey),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '#123456789',
              style: context.text12w700grey,
            ),
          )
        ],
      ),
    );
  }
}
