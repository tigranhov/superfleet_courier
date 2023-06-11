import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:superfleet_courier/features/transports/model/transport.dart';
import 'package:superfleet_courier/model/order/order.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/cards/sf_card.dart';
import 'package:superfleet_courier/widgets/transport_icon.dart';

final _format = DateFormat('hh:mm a');

class HistoryOrderCard extends StatelessWidget {
  const HistoryOrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return SFCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
          child: Text(
            '#${order.id}',
            style:
                context.text14w700.copyWith(color: Colors.black.withAlpha(122)),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 12, bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.to.addressString(),
                      style: context.text16w700,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                    Text(_format.format(order.deliverUntil!),
                        style: context.text16w700
                            .copyWith(color: Colors.black.withAlpha(122))),
                  ],
                ),
              ),
              SizedBox(
                  width: 36,
                  height: 36,
                  child: FittedBox(
                      child: TransportIcon(
                          icon: Transport.fromString(order.transport!).icon))),
              const SizedBox(width: 12),
            ],
          ),
        )
      ],
    ));
  }
}
