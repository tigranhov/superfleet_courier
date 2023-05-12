import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/model/api.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    // final geocoder = YandexGeocoder(apiKey: 'cb2c60ca-b404-4d6b-8861-564645da5aa3');
    // geocoder.getGeocode(GeocodeRequest(
    //         geocode: PointGeocode(latitude: 40, longitude: 40),
    //         lang: Lang.enEn));
    // final r = await geocoder.getGeocode(GeocodeRequest(
    //     geocode: PointGeocode(latitude: 40, longitude: 40), lang: Lang.enEn));
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
        final order = Order.fromJson(e);
        return order.copyWith(
          from: [
            // FromLocation(
            //     location: const Location(
            //         street: "Alikhanyan brothers street", house: '1'),
            //     availableFrom: DateTime.now().add(const Duration(minutes: 40))),
            FromLocation(
                location: const Location(
                    street: "Alikhanyan brothers street, qebab party street",
                    house: '2'),
                availableFrom: DateTime.now().add(const Duration(minutes: 50))),
          ],
          to: const ToLocation(
            location: Location(street: "Bagrevand 1st deadlock", house: '2'),
          ),
          deliverUntil: DateTime.now().add(const Duration(hours: 1)),
        );
      },
    ).toList());
  }
}
