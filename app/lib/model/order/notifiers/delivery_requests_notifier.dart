import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/model/interceptors/mock_interceptor.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/utilities/time_utils.dart';
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

@riverpod
Future<int> deliveryRequestRemainingTime(
    DeliveryRequestRemainingTimeRef ref) async {
  final deliveryRequest = await ref.watch(deliveryRequestsProvider.future);
  final remainingTime = deliveryRequest?.remainingTime() ?? 0;
  if (remainingTime > 0) {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      ref.invalidateSelf();
    });
  }
  ref.onDispose(() {
    print('disposed');
  });
  return remainingTime;
}

@riverpod
class DeliveryRequestRemainingTimePercentage
    extends _$DeliveryRequestRemainingTimePercentage {
  double _totalTime = -1;
  @override
  Future<double> build() async {
    final remainingTime =
        ref.watch(deliveryRequestRemainingTimeProvider).value?.toDouble() ??
            0.0;

    if (_totalTime < 0 && remainingTime > 0) _totalTime = remainingTime;
    if (_totalTime > 0.01) return (_totalTime - remainingTime) / _totalTime;
    return 1.0;
  }
}

extension DeliveryRequestNotifierExtension on AsyncValue<int> {
  String toMMSS() => when(
        data: (value) => value.toMMSS(),
        loading: () => '00:00',
        error: (err, stack) => 'error',
      );
}
