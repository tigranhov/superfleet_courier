import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/model/api.dart';
import 'package:superfleet_courier/model/courier.dart';
import 'package:superfleet_courier/model/location.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order(
      {required int id,
      String? status,
      Courier? courier,
      required ToLocation to,
      required List<FromLocation> from,
      DateTime? deliverUntil,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt}) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

extension YandexOrderLocationUpdate on Order {
  Future<Order> updateLocation(YandexGeocoder geocoder) async {
    return copyWith(); //TODO
    final List<FromLocation> newFrom = [];
    for (final i in from) {
      newFrom.add(await i.updateLocation(geocoder));
    }
    final newTo = await to.updateLocation(geocoder);

    return copyWith(from: newFrom, to: newTo);
  }
}

@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  @override
  Future<List<Order>> build({int? offset, int? limit}) async {
    // final DotEnv dotEnv = DotEnv();
    // await dotEnv.load();
    // final geocoder = ygc.YandexGeocoder(apiKey: dotEnv.env['YANDEX_KEY']!);

    final courier = await ref.watch(courierNotifierProvider.future);

    final queryParams = <String, dynamic>{};
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
        return Order.fromJson(e);
      },
    ).toList());
  }
}
