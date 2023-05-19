import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/transports/model/transport.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/toggles/superfleet_radio.dart';
import 'package:superfleet_courier/widgets/transport_icon.dart';

class DeliveryMethodSelectionTile extends ConsumerWidget {
  const DeliveryMethodSelectionTile(
      {super.key,
      required this.transport,
      this.margin = const EdgeInsets.symmetric(horizontal: 12),
      required this.selected,
      required this.onSelected});

  final Transport transport;
  final EdgeInsets margin;
  final bool selected;
  final Function(Transport transport) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => onSelected(transport),
      child: Container(
        margin: margin,
        width: double.infinity,
        height: 88,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? superfleetBlue : context.superfleetGrey!,
              width: selected ? 2 : 1,
            ),
            color: selected ? context.primaryColor!.withOpacity(0.1) : null),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SuperfleetRadio(value: selected),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child:
                        Text(transport.toString(), style: context.text14w700)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'No licence plate available',
                    style: context.text14grey88,
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            TransportIcon(icon: transport.icon),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
