import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:superfleet_courier/model/courier.dart';
import 'package:superfleet_courier/model/order.dart';
import 'package:superfleet_courier/repository/superfleet_api.dart';

class MockRepository implements SuperfleetAPI {
  final storage = GetStorage();
  Courier? courier;
  @override
  Future<Courier> getCourier() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return courier = Courier(
        id: 12,
        firstName: 'Tigran',
        lastName: 'Hovhannisyan',
        transport: 'Car',
        status: 'ACTIVE');
  }

  @override
  Future<List<Order>> getOrders() async {
    final ordersJsonString = storage.read('orders');
    if (ordersJsonString == null) return [];
    final List<Order> orders = (ordersJsonString as List<String>).map((e) {
      return Order.fromJson(jsonDecode(e));
    }).toList();
    return orders;
  }

  @override
  Future<Courier> updateCourierStatus({required String status}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return courier!.copyWith(status: status);
  }
}
