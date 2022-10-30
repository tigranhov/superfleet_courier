import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:superfleet_courier/model/order.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/widgets/order/address_item.dart';
import 'package:superfleet_courier/widgets/progres_bars/time_progress_bar.dart';
import 'package:superfleet_courier/widgets/top_panel.dart';

class NewOrderMapViewPage extends StatelessWidget {
  const NewOrderMapViewPage({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _TopPanel(),
            const TimeProgressBar(
              value: 0.5,
            ),
            Expanded(
                child: SlidingUpPanel(
              backdropEnabled: true,
              maxHeight: 356,
              minHeight: 59,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              panel: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                      width: 39.5,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        color: const Color(0xffCCCCCC),
                      )),
                  const SizedBox(height: 12),
                  Expanded(child: _AddressReviewList(order: order))
                ],
              ),
              body: Container(
                color: Colors.green,
                child: const Placeholder(child: Text('Map Placeholder')),
              ),
            )),
            const _BottomPanel()
          ],
        ),
      ),
    );
  }
}

class _TopPanel extends StatelessWidget {
  const _TopPanel();

  @override
  Widget build(BuildContext context) {
    return TopPanel(
      child: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New Order',
                style: context.text14w700.copyWith(),
              ),
              const SizedBox(height: 4),
              Text(
                '00: 45',
                style: context.text14w700.copyWith(color: superfleetBlue),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  const _BottomPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: const Color(0xffCCCCCC)),
          boxShadow: const [
            BoxShadow(
              color: Color(0xffCCCCCC),
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
          ]),
      height: 73,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SFButton(
              width: 148,
              height: 56,
              text: 'Reject',
              inverse: true,
              onPressed: () {}),
          const SizedBox(width: 8),
          SFButton(
              width: 148,
              height: 56,
              text: 'Accept',
              inverse: false,
              onPressed: () {}),
        ],
      ),
    );
  }
}

class _AddressReviewList extends StatelessWidget {
  const _AddressReviewList({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          for (int i = 0; i < order.from.length; i++)
            _AddressItem(
                addressString: order.from[i].location!.addressString(),
                time: DateFormat.Hm()
                    .format(order.from[i].availableFrom!)
                    .toString(),
                topPadding: i == 0 ? 4 : 16,
                isPickup: true,
                description:
                    'Inch graca order descriptioni mej Take the box from lorem ipsum dolor set amet  lorem ipsum dolor set amet '),
          _AddressItem(
              addressString: order.to.location!.addressString(),
              time: DateFormat.Hm().format(order.deliverUntil!).toString(),
              isPickup: false,
              description:
                  'Inch graca order descriptioni mej Take the box from lorem ipsum dolor set amet  lorem ipsum dolor set amet ')
        ],
      ),
    );
  }
}

class _AddressItem extends StatelessWidget {
  const _AddressItem(
      {required this.addressString,
      required this.time,
      required this.description,
      this.topPadding = 16,
      this.isPickup = false});
  final String addressString;
  final String time;
  final String description;
  final double topPadding;
  final bool isPickup;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdressItem(
          address: addressString,
          isPickup: isPickup,
          time: time,
          paddingTop: topPadding,
          paddingBottom: 16,
        ),
        Container(
          height: 40,
          color: const Color(0xffF0F0F0),
          padding: const EdgeInsets.only(left: 24),
          alignment: Alignment.centerLeft,
          child: Text(
            'PICKUP DESCRIPTION',
            style: context.text14w700,
          ),
        ),
        Container(
          height: 98,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            description,
            style: context.text14.copyWith(
                fontSize: 16, height: 22.4 / 16, fontWeight: FontWeight.w400),
          ),
        ),
        const Divider(
          thickness: 1,
        )
      ],
    );
  }
}
