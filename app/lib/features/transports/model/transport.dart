import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfleet_courier/super_icons_icons.dart';

part 'transport.freezed.dart';

@freezed
class Transport with _$Transport {
  const Transport._();
  const factory Transport.car() = _Car;
  const factory Transport.bike() = _Bike;
  const factory Transport.walk() = _Walk;

  @override
  String toString() {
    return when(car: () => 'Car', bike: () => 'Bicycle', walk: () => 'Foot');
  }

  IconData get icon => when(
      bike: () => SuperIcons.bycicle,
      car: () => SuperIcons.car,
      walk: () => SuperIcons.person);

  String get key =>
      when(car: () => 'CAR', bike: () => 'BIKE', walk: () => 'WALK');

  static Transport fromString(String method) {
    switch (method) {
      case 'CAR':
        return const Transport.car();
      case 'BIKE':
        return const Transport.bike();
      case 'WALK':
        return const Transport.walk();
      default:
        throw ArgumentError.value(method, 'method', 'Unknown delivery method');
    }
  }
}
