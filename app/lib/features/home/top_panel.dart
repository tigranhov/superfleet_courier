import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/transports/logic/selected_transport_provider.dart';
import 'package:superfleet_courier/features/transports/widgets/selected_delivery_method_icon.dart';
import 'package:superfleet_courier/model/courier.dart';
import 'package:superfleet_courier/old_app/profile_page.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class TopPanel extends ConsumerWidget {
  const TopPanel({super.key, required this.onCarChangeTap});

  final Function()? onCarChangeTap;

  @override
  Widget build(BuildContext context, ref) {
    final courier = ref.watch(courierNotifierProvider).value;
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, action) => const ProfilePage(),
      closedBuilder: (context, action) => Container(
        color: Colors.white,
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onCarChangeTap,
                  child: const SelectedTransportIcon(size: 36)),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${courier?.firstName ?? ''} ${courier?.lastName ?? ''}',
                    style: context.text14.copyWith(height: 1),
                  ),
                  Consumer(builder: (context, ref, child) {
                    final selectedTransport =
                        ref.watch(selectedTransportProvider).value;
                    return Text(
                      selectedTransport != null
                          ? selectedTransport.toString()
                          : ' --- ',
                      style: context.text12grey.copyWith(height: 1),
                    );
                  })
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (() {
                ref.read(courierNotifierProvider.notifier).changeStatus();
              }),
              child: Row(children: [
                Container(
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Online',
                    style: context.text12grey,
                  ),
                ),
                const SizedBox(width: 12),
                FlutterSwitch(
                  width: 40,
                  height: 20,
                  value: courier?.status == "ACTIVE",
                  activeColor: const Color(0xff4F9E52),
                  padding: 4,
                  toggleSize: 14,
                  onToggle: (value) {
                    ref
                        .read(courierNotifierProvider.notifier)
                        .changeStatus(value);
                  },
                ),
                const SizedBox(width: 12)
              ]),
            )
          ],
        ),
      ),
    );
  }
}
