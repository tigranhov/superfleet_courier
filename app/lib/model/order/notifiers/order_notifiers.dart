import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/features/transports/logic/selected_transport_provider.dart';
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

  Future<void> addProgress({bool delivered = false}) async {
    state = await AsyncValue.guard(() async {
      final api = ref.watch(apiProvider);
      final selectedTransport =
          await ref.watch(selectedTransportProvider.future);
      final response = await api.patch('/orders/$id', data: {
        'orderProgress': state.value!.orderProgress + 1,
        if (delivered) 'status': OrderStatus.delivered.toString(),
        if (delivered) 'transport': selectedTransport.key
      });

      ref.invalidate(ordersNotifierProvider(status: OrderStatus.inProcess));
      return Order.fromJson(response.data['data']);
    });
  }
}
