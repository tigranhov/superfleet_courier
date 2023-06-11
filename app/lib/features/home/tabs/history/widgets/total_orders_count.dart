import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class TotalOrdersCount extends ConsumerWidget {
  const TotalOrdersCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 204, 204, 204),
              width: 1,
            ),
            top: BorderSide(
              color: Color.fromARGB(255, 204, 204, 204),
              width: 1,
            ),
          )),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Total Orders',
            style: context.text16.copyWith(height: 1),
          ),
          const SizedBox(width: 4),
          Text(
            '122',
            style: context.text16w700.copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
