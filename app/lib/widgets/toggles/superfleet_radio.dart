import 'package:flutter/material.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class SuperfleetRadio extends StatelessWidget {
  const SuperfleetRadio({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500),
          border: Border.all(
            color: context.primaryColor!,
            width: 2,
          ),
        ),
        //Solid circle 12x12
        child: value
            ? Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                  color: context.primaryColor,
                ),
              )
            : const SizedBox.shrink());
  }
}
