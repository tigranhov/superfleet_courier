// import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:superfleet_courier/model/courier.dart';
// import 'package:superfleet_courier/model/order.dart';
// import 'package:superfleet_courier/repository/superfleet_api.dart';
// import 'package:yandex_geocoder/yandex_geocoder.dart' as ygc;
//
// mixin Api {
//   Dio get dio;
//
//   Future<List<Order>> getOrdersForCourier(
//       {required int courierId, int? offset, int? limit}) async {
//     final DotEnv dotEnv = DotEnv();
//     await dotEnv.load();
//     final geocoder = ygc.YandexGeocoder(apiKey: dotEnv.env['YANDEX_KEY']!);
//
//     final queryParams = <String, dynamic>{};
//     if (offset != null) queryParams['offset'] = offset;
//     if (limit != null) queryParams['limit'] = limit;
//
//     final response = await dio.get('/orders', queryParameters: queryParams);
//     final List result = response.data['data']['items'];
//     return Future.wait(result.map(
//       (e) async {
//         return Order.fromJson(e).updateLocation(geocoder);
//       },
//     ).toList());
//   }
//
//   Future<Courier> getCourier({required int id}) async {
//     final response = await dio.get('/couriers/$id');
//     return Courier.fromJson(response.data['data']);
//   }
//
//   Future<Courier> updateCourierStatus(
//       {required int id, required String status}) async {
//     final response = await dio.patch('/couriers/$id', data: {'status': status});
//     return Courier.fromJson(response.data['data']);
//   }
// }
//
// class SuperfleetRepository with SuperfleetAPI {
//   final _secureStorage = SharedPreferences.getInstance();
//   final Dio dio = Dio(BaseOptions(
//     baseUrl: 'https://api-new.superfleet.ai',
//   ));
//
//   String _accessToken = '';
//   int _refreshRetries = 0;
//
//   SuperfleetRepository() {
//     dio.interceptors.add(PrettyDioLogger(
//         requestHeader: false,
//         requestBody: false,
//         responseBody: false,
//         responseHeader: false,
//         error: true,
//         compact: true,
//         maxWidth: 90));
//
//     dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
//       options.headers['Authorization'] = 'Bearer $_accessToken';
//       handler.next(options);
//     }, onError: (error, handler) async {
//       if (_refreshRetries > 0) {
//         _refreshRetries = 0;
//         handler.next(DioError(requestOptions: error.requestOptions));
//       } else if (error.response?.statusCode == 403 ||
//           error.response?.statusCode == 401) {
//         try {
//           _refreshRetries++;
//           await refreshAccessToken();
//
//           final result = await _retry(error.requestOptions);
//           handler.resolve(result);
//           _refreshRetries = 0;
//         } catch (error) {
//           handler.next(error as DioError);
//         }
//       } else {
//         handler.next(error);
//       }
//     }));
//   }
//
//   Future<void> refreshAccessToken() async {
//     final refreshToken = (await _secureStorage).getString('refreshToken');
//     final response = await dio
//         .post('/auth/refresh-token', data: {'refreshToken': refreshToken});
//
//     if (response.statusCode == 200) {
//       await (await _secureStorage)
//           .setString('accessToken', response.data['data']['accessToken']);
//       await (await _secureStorage)
//           .setString('refreshToken', response.data['data']['refreshToken']);
//       _accessToken = response.data['data']['accessToken'];
//     } else {
//       throw Exception('Failed to refresh access token');
//     }
//   }
//
// //TODO delete
//   Future<String> token() async {
//     final token = (await _secureStorage).getString('accessToken');
//     if (token != null) _accessToken = token;
//     return _accessToken;
//   }
//
//   Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
//     final options = Options(
//       method: requestOptions.method,
//       headers: requestOptions.headers,
//     );
//     return dio.request<dynamic>(requestOptions.path,
//         data: requestOptions.data,
//         queryParameters: requestOptions.queryParameters,
//         options: options);
//   }
//
//   @override
//   Future<Courier> getCourier() async {
//     final token = (await _secureStorage).getString('accessToken');
//     if (token != null) _accessToken = token;
//
//     final response = await dio.get('/auth/me');
//
//     return Courier.fromJson(response.data['data']);
//   }
//
//   @override
//   Future<Courier> login(String username, String password) async {
//     final response = await dio.post('/auth/login',
//         data: {
//           'username': username,
//           'password': password,
//         },
//         options: Options(headers: {'x-login-type': 'COURIER'}));
//
//     await (await _secureStorage)
//         .setString('accessToken', response.data['data']['accessToken']);
//     await (await _secureStorage)
//         .setString('refreshToken', response.data['data']['refreshToken']);
//     return getCourier();
//   }
//
//   @override
//   Future<List<Order>> getOrders(
//       {required int courierId, int? offset, int? limit}) async {
//     final DotEnv dotEnv = DotEnv();
//     await dotEnv.load();
//     final geocoder = ygc.YandexGeocoder(apiKey: dotEnv.env['YANDEX_KEY']!);
//
//     final queryParams = <String, dynamic>{};
//     if (offset != null) queryParams['offset'] = offset;
//     if (limit != null) queryParams['limit'] = limit;
//
//     final response = await dio.get('/orders', queryParameters: queryParams);
//     final List result = response.data['data']['items'];
//     return Future.wait(result.map(
//       (e) async {
//         return Order.fromJson(e).updateLocation(geocoder);
//       },
//     ).toList());
//   }
//
//   @override
//   Future<Courier> updateCourierStatus(
//       {required Courier courier, required String status}) async {
//     final response =
//         await dio.patch('/couriers/${courier.id}}', data: {'status': status});
//     return Courier.fromJson(response.data['data']);
//   }
// }
