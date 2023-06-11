import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/home/tabs/history/domain/history_notifier.dart';
import 'package:superfleet_courier/features/home/tabs/history/widgets/history_date_tile.dart';
import 'package:superfleet_courier/features/home/tabs/history/widgets/history_order_card.dart';
import 'package:superfleet_courier/features/home/tabs/history/widgets/total_orders_count.dart';
import 'package:superfleet_courier/model/order/order.dart';

class HistoryOrderList extends ConsumerWidget {
  const HistoryOrderList({super.key, this.onOrderSelected});

  final Function(Order order)? onOrderSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedOrders = ref.watch(historyGroupedProvider).valueOrNull;

    if (groupedOrders == null) return const SizedBox.shrink();

    return Column(
      children: [
        const TotalOrdersCount(),
        Expanded(
          child: ListView.builder(
            itemCount: groupedOrders.length,
            itemBuilder: (context, index) {
              final entry = groupedOrders.entries.elementAt(index);
              final date = entry.key;
              final orders = entry.value;
              return Column(
                children: [
                  HistoryDateTile(
                    date: date,
                    margin: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onOrderSelected?.call(order),
                            child: HistoryOrderCard(order: order));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 12,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
