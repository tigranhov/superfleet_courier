import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/features/transports/logic/selected_transport_provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'yandex_path_provider.g.dart';

@riverpod
Future<DrivingSessionResult> yandexDrivingPath(
    YandexDrivingPathRef ref, List<({double lat, double lng})> points) async {
  final requestPoints = points
      .map((e) => RequestPoint(
          point: Point(latitude: e.lat, longitude: e.lng),
          requestPointType: RequestPointType.wayPoint))
      .toList();

  var resultWithSession = YandexDriving.requestRoutes(
      points: requestPoints,
      drivingOptions: const DrivingOptions(
        initialAzimuth: 0,
        routesCount: 1,
        avoidTolls: true,
      ));
  return resultWithSession.result;
}

@riverpod
Future<BicycleSessionResult> yandexBicyclePath(
    YandexBicyclePathRef ref, List<({double lat, double lng})> points,
    {BicycleVehicleType vehicleType = BicycleVehicleType.scooter}) async {
  final requestPoints = points
      .map((e) => RequestPoint(
          point: Point(latitude: e.lat, longitude: e.lng),
          requestPointType: RequestPointType.wayPoint))
      .toList();

  var resultWithSession = YandexBicycle.requestRoutes(
      points: requestPoints, bicycleVehicleType: vehicleType);
  return resultWithSession.result;
}

@riverpod
Future<List<MapObject>> routeObjects(RouteObjectsRef ref,
    {required List<({double lat, double lng})> pickupPoints,
    required ({double lat, double lng}) dropoffPoint}) async {
  final selectedTransport = await ref.watch(selectedTransportProvider.future);

  final points = [...pickupPoints, dropoffPoint];
  final path = await selectedTransport.map(car: (car) async {
    final result = await ref.watch(yandexDrivingPathProvider(points).future);
    return result.routes!.first.geometry;
  }, bike: (bike) async {
    final result = await ref.watch(yandexBicyclePathProvider(points,
            vehicleType: BicycleVehicleType.bicycle)
        .future);
    return result.routes!.first.geometry;
  }, walk: (walk) async {
    final result = await ref.watch(yandexBicyclePathProvider(points,
            vehicleType: BicycleVehicleType.scooter)
        .future);
    return result.routes!.first.geometry;
  });
  // await requestPermission();
  // final location = await getLocation();
  // final PlacemarkMapObject myPositionPlacemark = PlacemarkMapObject(
  //   mapId: const MapObjectId('my_position'),
  //   point: Point(latitude: location.latitude!, longitude: location.longitude!),
  //   icon: PlacemarkIcon.single(PlacemarkIconStyle(
  //       image: BitmapDescriptor.fromAssetImage('assets/logo.png'), scale: 1)),
  // );
  int index = 0;
  final pickupPlacemarks = pickupPoints
      .map((e) => PlacemarkMapObject(
            mapId: MapObjectId('pickup${index++}'),
            point: Point(latitude: e.lat, longitude: e.lng),
            opacity: 1,
            icon: PlacemarkIcon.single(PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  'assets/pickup.png',
                ),
                scale: 3,
                zIndex: 100)),
          ))
      .toList();

  final dropoffPlacemark = PlacemarkMapObject(
    mapId: const MapObjectId('dropoff'),
    point: Point(latitude: dropoffPoint.lat, longitude: dropoffPoint.lng),
    opacity: 1,
    icon: PlacemarkIcon.single(PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage(
          'assets/dropoff.png',
        ),
        scale: 3)),
  );
  return [
    // myPositionPlacemark,
    ...pickupPlacemarks,
    dropoffPlacemark,
    PolylineMapObject(
      mapId: const MapObjectId('route_${0}_polyline'),
      polyline: Polyline(points: path),
      isInnerOutlineEnabled: true,
      strokeColor: Colors.black,
      strokeWidth: 4,
    ),
  ];
}

BoundingBox calculateBoundingBoxFromRoute(List<Point> routePoints) {
  double minLat = double.infinity;
  double maxLat = double.negativeInfinity;
  double minLong = double.infinity;
  double maxLong = double.negativeInfinity;

  for (Point point in routePoints) {
    if (point.latitude < minLat) minLat = point.latitude;
    if (point.latitude > maxLat) maxLat = point.latitude;
    if (point.longitude < minLong) minLong = point.longitude;
    if (point.longitude > maxLong) maxLong = point.longitude;
  }

  // Define your padding offset (this can be adjusted based on your needs)
  double latOffset = 0.005; // For latitude
  double longOffset = 0.005; // For longitude

  // Add padding around the bounding box
  minLat = minLat - latOffset;
  maxLat = maxLat + latOffset;
  minLong = minLong - longOffset;
  maxLong = maxLong + longOffset;

  return BoundingBox(
    northEast: Point(latitude: maxLat, longitude: maxLong),
    southWest: Point(latitude: minLat, longitude: minLong),
  );
}
