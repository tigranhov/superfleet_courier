import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/features/orders/domain/location_prgress.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/location_indicator.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/pulsing_border.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/cancellation_button.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/widgets/swiper_to_order.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../domain/location_indicator_state.dart';
part 'order_view.g.dart';

class OrderView extends HookConsumerWidget {
  const OrderView({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdNotifierProvider(orderId)).value;
    if (order == null) return const SizedBox();
    final pulsingAnimationController = useAnimationController();
    return ProviderScope(
      overrides: [
        pulsingAnimationControllerProvider
            .overrideWith((ref) => pulsingAnimationController)
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  primary: true,
                  slivers: [
                    _AppBar(
                      onClosed: () {
                        context.pop();
                      },
                    ),
                    _Map(
                      order: order,
                    ),
                    const _TotalDistance(),
                    SliverToBoxAdapter(
                      child: OrderContent(
                        order: order!,
                        showPickupInformation: true,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 104,
                        alignment: Alignment.center,
                        child: CancellationButton(
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(height: 1, decoration: context.borderDecoration),
              Container(
                  height: 73,
                  alignment: Alignment.center,
                  child: SwipeToOrder(
                    height: 56,
                    width: 304,
                    text: ref
                        .watch(locationProgressProvider(order))
                        .currentStepString(order.orderProgress)!,
                    onDone: (reset) async {
                      ref
                          .read(orderByIdNotifierProvider(orderId).notifier)
                          .addProgress();
                      reset();
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

@riverpod
LocationProgress locationProgress(LocationProgressRef ref, Order order) {
  return LocationProgress()..register(order);
}

class OrderContent extends ConsumerWidget {
  const OrderContent({
    super.key,
    required this.order,
    this.showPickupInformation = false,
  });

  final Order order;
  final bool showPickupInformation;

  @override
  Widget build(BuildContext context, ref) {
    final locationProgress = ref.watch(locationProgressProvider(order));
    return Column(
      children: [
        if (showPickupInformation) const SizedBox(height: 16),
        ...locationProgress.steps.map((e) {
          if (e is MeLocationSteps) {
            return LocationIndicatorYou(
              state: e.indicatorState,
            );
          } else if (e is PickupLocationSteps) {
            return LocationIndicatorTile(
              state: e.indicatorState,
              type: LocationTileType.pickup,
              showPickupInformation: showPickupInformation,
              text: e.location.addressString(),
            );
          } else if (e is DropoffLocationSteps) {
            return Column(
              children: [
                if (showPickupInformation)
                  Container(height: 1, decoration: context.borderDecoration),
                if (showPickupInformation) const SizedBox(height: 16),
                LocationIndicatorTile(
                  state: e.indicatorState,
                  type: LocationTileType.dropoff,
                  showPickupInformation: showPickupInformation,
                  text: e.location.addressString(),
                ),
                if (showPickupInformation)
                  Container(height: 1, decoration: context.borderDecoration),
              ],
            );
          } else {
            return Container();
          }
        })
      ],
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.onClosed});

  final Function()? onClosed;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 48,
        maxHeight: 48,
        child: Container(
          decoration: context.appbarDecoration,
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: IconButton(
                  onPressed: onClosed,
                  icon: const Icon(SuperIcons.close),
                  iconSize: 14,
                  padding: const EdgeInsets.all(0),
                ),
              ),
              Text('#123456789', style: context.text14w700.copyWith()),
              const Expanded(child: SizedBox()),
              SFButton(
                inverse: true,
                height: 32,
                width: 122,
                text: 'Navigator App',
                textStyle: context.text14w700,
                onPressed: () {},
              ),
              const SizedBox(width: 12)
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _Map extends StatelessWidget {
  const _Map({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    final PlacemarkMapObject startPlacemark = PlacemarkMapObject(
      mapId: MapObjectId('start_placemark'),
      point: Point(latitude: 55.7558, longitude: 37.6173),
      icon: PlacemarkIcon.single(PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/logo.png'),
          scale: 0.3)),
    );
    final PlacemarkMapObject stopByPlacemark = PlacemarkMapObject(
      mapId: MapObjectId('stop_by_placemark'),
      point: Point(latitude: 45.0360, longitude: 38.9746),
      icon: PlacemarkIcon.single(PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/logo.png'),
          scale: 0.3)),
    );
    final PlacemarkMapObject endPlacemark = PlacemarkMapObject(
        mapId: MapObjectId('end_placemark'),
        point: Point(latitude: 48.4814, longitude: 135.0721),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/logo.png'),
            scale: 0.3)));
    final List<MapObject> mapObjects = [
      startPlacemark,
      stopByPlacemark,
      endPlacemark
    ];
    return SliverToBoxAdapter(
      child: AspectRatio(
          aspectRatio: 16 / 9,
          child: !kIsWeb
              ? Container(
                  child: YandexMap(
                    mapObjects: mapObjects,
                    focusRect: ScreenRect(
                      topLeft: ScreenPoint(x: 0, y: 0),
                      bottomRight: ScreenPoint(x: 100, y: 10),
                    ),
                    mapType: MapType.map,
                    zoomGesturesEnabled: true,
                  ),
                )
              : const Center(
                  child: Text('Map preview is working only on mobile devices'),
                )),
    );
  }
}

class _TotalDistance extends StatelessWidget {
  const _TotalDistance();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        decoration: context.borderDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total distance', style: context.text14),
                const SizedBox(width: 4),
                Text('12.5 km', style: context.text14w700),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
