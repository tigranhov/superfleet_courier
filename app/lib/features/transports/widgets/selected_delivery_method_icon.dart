import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/transports/logic/selected_transport_provider.dart';
import 'package:superfleet_courier/widgets/transport_icon.dart';

class SelectedTransportIcon extends ConsumerWidget {
  const SelectedTransportIcon(
      {Key? key, required this.size, this.color, this.borderColor})
      : super(key: key);

  final Color? color;
  final Color? borderColor;

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTransport =
        ref.watch(selectedTransportProvider.select((e) => e.value));
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
          child: selectedTransport == null
              ? const SizedBox()
              : TransportIcon(
                  icon: selectedTransport.icon,
                  color: color,
                  borderColor: borderColor,
                )),
    );
  }
}
