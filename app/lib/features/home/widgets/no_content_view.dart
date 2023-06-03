import 'package:flutter/material.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class NoContent extends StatelessWidget {
  const NoContent(
      {super.key,
      required this.icon,
      required this.description,
      required this.explanation});

  final IconData icon;
  final String description;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 80),
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              size: 36.72,
              icon,
              color: const Color(0xff888888),
            ),
          ),
          const SizedBox(height: 24),
          Container(
              width: double.infinity,
              height: 22,
              alignment: Alignment.center,
              child: Text(
                description,
                style:
                    context.text16grey88.copyWith(fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 4),
          Container(
              width: double.infinity,
              height: 44,
              alignment: Alignment.center,
              child: Text(
                explanation,
                style: context.text16grey88,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}
