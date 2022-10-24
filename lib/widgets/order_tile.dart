import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:superfleet_courier/model/order.dart';
import 'package:superfleet_courier/super_icons_icons.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(
      {super.key, this.width = 296, this.height = 200, required this.order});
  final double width;
  final double height;

  final Order order;

  String formatDate(DateTime? time) {
    if (time == null) return 'No Date';
    return intl.DateFormat.Hm().format(time).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: width, minHeight: height),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.sp)),
      child: Column(
        children: [
          _BeforeDivider(
            status: order.status ?? '!!No Status',
          ),
          const Divider(height: 0),
          SizedBox(height: 2.h),
          ...order.from.map((e) => _AdressItem(
              address: e.location!.addressString(),
              isPickup: true,
              time: formatDate(e.availableFrom))),
          _AdressItem(
              address: order.to.location!.addressString(),
              isPickup: false,
              time: formatDate(order.deliverUntil))
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
      height: 28,
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              status,
              style: GoogleFonts.roboto().copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withAlpha(122)),
            ),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              '#123456789',
              style: GoogleFonts.roboto().copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withAlpha(122)),
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
      required this.time});
  final String address;
  final bool isPickup;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 26.sp,
              height: 26.sp,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(500)),
              child: Icon(
                isPickup ? SuperIcons.location_pin : SuperIcons.flag,
                size: 13.sp,
                color: isPickup
                    ? const Color(0xffE99700)
                    : const Color(0xff4F9E52),
              )),
          SizedBox(width: 16.w),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                address,
                maxLines: 2,
                style: GoogleFonts.roboto()
                    .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    isPickup ? 'Pickup time:' : 'Dropoff time:',
                    style: GoogleFonts.roboto().copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withAlpha(122)),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    time,
                    style: GoogleFonts.roboto()
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
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
