import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/deliver_methods/logic/selected_transport_provider.dart';
import 'package:superfleet_courier/features/deliver_methods/model/delivery_method.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/modal_hanlde.dart';

import 'deliver_method_selection_tile.dart';

class DeliveryMethodSelector extends ConsumerWidget {
  const DeliveryMethodSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTransportAsync = ref.watch(selectedTransportProvider);
    if (selectedTransportAsync.value == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    if (selectedTransportAsync.hasError) {
      return Center(
        child: Text(selectedTransportAsync.error.toString()),
      );
    }
    final selectedTransport = selectedTransportAsync.value;

    onSelected(DeliveryMethod transport) {
      ref.read(selectedTransportProvider.notifier).selectTransport(transport);
    }

    return Column(
      children: [
        const ModalHandle(),
        Text(
          'Choose your delivery method',
          style: context.text16w700,
        ),
        const SizedBox(height: 4),
        Text(
          'Contact administrator to update options',
          style: context.text16grey88,
        ),
        const SizedBox(height: 14),
        Divider(color: context.colorDivider),
        const SizedBox(height: 12),
        DeliveryMethodSelectionTile(
          transport: const DeliveryMethod.foot(),
          icon: SuperIcons.person,
          selected: selectedTransport == const DeliveryMethod.foot(),
          onSelected: onSelected,
        ),
        const SizedBox(height: 12),
        DeliveryMethodSelectionTile(
          transport: const DeliveryMethod.bicycle(),
          icon: SuperIcons.bycicle,
          selected: selectedTransport == const DeliveryMethod.bicycle(),
          onSelected: onSelected,
        ),
        const SizedBox(height: 12),
        DeliveryMethodSelectionTile(
          transport: const DeliveryMethod.car(),
          icon: SuperIcons.car,
          selected: selectedTransport == const DeliveryMethod.car(),
          onSelected: onSelected,
        ),
      ],
    );
  }
}
