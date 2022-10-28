import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:superfleet_courier/model/order.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, this.width = 296, required this.order});
  final double width;

  final Order order;

  String formatDate(DateTime? time) {
    if (time == null) return 'No Date';
    return intl.DateFormat.Hm().format(time).toString();
  }

  @override
  Widget build(BuildContext context) {
   
    final width = this.width;
    return Container(
      constraints: BoxConstraints(minWidth: width),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: const Color(0xffCCCCCC)),
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(64, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
          ]),
      child: Column(
        children: [
          _BeforeDivider(
            status: order.status ?? '!!No Status',
          ),
          const Divider(height: 0),
          ...order.from.map((e) => _AdressItem(
              address: e.location?.addressString() ?? 'No Address',
              isPickup: true,
              time: formatDate(e.availableFrom))),
          _AdressItem(
            address: order.to.location?.addressString() ?? 'No Address',
            isPickup: false,
            time: formatDate(order.deliverUntil),
            drawLine: false,
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}

class _BeforeDivider extends StatelessWidget {
  const _BeforeDivider({Key? key, required this.status}) : super(key: key);
  final String status;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(status, style: context.text12w700grey),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '#123456789',
              style: context.text12w700grey,
            ),
          )
        ],
      ),
    );
  }
}

class _AdressItem extends StatelessWidget {
  const _AdressItem(
      {required this.address,
      required this.isPickup,
      required this.time,
      this.drawLine = true});
  final String address;
  final bool isPickup;
  final String time;
  final bool drawLine;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
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
