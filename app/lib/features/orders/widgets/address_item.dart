import 'package:flutter/material.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class AddressItem extends StatelessWidget {
  const AddressItem(
      {required this.address,
      required this.isPickup,
      required this.time,
      this.paddingTop = 16,
      this.paddingBottom = 0,
      this.drawLine = true});
  final String address;
  final bool isPickup;
  final String time;
  final bool drawLine;
  final double paddingTop;
  final double paddingBottom;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 12, right: 12, top: paddingTop, bottom: paddingBottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LocationIcon(drawLine: drawLine, isPickup: isPickup),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(
                address,
                maxLines: 2,
                style: context.text16w700,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    isPickup ? 'Pickup time:' : 'Dropoff time:',
                    style: context.text16w700grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: context.text16w700,
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}

class _LocationIcon extends StatelessWidget {
  const _LocationIcon({
    Key? key,
    required this.isPickup,
    required this.drawLine,
  }) : super(key: key);
  final bool isPickup;
  final bool drawLine;

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffD9D9D9), width: 2),
              borderRadius: BorderRadius.circular(500)),
          alignment: Alignment.center,
          child: Icon(
            isPickup ? SuperIcons.location_pin : SuperIcons.flag,
            size: isPickup ? 13.33 : 11.33,
            color: isPickup ? const Color(0xffE99700) : const Color(0xff4F9E52),
          )),
      if (drawLine)
        Positioned(
          left: 13,
          top: 26,
          child: Container(
            width: 0,
            height: 62,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffD9D9D9), width: 1)),
          ),
        ),
    ]);
  }
}
