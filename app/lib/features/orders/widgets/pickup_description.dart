import 'package:flutter/material.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class PickupDescription extends StatelessWidget {
  const PickupDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          width: double.infinity,
          color: const Color(0xffF0F0F0),
          padding: const EdgeInsets.only(left: 24),
          alignment: Alignment.centerLeft,
          child: Text(
            'Pickup description',
            style: context.text14w700grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed euismod, diam, sed sed. ',
            style: context.text14,
          ),
        ),
      ],
    );
  }
}
