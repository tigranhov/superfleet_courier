import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class SwipeToOrder extends HookWidget {
  const SwipeToOrder({
    Key? key,
    this.width = 304,
    this.height = 56,
    required this.text,
    required this.onDone,
  }) : super(key: key);
  final double width;
  final double height;
  final String text;
  final Function(Function() resetCallback)? onDone;

  @override
  Widget build(BuildContext context) {
    final positionAnimator =
        useAnimationController(duration: const Duration(milliseconds: 400));
    final colorChangeAnimator =
        useAnimationController(duration: const Duration(milliseconds: 400));

    final textColorAnimation = useAnimation(
        ColorTween(begin: Colors.black, end: Colors.white)
            .animate(positionAnimator));
    final solidColorAnimation = useAnimation(
        ColorTween(begin: const Color(0xff276EF1), end: const Color(0xff4F9E52))
            .animate(colorChangeAnimator));

    final swiping = useState(false);
    final double maxOffset = width - height;
    double positionOffset() => maxOffset * positionAnimator.value;

    reset() {
      if (context.mounted) {
        positionAnimator.reverse();
        colorChangeAnimator.animateTo(0);
      }
    }

    if (onDone == null) {
      return Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Color(0xffF0F0F0),
          borderRadius: BorderRadius.all(Radius.circular(64)),
        ),
        alignment: Alignment.center,
        child: Text(
          'Order completed',
          style: context.text16w700
              .copyWith(height: 1.07, color: const Color(0xff666666)),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: const Color(0x4D276EF1),
                borderRadius: BorderRadius.circular(500),
                border: swiping.value
                    ? Border.all(color: const Color(0xff276EF1), width: 2)
                    : null),
          ),
          Container(
            width: height + positionOffset(),
            height: height,
            decoration: BoxDecoration(
                color: solidColorAnimation,
                borderRadius: BorderRadius.circular(500),
                border: swiping.value
                    ? Border.all(
                        color: solidColorAnimation!.withAlpha(0), width: 2)
                    : null),
          ),
          AnimatedBuilder(
            animation: positionAnimator,
            builder: (context, child) {
              return Center(
                  child: SizedBox(
                width: 168,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: context.text16w700.copyWith(color: textColorAnimation),
                ),
              ));
            },
          ),
          Positioned(
            left: positionOffset(),
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                swiping.value = true;
              },
              onHorizontalDragEnd: (details) {
                swiping.value = false;
                if (positionAnimator.value > 0.7) {
                  positionAnimator.animateTo(1);
                  colorChangeAnimator.animateTo(1);
                  onDone!(reset);
                } else {
                  reset();
                }
              },
              onHorizontalDragUpdate: (details) {
                double tmpOffset = positionOffset();
                tmpOffset += details.delta.dx;
                tmpOffset = min(tmpOffset, maxOffset);
                tmpOffset = max(tmpOffset, 0);
                positionAnimator.value = tmpOffset / maxOffset;
                colorChangeAnimator.value = positionAnimator.value;
              },
              child: AnimatedContainer(
                width: height,
                height: height,
                decoration: BoxDecoration(
                    color: solidColorAnimation,
                    borderRadius: BorderRadius.circular(500),
                    border: swiping.value
                        ? Border.all(color: Colors.white, width: 2)
                        : null),
                duration: const Duration(milliseconds: 100),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FadeTransition(
                      opacity:
                          positionAnimator.drive(Tween(begin: 1.0, end: 0.0)),
                      child: const Icon(
                        SuperIcons.doubleRightArrows,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    FadeTransition(
                      opacity: positionAnimator,
                      child: const Icon(
                        SuperIcons.done,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
