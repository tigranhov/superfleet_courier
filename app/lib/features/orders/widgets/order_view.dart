import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/location_indicator.dart';
import 'package:superfleet_courier/features/orders/widgets/location_indicators/pulsing_border.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/widgets/swiper_to_order.dart';

class OrderView extends HookConsumerWidget {
  const OrderView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  slivers: [
                    _AppBar(
                      onClosed: () {
                        context.pop();
                      },
                    ),
                    const _Map(),
                    const _TotalDistance(),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(top: 16),
                              child: const LocationIndicatorYou(
                                started: false,
                              )),
                          Container(
                              padding: const EdgeInsets.only(right: 16),
                              child: const LocationIndicatorFrom(
                                state: LocationIndicatorState.goingTo,
                                text:
                                    'Alikhanyan  brothers street 1st blind alley, house #13',
                              )),
                          Container(
                              padding: const EdgeInsets.only(right: 16),
                              child: const LocationIndicatorFrom(
                                state: LocationIndicatorState.reached,
                                text:
                                    'Alikhanyan  brothers street 1st blind alley, house #13,Alikhanyan  brothers street 1st blind alley, house #13,Alikhanyan  brothers street 1st blind alley, house #13',
                              )),
                          Container(
                              padding: const EdgeInsets.only(right: 16),
                              child: const LocationIndicatorTo(
                                state: LocationIndicatorState.completed,
                                text:
                                    'Alikhanyan  brothers street 1st blind alley, house #13',
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Container(
                  height: 73,
                  alignment: Alignment.center,
                  child: SwipeToOrder(
                    height: 56,
                    width: 304,
                    text: 'Swipe to order',
                    onDone: (reset) async {
                      await Future.delayed(const Duration(seconds: 1));
                      reset();
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
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
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: IconButton(
                  onPressed: onClosed,
                  icon: const Icon(SuperIcons.close),
                  iconSize: 14,
                  padding: const EdgeInsets.all(0),
                ),
              ),
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

class _Map extends StatelessWidget {
  const _Map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.red,
        ),
      ),
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
