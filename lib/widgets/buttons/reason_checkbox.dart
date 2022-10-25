import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:superfleet_courier/theme/colors.dart';

class ReasonCheckbox extends StatelessWidget {
  const ReasonCheckbox(
      {super.key,
      this.width = 320,
      this.height = 72,
      required this.text,
      required this.value});

  final double width;
  final double height;
  final String text;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                onChanged: (value) {},
                side: const BorderSide(
                  color: superfleetBlue,
                  width: 2
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                value: value,
              ),
            ),
          ),
          Expanded(
            child: AutoSizeText(
              text,
              maxLines: 2,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
