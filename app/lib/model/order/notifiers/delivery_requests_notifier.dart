import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/model/model.dart';
import 'order_notifiers.dart';
part 'delivery_requests_notifier.g.dart';

@riverpod
class DeliveryRequests extends _$DeliveryRequests {
  Timer? _timer;

  @override
  Future<List<Order>> build() async {
    ref.onAddListener(() {
      _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
        updateState();
      });
    });
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    return [];
  }

  updateState() async {
    state = await AsyncValue.guard(() async {
      return await ref
          .read(ordersNotifierProvider(status: OrderStatus.open).future);
    });
  }
}
