//TODO replace with custom rounder progress bar
import 'package:flutter/material.dart';

class TimeProgressBar extends StatelessWidget {
  const TimeProgressBar({super.key, this.value = 0});
  final double value;

  get superfleetBlue => null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 8,
        child: LinearProgressIndicator(
          color: superfleetBlue,
          value: value,
        ));
  }
}
