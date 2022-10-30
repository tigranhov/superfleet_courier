import 'package:flutter/material.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class AdressItem extends StatelessWidget {
  const AdressItem(
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
          Stack(clipBehavior: Clip.none, children: [
            Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffD9D9D9), width: 2),
                    borderRadius: BorderRadius.circular(500)),
                child: Icon(
                  isPickup ? SuperIcons.location_pin : SuperIcons.flag,
                  size: 13,
                  color: isPickup
                      ? const Color(0xffE99700)
                      : const Color(0xff4F9E52),
                )),
            if (drawLine)
              Positioned(
                left: 13,
                top: 26,
                child: Container(
                  width: 0,
                  height: 63,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xffD9D9D9), width: 1)),
                ),
              ),
          ]),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: (26 - 22) / 2),
              Container(
                height: 44,
                alignment: Alignment.topLeft,
                child: Text(
                  address,
                  maxLines: 2,
                  style: context.orderTileAddress,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 22,
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(
                      isPickup ? 'Pickup time:' : 'Dropoff time:',
                      style: context.orderTilePickupText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: context.orderTileAddress,
                    )
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
