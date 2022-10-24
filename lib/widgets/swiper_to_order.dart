import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:superfleet_courier/super_icons_icons.dart';

class SwipeToOrder extends HookWidget {
  const SwipeToOrder({Key? key, this.width = 304, this.height = 56})
      : super(key: key);
  final double width;
  final double height;

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
    final icon = useState(SuperIcons.doublerightarrows);

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
                  child: Text(
                "Start Order",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColorAnimation),
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
                  icon.value = SuperIcons.done;
                } else {
                  positionAnimator.reverse();
                  colorChangeAnimator.animateTo(0);
                  icon.value = SuperIcons.doublerightarrows;
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
                child: Icon(
                  icon.value,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
