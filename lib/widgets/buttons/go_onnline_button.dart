import 'package:flutter/material.dart';
import 'package:superfleet_courier/widgets/colors.dart';


class GoOnlineButton extends StatelessWidget {
  const GoOnlineButton({super.key, this.width = 212, this.height = 56});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white;
            }
            return superfleetBlue;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return superfleetBlue;
            }
            return Colors.white;
          }),
          textStyle: const MaterialStatePropertyAll(
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          side: const MaterialStatePropertyAll(
              BorderSide(color: superfleetBlue, width: 2)),
          splashFactory: NoSplash.splashFactory,
        ),
        child: const Text('Go online'),
      ),
    );
  }
}
