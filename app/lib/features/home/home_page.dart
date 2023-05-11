import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/widgets/order/order_tile.dart';

import '../../old_app/profile_page.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, this.debugTools = false});
  final bool debugTools;

  @override
  Widget build(BuildContext context, ref) {
    final tabController = useTabController(initialLength: 2);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const _TopPanel(),
          _TabBar(
            controller: tabController,
          ),
          Expanded(
            child: TabBarView(
                controller: tabController,
                children: const [_OrderTab(), _HistoryTab()]),
          )
        ],
      )),
    );
  }
}

class _TopPanel extends ConsumerWidget {
  const _TopPanel();

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
            Container(
                width: 36,
                height: 36,
                padding: const EdgeInsets.only(top: 6, bottom: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xffDFDFDF), width: 2),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.pedal_bike,
                  size: 24,
                  color: superfleetBlue,
                )),
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
            text: 'Order List',
          ),
          Tab(
            text: 'History',
          )
        ],
      ),
    );
  }
}

class _OrderTab extends ConsumerWidget {
  const _OrderTab();

  @override
  Widget build(BuildContext context, ref) {
    final courierStatus = ref
        .watch(courierNotifierProvider.select((value) => value.value?.status));
    final orderCount = ref
        .watch(ordersNotifierProvider().select((value) => value.value?.length));

    if (orderCount == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    buildWidget() {
      if (courierStatus == 'INACTIVE') {
        return const _InactiveOrders(
          key: ValueKey(0),
        );
      } else {
        return orderCount > 0
            ? const _OrderList(key: ValueKey(1))
            : const _NoContent(
                key: ValueKey(2),
                description: 'You don’t have any orders, yet',
                explanation: 'Orders will appear here once you accept them',
                icon: Icons.remove_shopping_cart,
              );
      }
    }

    return PageTransitionSwitcher(
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
          SharedAxisTransition(
        animation: primaryAnimation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.scaled,
        child: child,
      ),
      duration: const Duration(milliseconds: 400),
      child: buildWidget(),
    );
  }
}

class _InactiveOrders extends ConsumerWidget {
  const _InactiveOrders({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 80, left: 116, right: 116),
            child: Image.asset('assets/offline.png')),
        const SizedBox(height: 24),
        const Text(
          'You are currently offline',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff888888)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Come online to start delivering',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff888888)),
        ),
        const SizedBox(height: 32),
        SFButton(
            text: 'Go Online',
            onPressed: () =>
                ref.read(courierNotifierProvider.notifier).changeStatus()),
        const Expanded(child: SizedBox())
      ],
    );
  }
}

class _OrderList extends ConsumerWidget {
  const _OrderList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final orders = ref.watch(ordersNotifierProvider()).value!;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      separatorBuilder: (context, index) => const SizedBox(
        height: 12,
      ),
      itemBuilder: (context, index) {
        return OrderTile(
          onTap: (order) {
            context.push('/order', extra: order);
          },
          order: orders[index],
          width: 296,
        );
      },
      itemCount: orders.length,
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return const _NoContent(
      description: 'You don’t have any order history, yet',
      explanation: 'Order history will appear here once you complete one',
      icon: Icons.watch_later_outlined,
    );
  }
}

class _NoContent extends StatelessWidget {
  const _NoContent(
      {Key? key,
      required this.icon,
      required this.description,
      required this.explanation})
      : super(key: key);
  final IconData icon;
  final String description;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 80),
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              size: 36.72,
              icon,
              color: const Color(0xff888888),
            ),
          ),
          const SizedBox(height: 24),
          Container(
              width: double.infinity,
              height: 22,
              alignment: Alignment.center,
              child: Text(
                description,
                style:
                    context.text16grey88.copyWith(fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 4),
          Container(
              width: double.infinity,
              height: 44,
              alignment: Alignment.center,
              child: Text(
                explanation,
                style: context.text16grey88,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}
