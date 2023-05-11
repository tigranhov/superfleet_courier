
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/model/courier.dart';
import 'package:superfleet_courier/old_app/profile_page.dart';
import 'package:superfleet_courier/theme/colors.dart';
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
          children: [
            const SizedBox(width: 12),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onCarChangeTap,
              child: Container(
                  width: 36,
                  height: 36,
                  padding: const EdgeInsets.only(top: 6, bottom: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                    Border.all(color: const Color(0xffDFDFDF), width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.pedal_bike,
                    size: 24,
                    color: superfleetBlue,
                  )),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${courier?.firstName ?? ''} ${courier?.lastName ?? ''}',
                    style: context.text14,
                  ),
                  Text(
                    courier?.transport ?? '',
                    style: context.text12grey,
                  )
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
                SizedBox(
                  height: 20,
                  width: 40,
                  child: CupertinoSwitch(
                    value: courier?.status == "ACTIVE",
                    activeColor: const Color(0xff4F9E52),
                    onChanged: (value) {
                      ref
                          .read(courierNotifierProvider.notifier)
                          .changeStatus(value);
                    },
                  ),
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
