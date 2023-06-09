import 'package:dio/dio.dart';

import '../model.dart';

class DioMock extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
   
    final path = options.path;
    if (!loggedin && path != '/auth/login') {
      handler.reject(
          DioError(
            requestOptions: options,
            response: Response(statusCode: 401, requestOptions: options),
          ),
          true);
      return;
    }
    for (final adapter in _adapters) {
      if (adapter.matchPath(path)) {
        handler.resolve(adapter.resolve(options));
        return;
      }
    }
    throw Exception('No adapter found for $path');
  }
}

final _adapters = [
  _MeAdapter(),
  _OrderAdapter(),
  _CourierAdapter(),
  _LoginAdaptor()
];

abstract class _MockAdapter {
  String get path;
  resolve(RequestOptions requestOptions);

  bool matchPath(String requestPath) {
    return requestPath.contains(path);
  }
}

class _LoginAdaptor extends _MockAdapter {
  @override
  String get path => '/auth/login';

  @override
  resolve(RequestOptions requestOptions) {
    loggedin = true;
    return Response(requestOptions: requestOptions, data: {
      'data': {'accessToken': 'saf', 'refreshToken': 'dsaf'}
    });
  }
}

class _MeAdapter extends _MockAdapter {
  @override
  Response resolve(RequestOptions requestOptions) {
    return Response(
      requestOptions: requestOptions,
      data: {'data': courier.toJson()},
    );
  }

  @override
  String get path => '/auth/me';
}

class _CourierAdapter extends _MockAdapter {
  @override
  String get path => '/couriers/17';

  @override
  resolve(RequestOptions requestOptions) {
    if (requestOptions.method == 'PATCH') {
      final data = requestOptions.data;
      courier = Courier.fromJson(courier.toJson()..addAll(data));
      return Response(
          requestOptions: requestOptions, data: {'data': courier.toJson()});
    } else {
      return Response(
          requestOptions: requestOptions, data: {'data': courier.toJson()});
    }
  }
}

class _OrderAdapter extends _MockAdapter {
  @override
  String get path => '/orders';

  @override
  resolve(RequestOptions requestOptions) {
    if (requestOptions.uri.pathSegments.length == 3) {
      final queryParameters = requestOptions.queryParameters;
      final status = queryParameters['status'];
      if (status == null) throw Exception('status is required');
      final ordersByStatus = orders.where((order) => order.status == status);
      return Response(requestOptions: requestOptions, data: {
        'data': {
          'items': ordersByStatus
              .map((order) => order.toJson())
              .toList(growable: false),
        },
        'meta': {}
      });
    } else {
      final id = int.parse(requestOptions.uri.pathSegments[1]);
      if (requestOptions.method == 'GET') {
        final order = orders.firstWhere((order) => order.id == id);
        return Response(
            requestOptions: requestOptions,
            data: {'data': order.toJson(), 'meta': {}});
      } else if (requestOptions.method == 'PATCH') {
        final order = orders.firstWhere((order) => order.id == id);
        final index = orders.indexOf(order);
        final orderJson = order.toJson()..addAll(requestOptions.data);
        orders[index] = Order.fromJson(orderJson);
        return Response(
            requestOptions: requestOptions,
            data: {'data': orderJson, 'meta': {}});
      }
    }
  }
}

bool loggedin = false;

var courier = const Courier(
  id: 17,
  firstName: 'Vaxo',
  lastName: 'Patverashvili',
  status: 'INACTIVE',
  transport: 'BIKE',
);

final orders = <Order>[];

// final orders = [
//   Order(
//       id: 1,
//       to: const ToLocation(id: 1, locationData: LocationData(lng: 40, lat: 44)),
//       from: const [
//         FromLocation(id: 1, locationData: LocationData(lng: 40, lat: 44))
//       ],
//       courier: courier,
//       deliverUntil: DateTime.now().add(const Duration(minutes: 30)),
//       status: OrderStatus.inProcess.toString()),
//   Order(
//       id: 2,
//       to: const ToLocation(id: 2, locationData: LocationData(lng: 40, lat: 44)),
//       from: const [
//         FromLocation(id: 2, locationData: LocationData(lng: 40, lat: 44))
//       ],
//       courier: courier,
//       deliverUntil: DateTime.now().add(const Duration(minutes: 30)),
//       status: OrderStatus.inProcess.toString()),
//   Order(
//       id: 3,
//       to: const ToLocation(
//           id: 2, locationData: LocationData(lat: 40.185829, lng: 44.515078)),
//       from: const [
//         FromLocation(
//             id: 2, locationData: LocationData(lat: 40.172270, lng: 44.507051)),
//         FromLocation(
//             id: 2, locationData: LocationData(lat: 40.175533, lng: 44.505680))
//       ],
//       courier: courier,
//       deliverUntil: DateTime.now().add(const Duration(minutes: 30)),
//       status: OrderStatus.open.toString()),
// ];
