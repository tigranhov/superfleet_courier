import 'package:dio/dio.dart';

import 'model.dart';
import 'order/order_status.dart';


class DioMock extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    for (final adapter in _adapters) {
      if (adapter.matchPath(path)) {
        handler.resolve(adapter.resolve(options));
        return;
      }
    }
    throw Exception('No adapter found for $path');

    // super.onRequest(options, handler);
  }
}

// final map = {
//   '/auth/me': {
//     'data': {
//       'id': 17,
//       'email': "ketchup@gmail.com",
//       'roles': ['USER'],
//       'isAccountDisabled': false,
//       'firstName': "Vaxo",
//       'lastName': "Patveryan",
//       'profileImageId': null,
//       'status': "ACTIVE",
//       'transport': "CAR",
//       'location': {
//         'name': "string",
//         'address': "string",
//         'country': "string",
//         'province': "string",
//         'locality': "string",
//         'provider': "string",
//         'street': "string",
//         'house': "string",
//         'lat': 40.176926,
//         'lng': 44.49703,
//         'alt': 0
//       },
//       'createdAt': "2022-12-02T18:57:54.481Z",
//       'updatedAt': "2023-05-15T22:48:02.305Z",
//       'deletedAt': null
//     },
//     'meta': {}
//   },
//   '/orders/courier/17': jsonDecode('''{
//     "data": {
//         "items": [
//             {
//                 "id": 15,
//                 "status": "OPEN",
//                 "courier": {
//                     "id": 17,
//                     "email": "ketchup@gmail.com",
//                     "roles": [
//                         "USER"
//                     ],
//                     "isAccountDisabled": false,
//                     "firstName": "Vaxo",
//                     "lastName": "Patveryan",
//                     "profileImageId": null,
//                     "status": "ACTIVE",
//                     "transport": "CAR",
//                     "location": {
//                         "name": "string",
//                         "address": "string",
//                         "country": "string",
//                         "province": "string",
//                         "locality": "string",
//                         "provider": "string",
//                         "street": "string",
//                         "house": "string",
//                         "lat": 40.176926,
//                         "lng": 44.49703,
//                         "alt": 0
//                     },
//                     "createdAt": "2022-12-02T18:57:54.481Z",
//                     "updatedAt": "2023-05-15T22:48:02.305Z",
//                     "deletedAt": null
//                 },
//                 "from": [
//                     {
//                         "id": 17,
//                         "location": {
//                             "lat": 40.212747,
//                             "lng": 44.482767
//                         },
//                         "pickedUp": false,
//                         "availableFrom": "2022-09-21T08:27:41.089Z"
//                     }
//                 ],
//                 "to": {
//                     "id": 16,
//                     "location": {
//                         "lat": 40.13352007310614,
//                         "lng": 44.51439033471284
//                     }
//                 },
//                 "deliverUntil": "2022-09-21T08:27:41.089Z",
//                 "createdAt": "2022-09-21T08:31:29.084Z",
//                 "updatedAt": "2023-05-10T12:19:07.879Z",
//                 "deletedAt": null
//             },
//             {
//                 "id": 16,
//                 "status": "OPEN",
//                 "courier": {
//                     "id": 17,
//                     "email": "ketchup@gmail.com",
//                     "roles": [
//                         "USER"
//                     ],
//                     "isAccountDisabled": false,
//                     "firstName": "Vaxo",
//                     "lastName": "Patveryan",
//                     "profileImageId": null,
//                     "status": "ACTIVE",
//                     "transport": "CAR",
//                     "location": {
//                         "name": "string",
//                         "address": "string",
//                         "country": "string",
//                         "province": "string",
//                         "locality": "string",
//                         "provider": "string",
//                         "street": "string",
//                         "house": "string",
//                         "lat": 40.176926,
//                         "lng": 44.49703,
//                         "alt": 0
//                     },
//                     "createdAt": "2022-12-02T18:57:54.481Z",
//                     "updatedAt": "2023-05-15T22:48:02.305Z",
//                     "deletedAt": null
//                 },
//                 "from": [
//                     {
//                         "id": 18,
//                         "location": {
//                             "lat": 40.191105,
//                             "lng": 44.474889
//                         },
//                         "pickedUp": false,
//                         "availableFrom": "2022-10-20T05:32:28.195Z"
//                     }
//                 ],
//                 "to": {
//                     "id": 17,
//                     "location": {
//                         "lat": 40.19317650409632,
//                         "lng": 44.4900144191855
//                     }
//                 },
//                 "deliverUntil": "2022-10-20T05:32:28.195Z",
//                 "createdAt": "2022-10-20T05:33:27.190Z",
//                 "updatedAt": "2023-05-10T12:19:16.876Z",
//                 "deletedAt": null
//             }
//         ],
//         "offset": 0,
//         "limit": 100,
//         "totalItems": 2,
//         "moreItems": false
//     },
//     "meta": {}
// }'''),
//   '/orders/15': jsonDecode(
//       '''{"data":{"id":15,"status":"OPEN","courier":{"id":17,"email":"ketchup@gmail.com","roles":["USER"],"isAccountDisabled":false,"firstName":"Vaxo","lastName":"Patveryan","profileImageId":null,"status":"ACTIVE","transport":"CAR","location":{"name":"string","address":"string","country":"string","province":"string","locality":"string","provider":"string","street":"string","house":"string","lat":40.176926,"lng":44.49703,"alt":0},"createdAt":"2022-12-02T18:57:54.481Z","updatedAt":"2023-05-15T22:48:02.305Z","deletedAt":null},"from":[{"id":17,"location":{"lat":40.212747,"lng":44.482767},"pickedUp":false,"availableFrom":"2022-09-21T08:27:41.089Z"}],"to":{"id":16,"location":{"lat":40.13352007310614,"lng":44.51439033471284}},"deliverUntil":"2022-09-21T08:27:41.089Z","createdAt":"2022-09-21T08:31:29.084Z","updatedAt":"2023-05-10T12:19:07.879Z","deletedAt":null},"meta":{}}''')
// };

