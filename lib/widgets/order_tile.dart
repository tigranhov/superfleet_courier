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
    final order = this.order.copyWith(
        from: List.from(this.order.from)
          ..add(this.order.from[0])
          ..add(this.order.from[0])
          ..add(this.order.from[0])
          ..add(this.order.from[0])
          ..add(this.order.from[0])
          ..add(this.order.from[0]));
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
            height: 16.h,
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
      height: 24.h,
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
      height: 55.h,
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.5.r),
                    borderRadius: BorderRadius.circular(500)),
                child: Icon(
                  isPickup ? SuperIcons.location_pin : SuperIcons.flag,
                  size: 13.sp,
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
                  height: 30.h,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.3)),
                ),
              ),
          ]),
          SizedBox(width: 16.w),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: (26.r - 17.h) / 2),
              Container(
                height: 17.h,
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  address,
                  maxLines: 1,
                  style: context.text12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                height: 17.h,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text(
                      isPickup ? 'Pickup time:' : 'Dropoff time:',
                      style: context.text12grey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      time,
                      style: context.text12,
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
