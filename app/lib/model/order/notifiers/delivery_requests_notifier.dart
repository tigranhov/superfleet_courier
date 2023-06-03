import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../order.dart';

part 'delivery_requests_notifier.g.dart';

@riverpod
class DeliveryRequests extends _$DeliveryRequests {
  Timer? _timer;

  @override
  List<Order> build() {
    ref.onAddListener(() {
      _timer ??= Timer.periodic(const Duration(seconds: 5), (timer) {
        updateState();
      });
    });
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    return [];
  }

  updateState() {}
}
