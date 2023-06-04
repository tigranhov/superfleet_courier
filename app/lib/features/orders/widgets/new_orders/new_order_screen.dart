import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:superfleet_courier/features/orders/widgets/order_content.dart';
import 'package:superfleet_courier/model/order/notifiers/order_notifiers.dart';
import 'package:superfleet_courier/model/order/order.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';

class NewOrderScreen extends HookConsumerWidget {
  const NewOrderScreen({super.key, required this.orderId});
  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdNotifierProvider(orderId)).value;
    if (order == null) return const SizedBox();
    return Scaffold(
      bottomSheet: _ContentViewWithSlidingPanel(order: order),
      bottomNavigationBar: _BottomBar(),
    );
  }
}

class _ContentViewWithSlidingPanel extends HookConsumerWidget {
  const _ContentViewWithSlidingPanel({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context, ref) {
    final height = MediaQuery.of(context).size.height;
    final isClosed = useState(true);
    return SlidingUpPanel(
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

class _BottomBar extends StatelessWidget {
  const _BottomBar({super.key});
  @override
  Widget build(BuildContext context) {
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
          onPressed: () {},
        ),
        SFButton(
          height: buttonHeight,
          width: buttonWidth,
          text: 'Accept',
          onPressed: () {},
        )
      ]),
    );
  }
}
