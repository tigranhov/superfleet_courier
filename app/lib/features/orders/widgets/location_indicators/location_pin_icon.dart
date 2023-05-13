import 'package:flutter/material.dart';

class LocationPinIcon extends StatelessWidget {
  const LocationPinIcon(
      {super.key,
      this.icon = const Icon(Icons.error),
      this.size = 26,
      required this.drawLine,
      this.replacement,
      this.infiniteLine = false});
  final bool drawLine;
  final Icon icon;
  final Widget? replacement;
  final double size;
  final bool infiniteLine;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxHeight = constraints.maxHeight;
      final pinIcon = replacement != null
          ? SizedBox(
              width: size, height: size, child: FittedBox(child: replacement))
          : Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffD9D9D9), width: 2),
                  borderRadius: BorderRadius.circular(500)),
              alignment: Alignment.center,
              child: icon);
      return Stack(clipBehavior: Clip.none, children: [
        pinIcon,
        if (drawLine)
          Positioned(
            left: size / 2,
            top: size,
            child: Container(
              width: 2,
              height: infiniteLine ? 50000 : maxHeight - size,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffD9D9D9), width: 1)),
            ),
          ),
      ]);
    });
  }
}
