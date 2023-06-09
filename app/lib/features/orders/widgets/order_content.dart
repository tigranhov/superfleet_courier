import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

import '../domain/location_prgress.dart';
import 'location_indicators/location_indicator.dart';
import 'order_view.dart';


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
              time: (e.location as FromLocation).availableFrom,
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
                  time: order.deliverUntil,
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
