import 'dart:async';

import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/model/api.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'courier_notifier.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum OrderStatus {
  open,
  inProcess,
  delivered,
  cancelled;

  @override
  String toString() => switch (this) {
        open => 'OPEN',
        inProcess => 'IN_PROCESS',
        delivered => 'DELIVERED',
        cancelled => 'CANCELLED',
      };
}

@freezed
class Order with _$Order {
  const Order._();
  const factory Order(
      {required int id,
      String? status,
      Courier? courier,
      required ToLocation to,
      required List<FromLocation> from,
      DateTime? deliverUntil,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      @Default(0) int orderProgress}) = _Order;

  int locationIndex(Location location) {
    if (location is ToLocation) {
      return from.length;
    }
    return from.indexWhere((element) => element == location);
  }

  int activeLocationIndex() {
    if (orderProgress < 2) return -1;
    final index = (orderProgress - 2) ~/ 3;

    return index;
  }

  Location? activeLocation() {
    final index = activeLocationIndex();
    if (index < 0) return null;
    if (index >= from.length) return to;

    return from[index];
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

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
        return order.copyWith(
          from: [
            // FromLocation(
            //     location: const Location(
            //         street: "Alikhanyan brothers street", house: '1'),
            //     availableFrom: DateTime.now().add(const Duration(minutes: 40))),
            FromLocation(
                locationData: const LocationData(
                    street: "Alikhanyan brothers street", house: '2'),
                availableFrom: DateTime.now().add(const Duration(minutes: 50))),
            FromLocation(
                locationData: const LocationData(
                    street:
                        "Some other street, where the street is a streeet by the side of another street",
                    house: '4'),
                availableFrom: DateTime.now().add(const Duration(minutes: 50))),
          ],
          to: const ToLocation(
            locationData:
                LocationData(street: "Bagrevand 1st deadlock", house: '2'),
          ),
          deliverUntil: DateTime.now().add(const Duration(hours: 1)),
        );
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
    return Order.fromJson(result).copyWith(
      from: [
        // FromLocation(
        //     location: const Location(
        //         street: "Alikhanyan brothers street", house: '1'),
        //     availableFrom: DateTime.now().add(const Duration(minutes: 40))),
        FromLocation(
            locationData: const LocationData(
                street: "Alikhanyan brothers street", house: '2'),
            availableFrom: DateTime.now().add(const Duration(minutes: 50))),
        FromLocation(
            locationData: const LocationData(
                street:
                    "Some other street, where the street is a streeet by the side of another street",
                house: '4'),
            availableFrom: DateTime.now().add(const Duration(minutes: 50))),
      ],
      to: const ToLocation(
        locationData:
            LocationData(street: "Bagrevand 1st deadlock", house: '2'),
      ),
    );
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

@riverpod
class NewOrders extends _$NewOrders {
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
