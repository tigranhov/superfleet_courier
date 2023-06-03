import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:superfleet_courier/model/courier.dart';
import 'package:superfleet_courier/model/order/order.dart';
import 'package:superfleet_courier/repository/superfleet_api.dart';

class MockRepository implements SuperfleetAPI {
  final storage = GetStorage();
  bool isLoggedIn = false;
  @override
  Future<Courier> getCourier() async {
    if (isLoggedIn) {
      await Future.delayed(const Duration(milliseconds: 50));
      return storage.read('courier');
    }
    throw DioError(
        type: DioErrorType.badResponse,
        requestOptions: RequestOptions(path: '/courier'),
        response: Response(
            requestOptions: RequestOptions(path: '/courier'),
            data: {'message': 'Unauthorized'},
            statusCode: 401));
  }

  @override
  Future<List<Order>> getOrders(
      {required int courierId, int? offset, int? limit}) async {
    if (isLoggedIn) {
      await Future.delayed(const Duration(milliseconds: 50));
      return storage.read('orders') ?? [];
    }
    throw DioError(
        type: DioErrorType.badResponse,
        requestOptions: RequestOptions(path: '/courier'),
        response: Response(
            requestOptions: RequestOptions(path: '/courier'),
            data: {'message': 'Unauthorized'},
            statusCode: 401));
  }

  @override
  Future<Courier> login(String email, String password) async {
    if (email == 'kalbas@gmail.com' && password == '123456') {
      isLoggedIn = true;
      final courier = Courier(
          id: 1,
          status: 'ACTIVE',
          firstName: 'Kalbas',
          lastName: 'Kalbaitis',
          transport: "Car",
          email: 'kalbas@gmail.com');
      storage.write('courier', courier);
      return courier;
    } else {
      throw DioError(
          type: DioErrorType.badResponse,
          requestOptions: RequestOptions(path: '/login'),
          response: Response(
              requestOptions: RequestOptions(path: '/login'),
              data: {'message': 'Invalid credentials'},
              statusCode: 401));
    }
  }

  @override
  Future<Courier> updateCourierStatus(
      {required Courier courier, required String status}) async {
    final newCourier = courier.copyWith(status: status);
    storage.write('courier', newCourier);
    return newCourier;
  }
}
