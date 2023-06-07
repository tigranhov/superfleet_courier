import 'package:freezed_annotation/freezed_annotation.dart';
part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class Location with _$Location {
  static const String locationStatePickedUp = 'goingTo';
  static const String locationStateDelivered = 'reached';
  static const String locationStateNotPickedUp = 'completed';
  const Location._();

  const factory Location.to({
    int? id,
    LocationData? locationData,
    String? locationState,
  }) = ToLocation;

  const factory Location.from(
      {int? id,
      LocationData? locationData,
      String? locationState,
      bool? pickedUp,
      DateTime? availableFrom}) = FromLocation;

  String addressString() {
    return [
      locationData?.name,
      locationData?.address,
      locationData?.country,
      locationData?.province,
      locationData?.locality,
      locationData?.street,
      locationData?.house,
    ].where((element) => element != null).join(', ');
  }

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@freezed
class LocationData with _$LocationData {
  const LocationData._();
  const factory LocationData({
    String? name,
    String? address,
    String? country,
    String? province,
    String? locality,
    String? provider,
    String? street,
    String? house,
    required double lat,
    required double lng,
    double? alt,
  }) = _LocationData;

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);
}

//
// extension YandexLocationUpdate on Location {
//   Future<Location> updateLocation(YandexGeocoder geocoder) async {
//     final GeocodeResponse geocodeFromPoint =
//         await geocoder.getGeocode(GeocodeRequest(
//       geocode: PointGeocode(latitude: lat!, longitude: lng!),
//       lang: Lang.enEn,
//     ));
//     final firstAddress = geocodeFromPoint.firstAddress;
//     if (firstAddress == null) return copyWith();
//     final components = firstAddress.components;
//     if (components == null) return copyWith();
//     Location location = copyWith();
//     for (var value in components) {
//       switch (value.kind) {
//         case KindResponse.house:
//           location = location.copyWith(house: value.name);
//           break;
//         case KindResponse.street:
//           location = location.copyWith(street: value.name);
//           break;
//         case KindResponse.locality:
//           location = location.copyWith(locality: value.name);
//           break;
//         case KindResponse.country:
//           location = location.copyWith(country: value.name);
//           break;
//         case KindResponse.province:
//           location = location.copyWith(province: value.name);
//           break;
//         default:
//           break;
//       }
//     }
//     return location;
//   }
// }
//
// extension YandexToLocationUpdate on ToLocation {
//   Future<ToLocation> updateLocation(YandexGeocoder geocoder) async {
//     return copyWith(location: await location!.updateLocation(geocoder));
//   }
// }
//
// extension YandexFromLocationUpdate on FromLocation {
//   Future<FromLocation> updateLocation(YandexGeocoder geocoder) async {
//     return copyWith(location: await location!.updateLocation(geocoder));
//   }
// }
