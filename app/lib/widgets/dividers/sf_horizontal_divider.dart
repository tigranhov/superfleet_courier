import 'package:flutter/material.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class SFHorizontalDivider extends StatelessWidget {
  const SFHorizontalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, decoration: context.borderDecoration);
  }
}
