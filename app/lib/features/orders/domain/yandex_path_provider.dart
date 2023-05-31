import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'yandex_path_provider.g.dart';

@riverpod
Future<DrivingSessionResult> yandexPath(
    YandexPathRef ref, List<({double lt, double lng})> points) async {
  final requestPoints = points
      .map((e) => RequestPoint(
          point: Point(latitude: e.lt, longitude: e.lng),
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
Future<List<MapObject>> routeObjects(
    RouteObjectsRef ref, List<({double lt, double lng})> points) async {
  final path = await ref.watch(yandexPathProvider(points).future);
  final firstRoute = path.routes!.first;
  final stats = await getPermissionStatus();
  await requestPermission();
  final location = await getLocation();
  final PlacemarkMapObject myPositionPlacemark = PlacemarkMapObject(
    mapId: MapObjectId('my_position'),
    point: Point(latitude: location.latitude!, longitude: location.longitude!),
    icon: PlacemarkIcon.single(PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage('assets/logo.png'), scale: 0.3)),
  );
  return [
    myPositionPlacemark,
    PolylineMapObject(
      mapId: const MapObjectId('route_${0}_polyline'),
      polyline: Polyline(points: firstRoute.geometry),
      strokeColor: Colors.black,
      strokeWidth: 4,
    )
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
  double latOffset = 0.003; // For latitude
  double longOffset = 0.003; // For longitude

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
