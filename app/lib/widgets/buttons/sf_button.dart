import 'package:flutter/material.dart';
import 'package:superfleet_courier/theme/colors.dart';

class SFButton extends StatelessWidget {
  const SFButton(
      {super.key,
      required this.text,
      this.width = 212,
      this.height = 56,
      this.inverse = false,
      this.padding,
      this.mainColor = superfleetBlue,
      this.secondaryColor = Colors.white,
      this.borderColor = superfleetBlue,
      required this.onPressed,
      this.textStyle =
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)});
  final double width;
  final double height;
  final bool inverse;
  final EdgeInsets? padding;
  final String text;
  final Function() onPressed;
  final Color mainColor;
  final Color secondaryColor;
  final Color borderColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(64.0))),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return inverse ? mainColor : secondaryColor;
            }
            return inverse ? secondaryColor : mainColor;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return inverse ? secondaryColor : mainColor;
            }
            return inverse ? mainColor : secondaryColor;
          }),
          textStyle: MaterialStatePropertyAll(textStyle),
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          side: MaterialStatePropertyAll(
              BorderSide(color: borderColor, width: 2)),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Text(text),
      ),
    );
  }
}
