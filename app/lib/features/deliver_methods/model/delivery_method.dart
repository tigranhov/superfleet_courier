import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_method.freezed.dart';

@freezed
class DeliveryMethod with _$DeliveryMethod {
  const DeliveryMethod._();
  const factory DeliveryMethod.car() = _Car;
  const factory DeliveryMethod.bicycle() = _Bicycle;
  const factory DeliveryMethod.foot() = _Foot;

  @override
  String toString() {
    return when(car: () => 'Car', bicycle: () => 'Bicycle', foot: () => 'Foot');
  }

  static DeliveryMethod fromString(String method) {
    switch (method.toLowerCase()) {
      case 'car':
        return const DeliveryMethod.car();
      case 'bicycle':
        return const DeliveryMethod.bicycle();
      case 'foot':
        return const DeliveryMethod.foot();
      default:
        throw ArgumentError.value(method, 'method', 'Unknown delivery method');
    }
  }
}
