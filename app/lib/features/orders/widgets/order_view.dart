import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/features/map/order_preview_on_map.dart';
import 'package:superfleet_courier/features/orders/domain/location_prgress.dart';
import 'package:superfleet_courier/features/map/domain/yandex_path_provider.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/pulsing_border.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/model/order/notifiers/order_notifiers.dart';
import 'package:superfleet_courier/routes.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/cancellation_button.dart';
import 'package:superfleet_courier/widgets/buttons/close_button.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/widgets/dividers/sf_horizontal_divider.dart';
import 'package:superfleet_courier/widgets/swiper_to_order.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'order_content.dart';

part 'order_view.g.dart';

class OrderView extends HookConsumerWidget {
  const OrderView({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdNotifierProvider(orderId)).value;
    if (order == null) return const SizedBox();
    final pulsingAnimationController = useAnimationController();
    return ProviderScope(
      overrides: [
        pulsingAnimationControllerProvider
            .overrideWith((ref) => pulsingAnimationController)
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  primary: true,
                  slivers: [
                    _AppBar(
                      onClosed: () {
                        context.pop();
                      },
                    ),
                    _Map(
                      order: order,
                    ),
                    const _TotalDistance(),
                    SliverToBoxAdapter(
                      child: OrderContent(
                        order: order,
                        showPickupInformation: true,
                      ),
                    ),
                    _CancellationContainer(order: order),
                  ],
                ),
              ),
              const SFHorizontalDivider(),
              _OrderSwipeButton(order: order),
            ],
          ),
        ),
      ),
    );
  }
}

@riverpod
LocationProgress locationProgress(LocationProgressRef ref, Order order) {
  return LocationProgress()..register(order);
}

@riverpod
bool isOrderFinished(IsOrderFinishedRef ref, Order order) {
  final progress = ref.watch(locationProgressProvider(order));
  final currentStep = progress.currentStep(order.orderProgress)!;
  if (currentStep is DropoffLocationSteps) {
    return currentStep.currentStep == 1;
  }
  return false;
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.onClosed});

  final Function()? onClosed;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 48,
        maxHeight: 48,
        child: Container(
          decoration: context.appbarDecoration,
          child: Row(
            children: [
              SFCloseButton(onClosed: onClosed),
              Text('#123456789', style: context.text14w700.copyWith()),
              const Expanded(child: SizedBox()),
              SFButton(
                inverse: true,
                height: 32,
                width: 122,
                text: 'Navigator App',
                textStyle: context.text14w700,
                onPressed: () {},
              ),
              const SizedBox(width: 12)
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _Map extends ConsumerWidget {
  const _Map({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context, ref) {
    if (kIsWeb) {
      return const SliverToBoxAdapter(
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Center(
                  child:
                      Text('Map preview is working only on mobile devices'))));
    }

    return SliverToBoxAdapter(
      child: AspectRatio(
          aspectRatio: 16 / 9,
          child: LayoutBuilder(builder: (context, info) {
            return OrderPreviewOnMap(
              order: order,
              useFocusRect: false,
            );
          })),
    );
  }
}

class _TotalDistance extends StatelessWidget {
  const _TotalDistance();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        decoration: context.borderDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total distance', style: context.text14),
                const SizedBox(width: 4),
                Text('12.5 km', style: context.text14w700),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CancellationContainer extends HookConsumerWidget {
  const _CancellationContainer({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context, ref) {
    final isOrderFinished = ref.watch(isOrderFinishedProvider(order));
    useValueChanged(isOrderFinished, (oldValue, oldResult) {
      if (isOrderFinished) {
        Future.delayed(Duration.zero).then((value) => SuccessPageRoute(
                $extra: 'Order #${order.id} has been sucessfully completed!',
                $popOnDone: true)
            .push(context));
      }
      return isOrderFinished;
    });
    return SliverToBoxAdapter(
      child: Container(
        height: 104,
        alignment: Alignment.center,
        child: isOrderFinished
            ? SizedBox(
                width: 224,
                child: Text(
                  'Congradulations your delivery is completed ',
                  textAlign: TextAlign.center,
                  style: context.text16w700
                      .copyWith(color: superfleetGreen, height: 1.07),
                ),
              )
            : CancellationButton(
                onPressed: () {
                  CancelOrderViewRoute(order.id).go(context);
                },
              ),
      ),
    );
  }
}

class _OrderSwipeButton extends ConsumerWidget {
  const _OrderSwipeButton({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOrderFinished = ref.watch(isOrderFinishedProvider(order));
    return Container(
        height: 73,
        alignment: Alignment.center,
        child: SwipeToOrder(
          height: 56,
          width: 304,
          text: ref
              .watch(locationProgressProvider(order))
              .currentStepString(order.orderProgress)!,
          onDone: isOrderFinished
              ? null
              : (reset) async {
                  ref
                      .read(orderByIdNotifierProvider(order.id).notifier)
                      .addProgress();
                  reset();
                },
        ));
  }
}
