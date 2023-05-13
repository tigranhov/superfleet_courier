import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A widget that adds an animated pulsing border around its child.
///
/// The border's color and stroke width can be customized. The animation duration
/// can also be adjusted.
///
/// The child widget should have a finite size, because the border is drawn
/// relative to the child's size.
///
/// Example usage:
///
/// ```
/// PulsingBorder(
///   strokeWidth: 2.0,
///   color: Colors.red,
///   child: Text('Hello, world!'),
///   duration: Duration(seconds: 1),
/// )
/// ```
///
/// This will display the text 'Hello, world!' with a red pulsing border
/// around it. The border's width will vary between 0 and 2 pixels, and
/// each pulse will last 1 second.
class PulsingBorder extends StatelessWidget {
  const PulsingBorder({
    Key? key,
    required this.strokeWidth,
    required this.color,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final Color color;
  final double strokeWidth;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Animate(
      child: child,
      onPlay: (controller) => controller.repeat(),
    ).custom(
        duration: duration,
        builder: (context, animation, child) {
          return CustomPaint(
            painter: _AnimatedBorder(
              strokeWidth: strokeWidth,
              color: color,
              animation: animation,
            ),
            child: child,
          );
        });
  }
}

class _AnimatedBorder extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double animation;

  _AnimatedBorder(
      {required this.strokeWidth,
      required this.color,
      required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = this.strokeWidth * animation;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth; // Animate the stroke width

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 + strokeWidth / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
