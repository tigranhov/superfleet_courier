import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/deliver_methods/model/delivery_method.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/toggles/superfleet_radio.dart';

class DeliveryMethodSelectionTile extends ConsumerWidget {
  const DeliveryMethodSelectionTile(
      {super.key,
      required this.transport,
      this.margin = const EdgeInsets.symmetric(horizontal: 12),
      required this.icon,
      required this.selected,
      required this.onSelected});

  final DeliveryMethod transport;
  final EdgeInsets margin;
  final IconData icon;
  final bool selected;
  final Function(DeliveryMethod transport) onSelected;

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
              color: selected ? superfleetBlue : context.colorDivider!,
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
            _TransportIcon(
              icon: icon,
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _TransportIcon extends StatelessWidget {
  const _TransportIcon({Key? key, required this.icon}) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    iconSize() {
      if (icon == SuperIcons.car) return 15.67;
      if (icon == SuperIcons.bycicle) return 24.0;
      if (icon == SuperIcons.person) return 32.5;
      throw Exception('Unsupported Icon for tile');
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colorDivider!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(500),
      ),
      child: Icon(
        icon,
        color: context.primaryColor,
        size: iconSize(),
      ),
    );
  }
}
