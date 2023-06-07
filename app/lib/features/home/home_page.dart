import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/home/top_panel.dart';
import 'package:superfleet_courier/features/transports/widgets/transport_selector.dart';
import 'package:superfleet_courier/model/courier_notifier.dart';
import 'package:superfleet_courier/model/order/notifiers/delivery_requests_notifier.dart';
import 'package:superfleet_courier/routes.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'tabs/history_tab.dart';
import 'tabs/order_list_tab.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, this.debugTools = false});

  final bool debugTools;

  @override
  Widget build(BuildContext context, ref) {
    final tabController = useTabController(initialLength: 2);
    final isCourierActive = ref.watch(courierNotifierProvider
        .select((value) => value.value?.status == 'ACTIVE'));
    ref.listen(
      deliveryRequestsProvider,
      (prev, next) {
        if (isCourierActive && prev != next && next.value != null) {
          const NewOrderPopupRoute().go(context);
        }
      },
    );
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          TopPanel(
            onCarChangeTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  builder: (context) => const TransportSelector());
            },
          ),
          _TabBar(
            controller: tabController,
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              OrderTab(
                onOrderSelected: (order) {
                  OrderViewRoute(order.id).push(context);
                },
              ),
              const HistoryTab()
            ]),
          )
        ],
      )),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({this.controller});

  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller,
        labelColor: superfleetBlue,
        unselectedLabelColor: const Color(0xff888888),
        indicatorColor: superfleetBlue,
        labelStyle:
            context.text14w700grey.copyWith(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(
            text: "Order List",
          ),
          Tab(
            text: 'History',
          )
        ],
      ),
    );
  }
}
