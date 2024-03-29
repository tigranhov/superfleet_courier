import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:superfleet_courier/features/map/order_preview_on_map.dart';
import 'package:superfleet_courier/features/orders/widgets/new_orders/time_progress_bar.dart';
import 'package:superfleet_courier/features/orders/widgets/order_content.dart';
import 'package:superfleet_courier/model/order/notifiers/delivery_requests_notifier.dart';
import 'package:superfleet_courier/model/order/notifiers/order_notifiers.dart';
import 'package:superfleet_courier/model/order/order.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/close_button.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';

class NewOrderScreen extends HookConsumerWidget {
  const NewOrderScreen({super.key, required this.orderId});
  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdNotifierProvider(orderId)).value;
    if (order == null) return const SizedBox();
    final remainingTime = ref.watch(deliveryRequestRemainingTimeProvider);
    ref.listen(deliveryRequestsProvider, (_, next) {
      if (next.value == null && context.canPop()) {
        context.pop();
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: SFCloseButton(
          onClosed: () => context.pop(),
        ),
        
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'NEW ORDER',
              style:
                  context.text14w700.copyWith(color: Colors.black, height: 1),
            ),
            const SizedBox(height: 4),
            Text(
              remainingTime.toMMSS(),
              style:
                  context.text14w700.copyWith(color: superfleetBlue, height: 1),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 48,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _ContentViewWithSlidingPanel(
              order: order,
              body: OrderPreviewOnMap(order: order),
            ),
            const TimeLinearProgress(),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(child: _BottomBar()),
    );
  }
}

class _ContentViewWithSlidingPanel extends HookConsumerWidget {
  const _ContentViewWithSlidingPanel({required this.order, required this.body});

  final Order order;
  final Widget body;

  @override
  Widget build(BuildContext context, ref) {
    final height = MediaQuery.of(context).size.height;
    final isClosed = useState(true);
    return SlidingUpPanel(
      body: body,
      backdropEnabled: true,
      maxHeight: height * 0.7,
      minHeight: 59,
      onPanelOpened: () => isClosed.value = false,
      onPanelClosed: () => isClosed.value = true,
      isDraggable: true,
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
          Expanded(
            child: SingleChildScrollView(
              physics:
                  isClosed.value ? const NeverScrollableScrollPhysics() : null,
              child: OrderContent(
                order: order,
                showPickupInformation: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar();
  @override
  Widget build(BuildContext context, ref) {
    const buttonHeight = 56.0;
    const buttonWidth = 148.0;

    return Container(
      height: 73,
      color: Colors.white,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SFButton(
          width: buttonWidth,
          height: buttonHeight,
          text: 'Reject',
          inverse: true,
          onPressed: () {
            ref.read(deliveryRequestsProvider.notifier).reject();
            context.pop();
          },
        ),
        SFButton(
          height: buttonHeight,
          width: buttonWidth,
          text: 'Accept',
          onPressed: () {
            ref.read(deliveryRequestsProvider.notifier).accept();
            context.pop();
          },
        )
      ]),
    );
  }
}
