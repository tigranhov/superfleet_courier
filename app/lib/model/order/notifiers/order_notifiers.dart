import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/model/api.dart';

import '../../courier_notifier.dart';
import '../order.dart';
import '../order_status.dart';

part 'order_notifiers.g.dart';

@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  @override
  Future<List<Order>> build(
      {required OrderStatus status, int? offset, int? limit}) async {
    final courier = await ref.watch(courierNotifierProvider.future);

    final queryParams = <String, dynamic>{
      'status': status.toString(),
    };
    if (offset != null) queryParams['offset'] = offset;
    if (limit != null) queryParams['limit'] = limit;
    final dio = ref.watch(apiProvider);

    final response = await dio.get(
      '/orders/courier/${courier!.id}',
      queryParameters: queryParams,
    );
    final List result = response.data['data']['items'];
    return Future.wait(result.map(
      (e) async {
        final order = Order.fromJson(e);
        return order;
      },
    ).toList());
  }
}

@riverpod
class OrderByIdNotifier extends _$OrderByIdNotifier {
  @override
  Future<Order> build(int id) async {
    final dio = ref.watch(apiProvider);
    final response = await dio.get('/orders/$id');
    final result = response.data['data'];
    return Order.fromJson(result);
  }

  addProgress() async {
    state = await AsyncValue.guard(() async {
      final api = ref.watch(apiProvider);
      await api.patch('/orders/$id',
          data: {'orderProgress': state.value!.orderProgress + 1});
      ref.invalidateSelf();
      ref.invalidate(ordersNotifierProvider);
      return state.value!
          .copyWith(orderProgress: state.value!.orderProgress + 1);
    });
  }
}
