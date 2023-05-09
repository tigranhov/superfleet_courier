import 'package:flutter/material.dart';
import 'package:superfleet_courier/widgets/top_panel.dart';

import '../model/model.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          _TopPanel(
            onClosePage: () {},
          )
        ],
      )),
    );
  }
}

class _TopPanel extends StatelessWidget {
  const _TopPanel({required this.onClosePage});

  final Function() onClosePage;
  @override
  Widget build(BuildContext context) {
    return TopPanel(
      child: Row(children: [
        IconButton(onPressed: onClosePage, icon: const Icon(Icons.close))
      ]),
    );
  }
}
