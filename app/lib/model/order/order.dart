import 'dart:async';

import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/model/api.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../courier_notifier.dart';

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

  Location? activeLocation() {
    final index = activeLocationIndex();
    if (index < 0) return null;
    if (index >= from.length) return to;

    return from[index];
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

