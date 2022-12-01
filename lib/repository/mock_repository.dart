import 'package:superfleet_courier/model/courier.dart';
import 'package:superfleet_courier/model/order.dart';
import 'package:superfleet_courier/repository/superfleet_api.dart';

class MockRepository implements SuperfleetAPI {
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
  Future<List<Order>> getOrders() {
    // TODO: implement getOrders
    throw UnimplementedError();
  }

  @override
  Future<Courier> updateCourierStatus({required String status}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return courier!.copyWith(status: status);
  }
}
