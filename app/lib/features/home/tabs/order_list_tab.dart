import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/orders/widgets/delivery_request.dart';
import 'package:superfleet_courier/features/orders/widgets/order_tile.dart';
import 'package:superfleet_courier/model/courier_notifier.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/model/order/notifiers/delivery_requests_notifier.dart';
import 'package:superfleet_courier/model/order/notifiers/order_notifiers.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';

import '../widgets/no_content_view.dart';

class OrderTab extends ConsumerWidget {
  const OrderTab({super.key, required this.onOrderSelected});

  final Function(Order order) onOrderSelected;

  @override
  Widget build(BuildContext context, ref) {
    final courierStatus = ref
        .watch(courierNotifierProvider.select((value) => value.value?.status));
    final orderCount = ref.watch(
        ordersNotifierProvider(status: OrderStatus.inProcess)
            .select((value) => value.value?.length));

    // final deliveryRequests =

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
            ? _OrderList(
                key: const ValueKey(1),
                onTilePressed: onOrderSelected,
              )
            : const NoContent(
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
    required this.onTilePressed,
  }) : super(key: key);

  final Function(Order order) onTilePressed;

  @override
  Widget build(BuildContext context, ref) {
    final List<Order> deliveryRequests =
        ref.watch(deliveryRequestsProvider.select((value) {
      if (value.hasValue) {
        return value.value ?? [];
      }
      return [];
    }));
    final orders =
        ref.watch(ordersNotifierProvider(status: OrderStatus.inProcess)).value!;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      separatorBuilder: (context, index) => const SizedBox(
        height: 12,
      ),
      itemBuilder: (context, index) {
        if (index < deliveryRequests.length) {
          return DeliveryRequest(
            order: deliveryRequests[index],
          );
        }
        return OrderTile(
          key: ValueKey(orders[index - deliveryRequests.length].id),
          onTap: onTilePressed,
          order: orders[index - deliveryRequests.length],
          width: 296,
        );
      },
      itemCount: deliveryRequests.length + orders.length,
    );
  }
}
