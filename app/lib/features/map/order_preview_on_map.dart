import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'domain/yandex_path_provider.dart';

class OrderPreviewOnMap extends HookConsumerWidget {
  const OrderPreviewOnMap({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickupPoints = useState(order.from
        .map((e) => (lat: e.locationData!.lat, lng: e.locationData!.lng))
        .toList());
    final dropoffPoint = useState(
        (lat: order.to.locationData!.lat, lng: order.to.locationData!.lng));
    final points = useState([...pickupPoints.value, dropoffPoint.value]);
    final result = ref.watch(yandexDrivingPathProvider(points.value));
    final mapObjects = ref.watch(routeObjectsProvider(
        pickupPoints: pickupPoints.value, dropoffPoint: dropoffPoint.value));
    if (mapObjects.valueOrNull == null) return const SizedBox();
    final size = MediaQuery.of(context).size;
    final mapFocusRectHeight = size.height;
    final mapFoucsRect = ScreenRect(
      topLeft: const ScreenPoint(x: 0, y: 0),
      bottomRight:
          ScreenPoint(x: size.width * 2, y: mapFocusRectHeight * 2 - 130),
    );

    return YandexMap(
      mode2DEnabled: true,
      zoomGesturesEnabled: true,
      mapObjects: mapObjects.valueOrNull!,
      onMapCreated: (controller) async {
        await Future.delayed(const Duration(milliseconds: 200));

        controller.moveCamera(CameraUpdate.newBounds(
            calculateBoundingBoxFromRoute(result.value!.routes![0].geometry),
            focusRect: mapFoucsRect));
      },
      mapType: MapType.map,
    );
  }
}
