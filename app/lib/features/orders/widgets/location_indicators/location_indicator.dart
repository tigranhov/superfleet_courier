import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/orders/domain/location_indicator_state.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/pulsing_border.dart';
import 'package:superfleet_courier/features/orders/widgets/pickup_description.dart';
import 'package:superfleet_courier/features/transports/widgets/selected_delivery_method_icon.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/location_pin_icon.dart';
import 'package:superfleet_courier/super_icons_icons.dart';

class LocationIndicatorYou extends StatelessWidget {
  const LocationIndicatorYou({
    super.key,
    required this.state,
  });

  final LocationIndicatorState state;

  @override
  Widget build(BuildContext context) {
    return _PulsingBorderOverlay(
      enabled: switch (state) {
        LocationIndicatorState.inactive => false,
        LocationIndicatorState.exhausted => false,
        LocationIndicatorState.active => true,
      },
      child: Container(
        alignment: Alignment.topLeft,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.only(left: 16, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationPinIcon(
              replacement: SelectedTransportIcon(
                size: 26,
                borderColor: switch (state) {
                  LocationIndicatorState.exhausted => superfleetBlue,
                  LocationIndicatorState.active => superfleetBlue,
                  LocationIndicatorState.inactive => null,
                },
              ),
              lineColor: switch (state) {
                LocationIndicatorState.exhausted => superfleetBlue,
                LocationIndicatorState.active => superfleetBlue,
                _ => null
              },
              infiniteLine: true,
              drawLine: true,
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'You',
                style: context.text16w700.copyWith(
                    color: switch (state) {
                  LocationIndicatorState.exhausted => null,
                  LocationIndicatorState.active => superfleetBlue,
                  LocationIndicatorState.inactive => null,
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum LocationTileType {
  pickup,
  dropoff,
}

class LocationIndicatorTile extends StatelessWidget {
  const LocationIndicatorTile({
    Key? key,
    required this.text,
    required this.state,
    required this.type,
    this.showPickupInformation = false,
  }) : super(key: key);

  final String text;
  final LocationIndicatorState state;
  final LocationTileType type;
  final bool showPickupInformation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PulsingBorderOverlay(
          enabled: switch (state) {
            LocationIndicatorState.active => true,
            _ => false,
          },
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.only(left: 16, right: 24),
            alignment: Alignment.topLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationPinIcon(
                  infiniteLine: true,
                  lineColor: switch (state) {
                    LocationIndicatorState.exhausted => superfleetBlue,
                    _ => null,
                  },
                  borderColor: switch (state) {
                    LocationIndicatorState.inactive => null,
                    _ => superfleetBlue,
                  },
                  icon: switch (type) {
                    LocationTileType.pickup => const Icon(
                        SuperIcons.location_pin,
                        size: 13.33,
                        color: superfleetOrange,
                      ),
                    LocationTileType.dropoff => const Icon(
                        SuperIcons.flag,
                        size: 11.33,
                        color: superfleetGreen,
                      ),
                  },
                  drawLine: switch (type) {
                    LocationTileType.pickup => true,
                    _ => false,
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          maxLines: 30,
                          overflow: TextOverflow.ellipsis,
                          style: context.text16w700.copyWith(
                              color: switch (state) {
                            LocationIndicatorState.active => superfleetBlue,
                            _ => null,
                          }),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Pickup time:',
                              style: context.text16w700grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'ASAP',
                              style: context.text16w700,
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        switch (type) {
          LocationTileType.pickup when showPickupInformation =>
            const PickupDescription(),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }
}

class _PulsingBorderOverlay extends ConsumerWidget {
  const _PulsingBorderOverlay(
      {Key? key, required this.enabled, required this.child})
      : super(key: key);
  final bool enabled;
  final Widget child;
  @override
  Widget build(BuildContext context, ref) {
    if (!enabled) return child;
    return Stack(
      children: [
        Positioned(
          left: 16,
          child: PulsingBorder(
              color: superfleetBlue.withAlpha(122),
              strokeWidth: 4,
              child: const SizedBox(
                width: 26,
                height: 26,
              )),
        ),
        child,
      ],
    );
  }
}
