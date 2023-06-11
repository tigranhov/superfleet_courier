import 'package:superfleet_courier/model/model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const Order._();
  const factory Order(
      {required int id,
      String? status,
      Courier? courier,
      required ToLocation to,
      required List<FromLocation> from,
      DateTime? deliverUntil,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      DateTime? canAcceptUntil,
      String? transport,
      @Default(0) int orderProgress}) = _Order;

  int locationIndex(Location location) {
    if (location is ToLocation) {
      return from.length;
    }
    return from.indexWhere((element) => element == location);
  }

  int activeLocationIndex() {
    if (orderProgress < 2) return -1;
    final index = (orderProgress - 2) ~/ 3;

    return index;
  }

  int remainingTime() {
    if(canAcceptUntil == null) return 0;
    final now = DateTime.now();
    final difference = canAcceptUntil!.difference(now);
    if (difference.isNegative) return 0;
    return (difference.inMilliseconds / 1000).round();
  }

  Location? activeLocation() {
    final index = activeLocationIndex();
    if (index < 0) return null;
    if (index >= from.length) return to;

    return from[index];
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

