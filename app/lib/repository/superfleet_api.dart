import '../model/model.dart';

mixin SuperfleetAPI {
  Future<Courier> getCourier();
  Future<Courier> updateCourierStatus(
      {required Courier courier, required String status});
  Future<List<Order>> getOrders(
      {required int courierId, int? offset, int? limit});
  Future<Courier> login(String email, String password);
}
