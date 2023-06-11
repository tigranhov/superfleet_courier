import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/home/tabs/history/domain/history_notifier.dart';
import 'package:superfleet_courier/features/home/tabs/history/widgets/history_order_list.dart';
import 'package:superfleet_courier/routes.dart';

import '../../widgets/no_content_view.dart';

//TODO orders should be listed by date, paginated and sorted
class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final orders = ref.watch(historyNotifierProvider);

    if (orders.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (orders.hasError) {
      return const Center(child: Text('Error'));
    }
    if (orders.value!.isEmpty) {
      return const NoContent(
        description: 'You don’t have any order history, yet',
        explanation: 'Order history will appear here once you complete one',
        icon: Icons.watch_later_outlined,
      );
    }
    return HistoryOrderList(
      onOrderSelected: (order) {
        OrderViewRoute(order.id).push(context);
      },
    );
  }
}
