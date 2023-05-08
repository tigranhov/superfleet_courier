import 'package:flutter/material.dart';

class TopPanel extends StatelessWidget {
  const TopPanel({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, height: 48, child: child);
  }
}
