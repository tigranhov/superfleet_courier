import 'package:flutter/material.dart';
import 'package:superfleet_courier/super_icons_icons.dart';

class SFCloseButton extends StatelessWidget {
  const SFCloseButton({Key? key, required this.onClosed}) : super(key: key);

  final Function()? onClosed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: IconButton(
        onPressed: onClosed,
        splashColor: Colors.transparent,
        splashRadius: 1,
        color: Colors.black,
        icon: const Icon(SuperIcons.close),
        iconSize: 14,
        padding: const EdgeInsets.all(0),
      ),
    );
  }
}
