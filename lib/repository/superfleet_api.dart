import '../model/model.dart';

mixin SuperfleetAPI {
  Future<Courier?> getCourier();
  Future<Courier> updateCourierStatus({required String status});
  Future<List<Order>> getOrders();
}
