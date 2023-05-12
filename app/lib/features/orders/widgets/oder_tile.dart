import 'package:flutter/material.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:intl/intl.dart' as intl;
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
              isNew: true,
            ), //TODO use actual value
            const Divider(height: 0),
            ...order.from.map((e) => AddressItem(
                address: e.location?.addressString() ?? 'No Address',
                isPickup: true,
                time: formatDate(e.availableFrom))),
            AddressItem(
              address: order.to.location?.addressString() ?? 'No Address',
              isPickup: false,
              time: formatDate(order.deliverUntil),
              drawLine: false,
            ),
            const SizedBox(height: 16)
          ],
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
