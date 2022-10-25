import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfleet_courier/model/courier.dart';
import 'package:superfleet_courier/model/location.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  factory Order(
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
    return copyWith();
    final List<FromLocation> newFrom = [];
    for (final i in from) {
      newFrom.add(await i.updateLocation(geocoder));
    }
    final newTo = await to.updateLocation(geocoder);

    return copyWith(from: newFrom, to: newTo);
  }
}
