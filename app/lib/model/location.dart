import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class Location with _$Location {
  const Location._();
  const factory Location({
    String? name,
    String? address,
    String? country,
    String? province,
    String? locality,
    String? provider,
    String? street,
    String? house,
    double? lat,
    double? lng,
    double? alt,
  }) = _Location;

  String addressString() {
    return '${street!}, ${house!}';
  }

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@freezed
class ToLocation with _$ToLocation {
  const factory ToLocation({
    int? id,
    Location? location,
  }) = _ToLocation;

  factory ToLocation.fromJson(Map<String, dynamic> json) =>
      _$ToLocationFromJson(json);
}

@freezed
class FromLocation with _$FromLocation {
  const factory FromLocation(
      {int? id,
      Location? location,
      bool? pickedUp,
      DateTime? availableFrom}) = _FromLocation;

  factory FromLocation.fromJson(Map<String, dynamic> json) =>
      _$FromLocationFromJson(json);
}

extension YandexLocationUpdate on Location {
  Future<Location> updateLocation(YandexGeocoder geocoder) async {
    final GeocodeResponse geocodeFromPoint =
        await geocoder.getGeocode(GeocodeRequest(
      geocode: PointGeocode(latitude: lat!, longitude: lng!),
      lang: Lang.enEn,
    ));
    final firstAddress = geocodeFromPoint.firstAddress;
    if (firstAddress == null) return copyWith();
    final components = firstAddress.components;
    if (components == null) return copyWith();
    Location location = copyWith();
    for (var value in components) {
      switch (value.kind) {
        case KindResponse.house:
          location = location.copyWith(house: value.name);
          break;
        case KindResponse.street:
          location = location.copyWith(street: value.name);
          break;
        case KindResponse.locality:
          location = location.copyWith(locality: value.name);
          break;
        case KindResponse.country:
          location = location.copyWith(country: value.name);
          break;
        case KindResponse.province:
          location = location.copyWith(province: value.name);
          break;
        default:
          break;
      }
    }
    return location;
  }
}

extension YandexToLocationUpdate on ToLocation {
  Future<ToLocation> updateLocation(YandexGeocoder geocoder) async {
    return copyWith(location: await location!.updateLocation(geocoder));
  }
}

extension YandexFromLocationUpdate on FromLocation {
  Future<FromLocation> updateLocation(YandexGeocoder geocoder) async {
    return copyWith(location: await location!.updateLocation(geocoder));
  }
}
