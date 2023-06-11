import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/model/order/notifiers/order_notifiers.dart';
import 'package:superfleet_courier/model/order/order.dart';
import 'package:superfleet_courier/model/order/order_status.dart';
import 'package:collection/collection.dart';
part 'history_notifier.g.dart';

@riverpod
class HistoryNotifier extends _$HistoryNotifier {
  @override
  FutureOr<List<Order>> build() {
    final orders =
        ref.watch(ordersNotifierProvider(status: OrderStatus.delivered).future);
    return orders;
  }
}

@riverpod
Future<Map<DateTime?, List<Order>>> historyGrouped(
    HistoryGroupedRef ref) async {
  final items = await ref.watch(historyNotifierProvider.future);
  final groupedItems = groupBy(items, (item) {
    final deliverUntil = item.deliverUntil;
    if (deliverUntil == null) return null;
    return DateTime(deliverUntil.year, deliverUntil.month, deliverUntil.day);
  });
  return groupedItems;
}
