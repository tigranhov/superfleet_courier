import 'package:flutter/material.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class TransportIcon extends StatelessWidget {
  const TransportIcon(
      {Key? key, required this.icon, this.color, this.borderColor})
      : super(key: key);
  final IconData icon;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    iconSize() {
      if (icon == SuperIcons.car) return 15.67;
      if (icon == SuperIcons.bycicle) return 24.0;
      if (icon == SuperIcons.person) return 32.5;
      throw Exception('Unsupported Icon for tile');
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? context.superfleetGrey!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(500),
      ),
      child: Icon(
        icon,
        color: color ?? context.primaryColor,
        size: iconSize(),
      ),
    );
  }
}
