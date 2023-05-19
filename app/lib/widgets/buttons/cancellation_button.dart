import 'package:flutter/material.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class CancellationButton extends StatelessWidget {
  const CancellationButton(
      {super.key, required this.onPressed, this.width = 212, this.height = 32});
  final double width;
  final double height;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          foregroundColor: MaterialStateProperty.all(context.superfleetRed!),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            return states.contains(MaterialState.pressed)
                ? context.superfleetGrey!
                : Colors.transparent;
          }),
          surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          side: MaterialStateProperty.all(
            BorderSide(
              color: context.superfleetGrey!,
              width: 2,
            ),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(64.0),
            ),
          ),
        ),
        child: Text('Cancel Order',
            style: context.text16w700.copyWith(
              color: context.superfleetRed!,
              height: 1.25,
            )),
      ),
    );
  }
}
