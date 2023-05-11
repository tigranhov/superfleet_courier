import 'package:flutter/material.dart';

class ModalHandle extends StatelessWidget {
  const ModalHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 39.5,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500),
          color: const Color(0xffCCCCCC),
        ));
  }
}
