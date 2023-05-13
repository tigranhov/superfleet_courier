import 'package:flutter/material.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/pulsing_border.dart';
import 'package:superfleet_courier/features/transports/widgets/selected_delivery_method_icon.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/location_pin_icon.dart';
import 'package:superfleet_courier/super_icons_icons.dart';

class LocationIndicatorYou extends StatelessWidget {
  const LocationIndicatorYou({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _PulsingBorderOverlay(
      enabled: false,
      child: Container(
        alignment: Alignment.topLeft,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.only(left: 16, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LocationPinIcon(
              replacement: SelectedTransportIcon(
                size: 26,
                borderColor: superfleetBlue,
              ),
              infiniteLine: true,
              drawLine: true,
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'You',
                style: context.text16w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LocationIndicatorFrom extends StatelessWidget {
  const LocationIndicatorFrom({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return _PulsingBorderOverlay(
      enabled: false,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.only(left: 16),
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LocationPinIcon(
              infiniteLine: true,
              icon: Icon(
                SuperIcons.location_pin,
                size: 13.33,
                color: superfleetOrange,
              ),
              drawLine: true,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  children: [
                    Text(
                      text,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: context.text16w700,
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
            )
          ],
        ),
      ),
    );
  }
}

class LocationIndicatorTo extends StatelessWidget {
  const LocationIndicatorTo({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationPinIcon(
            icon: Icon(
              SuperIcons.flag,
              size: 11.33,
              color: context.secondaryColor,
            ),
            drawLine: false,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.text16w700,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PulsingBorderOverlay extends StatelessWidget {
  const _PulsingBorderOverlay(
      {Key? key, required this.enabled, required this.child})
      : super(key: key);
  final bool enabled;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Stack(
      children: [
        Positioned(
          left: 16,
          child: PulsingBorder(
              color: superfleetBlue.withAlpha(122),
              strokeWidth: 8,
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