// export enum OrderStatus {
//   OPEN = 'OPEN',
//   IN_PROCESS = 'IN_PROCESS',
//   DELIVERED = 'DELIVERED',
//   CANCELLED = 'CANCELLED',
// }

final _adapters = [
  _MeAdapter(),
  _OrderAdapter(),
  _CourierAdapter()
];

abstract class _MockAdapter {
  String get path;
  resolve(RequestOptions requestOptions);

  bool matchPath(String requestPath) {
    return requestPath.contains(path);
  }
}

class _MeAdapter extends _MockAdapter {
  @override
  Response resolve(RequestOptions requestOptions) {
    return Response(
        requestOptions: requestOptions, data: {'data': courier.toJson()});
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

var courier = const Courier(
  id: 17,
  firstName: 'Vaxo',
  lastName: 'Patverashvili',
  status: 'ACTIVE',
  transport: 'CAR',
);

final orders = [
  Order(
      id: 1,
      to: const ToLocation(id: 1, locationData: LocationData(lng: 40, lat: 44)),
      from: const [
        FromLocation(id: 1, locationData: LocationData(lng: 40, lat: 44))
      ],
      courier: courier,
      deliverUntil: DateTime.now().add(const Duration(minutes: 30)),
      status: OrderStatus.inProcess.toString()),
  Order(
      id: 2,
      to: const ToLocation(id: 2, locationData: LocationData(lng: 40, lat: 44)),
      from: const [
        FromLocation(id: 2, locationData: LocationData(lng: 40, lat: 44))
      ],
      courier: courier,
      deliverUntil: DateTime.now().add(const Duration(minutes: 30)),
      status: OrderStatus.inProcess.toString()),
  Order(
      id: 2,
      to: const ToLocation(id: 2, locationData: LocationData(lng: 40, lat: 44)),
      from: const [
        FromLocation(id: 2, locationData: LocationData(lng: 40, lat: 44))
      ],
      courier: courier,
      deliverUntil: DateTime.now().add(const Duration(minutes: 30)),
      status: OrderStatus.open.toString()),
];
