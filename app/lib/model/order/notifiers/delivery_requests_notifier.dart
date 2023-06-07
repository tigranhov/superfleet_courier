import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/model/interceptors/mock_interceptor.dart';
import 'package:superfleet_courier/model/model.dart';
import 'order_notifiers.dart';
part 'delivery_requests_notifier.g.dart';

@Riverpod(keepAlive: true)
class DeliveryRequests extends _$DeliveryRequests {
  Timer? _timer;

  @override
  Future<Order?> build() async {
    ref.onAddListener(() {
      _timer ??= Timer.periodic(const Duration(seconds: 5), (timer) {
        updateState();
      });
    });
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    updateState();
    return null;
  }

  updateState() async {
    state = await AsyncValue.guard(() async {
      final orders = await ref
          .read(ordersNotifierProvider(status: OrderStatus.open).future);
      return orders.firstOrNull;
    });
  }

  accept() async {
    state = await AsyncValue.guard(() async {
      //TODO actual implementation instead of mock
      orders[0] = orders[0].copyWith(status: OrderStatus.inProcess.toString());
      ref.invalidate(ordersNotifierProvider(status: OrderStatus.inProcess));
      return null;
    });
  }

  reject() async {
    state = await AsyncValue.guard(() async {
      //TODO actual implementation instead of mock
      orders.clear();
      return null;
    });
  }
}
