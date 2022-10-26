import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final width = this.width.w;
    return Container(
      constraints: BoxConstraints(minWidth: width),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5.r, color: const Color(0xffCCCCCC)),
          borderRadius: BorderRadius.circular(4.r),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(64, 0, 0, 0),
              offset: const Offset(0, 2),
              blurRadius: 2.r,
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
          SizedBox(
            height: 16.r,
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
      height: 24.r,
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 12),
            child: Text(status, style: context.text12w700grey),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 12),
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
      {super.key,
      required this.address,
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
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 16.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffD9D9D9), width: 2.r),
                    borderRadius: BorderRadius.circular(500)),
                child: Icon(
                  isPickup ? SuperIcons.location_pin : SuperIcons.flag,
                  size: 13.r,
                  color: isPickup
                      ? const Color(0xffE99700)
                      : const Color(0xff4F9E52),
                )),
            if (drawLine)
              Positioned(
                left: 13.r,
                top: 26.r,
                child: Container(
                  width: 0,
                  height: 54.r,
                  decoration: BoxDecoration(
                    
                      border: Border.all(
                          color: const Color(0xffD9D9D9), width: 1.r)),
                ),
              ),
          ]),
          SizedBox(width: 16.w),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: (26.r - 17.r) / 2),
              Container(
                alignment: Alignment.topLeft,
                padding: REdgeInsets.only(right: 16),
                child: Text(
                  address,
                  maxLines: 2,
                  style: context.orderTileAddress,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4.r),
              Container(
                height: 17.r,
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(
                      isPickup ? 'Pickup time:' : 'Dropoff time:',
                      style: context.orderTilePickupText,
                    ),
                    SizedBox(width: 4.w),
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
