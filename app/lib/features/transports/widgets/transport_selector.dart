import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/modal_hanlde.dart';

import '../logic/selected_transport_provider.dart';
import '../model/transport.dart';
import 'selected_transport_icon.dart';

class TransportSelector extends ConsumerWidget {
  const TransportSelector({
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

    onSelected(Transport transport) {
      ref.read(selectedTransportProvider.notifier).selectTransport(transport);
    }

    return SizedBox(
      height: 470,
      child: Column(
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
            transport: const Transport.walk(),
            selected: selectedTransport == const Transport.walk(),
            onSelected: onSelected,
          ),
          const SizedBox(height: 12),
          DeliveryMethodSelectionTile(
            transport: const Transport.bike(),
            selected: selectedTransport == const Transport.bike(),
            onSelected: onSelected,
          ),
          const SizedBox(height: 12),
          DeliveryMethodSelectionTile(
            transport: const Transport.car(),
            selected: selectedTransport == const Transport.car(),
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }
}
