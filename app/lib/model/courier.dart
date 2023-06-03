import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfleet_courier/model/location.dart';

part 'courier.freezed.dart';
part 'courier.g.dart';

@freezed
class Courier with _$Courier {
  const factory Courier(
      {required int id,
      required String firstName,
      required String lastName,
      String? profileImageId,
      String? status,
      String? transport,
      LocationData? location,
      String? email}) = _Courier2;

  factory Courier.fromJson(Map<String, dynamic> json) =>
      _$CourierFromJson(json);
}
