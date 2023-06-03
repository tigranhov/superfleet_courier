import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/theme/colors.dart';

class DeliveryRequest extends ConsumerWidget {
  const DeliveryRequest({
    super.key,
    this.height = 48,
  });
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: height,
      color: superfleetBlue,
    );
  }
}
