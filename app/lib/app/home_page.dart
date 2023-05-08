import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/app/profile_page.dart';
import 'package:superfleet_courier/main.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/repository/superfleet_repository.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/widgets/order/order_tile.dart';

import 'bloc/courier_state_notifier.dart';
import 'bloc/order_state_notifier.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, this.debugTools = false});
  final bool debugTools;

  @override
  Widget build(BuildContext context, ref) {
    final tabController = useTabController(initialLength: 2);
    final content = Column(
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
    );
    return Scaffold(
      body: SafeArea(
        child: !debugTools
            ? content
            : Stack(
                children: [content, const _DebugBar()],
              ),
      ),
    );
  }
}

class _DebugBar extends ConsumerWidget {
  const _DebugBar();

  @override
  Widget build(BuildContext context, ref) {
    return Positioned(
        left: 0,
        bottom: 0,
        right: 0,
        height: 50,
        child: ButtonBar(
          children: [
            TextButton(
                onPressed: () async {
                  ref.read(courierProvider).mapOrNull(
                        loggedIn: (value) => Clipboard.setData(
                            ClipboardData(text: value.courier.id.toString())),
                      );
                },
                child: const Text('CourierId')),
            TextButton(
                onPressed: () async {
                  final token = await (ref.read(repoistoryProvider)
                          as SuperfleetRepository)
                      .token();
                  Clipboard.setData(ClipboardData(text: token));
                },
                child: const Text('Token')),
            TextButton(onPressed: () {}, child: const Text('New Order'))
          ],
        ));
  }
}

class _TopPanel extends StatelessWidget {
  const _TopPanel();

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, action) => const ProfilePage(),
      closedBuilder: (context, action) => Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(courierProvider);
          if (state is! CourierStateLoggedIn) {
            throw Exception('At home page without logged in user');
          }
          return Container(
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
                      border:
                          Border.all(color: const Color(0xffDFDFDF), width: 2),
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
                        '${state.courier.firstName} ${state.courier.lastName}',
                        style: context.text14,
                      ),
                      Text(
                        '${state.courier.transport}',
                        style: context.text12grey,
                      )
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (() =>
                      ref.read(courierProvider.notifier).changeStatus()),
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
                        value: state.courier.status == "ACTIVE",
                        activeColor: const Color(0xff4F9E52),
                        onChanged: (value) {
                          ref
                              .read(courierProvider.notifier)
                              .changeStatus(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12)
                  ]),
                )
              ],
            ),
          );
        },
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
    final orderStateStream = ref.watch(orderProvider);
    final courierState = ref.watch(courierProvider);
    final buildWidget = orderStateStream.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (OrderState orderState) {
          Widget finalWidget = const Center(child: Text('Invalid State'));
          courierState.mapOrNull(
            loggedIn: (courierState) {
              if (courierState.courier.status == 'INACTIVE') {
                finalWidget = const _InactiveOrders(
                  key: ValueKey(0),
                );
              } else {
                finalWidget = orderState.map(
                    data: (value) => value.orders.isNotEmpty
                        ? _OrderList(
                            key: const ValueKey(1), orders: value.orders)
                        : const _NoContent(
                            key: ValueKey(2),
                            description: 'You don’t have any orders, yet',
                            explanation:
                                'Orders will appear here once you accept them',
                            icon: Icons.remove_shopping_cart,
                          ),
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    invalid: (_) => const Center(child: Text('Invalid State')));
              }
            },
          );
          if (courierState is! CourierStateLoggedIn) {
            throw Exception(
                "Cannot be at order page without logged in Courier");
          }
          return finalWidget;
        },
        error: (Object error, StackTrace stackTrace) {
          return Center(
            child: Text("$error"),
          );
        });
    return PageTransitionSwitcher(
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
          SharedAxisTransition(
        animation: primaryAnimation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.scaled,
        child: child,
      ),
      duration: const Duration(milliseconds: 400),
      child: buildWidget,
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
            onPressed: () => ref.read(courierProvider.notifier).changeStatus()),
        const Expanded(child: SizedBox())
      ],
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({Key? key, required this.orders}) : super(key: key);
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
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
