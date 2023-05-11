import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class DeliveryMethodSelector extends ConsumerWidget {
  const DeliveryMethodSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text('Choose your delivery method', style: context.text16w700,)
      ],
    );
  }
}
