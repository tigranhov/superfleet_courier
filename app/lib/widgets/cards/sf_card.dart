import 'package:flutter/material.dart';

class SFCard extends StatelessWidget {
  const SFCard({super.key, required this.child, this.constraints});
  final Widget child;

  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: constraints,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.5, color: const Color(0xffCCCCCC)),
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(64, 0, 0, 0),
                offset: Offset(0, 2),
                blurRadius: 2,
              ),
            ]),
        child: child);
  }
}
