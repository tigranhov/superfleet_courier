import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'sf_theme.tailor.dart';

@Tailor(themes: ['light'])
class _$SFTheme {
  static List<TextStyle> text12 = [
    GoogleFonts.roboto()
        .copyWith(fontSize: 12, height: 1.4, color: const Color(0xff000000))
  ];

  static List<TextStyle> text12grey = [
    GoogleFonts.roboto()
        .copyWith(fontSize: 12, height: 1.4, color: superfleetGrey[0])
  ];
  static List<TextStyle> text12w700 = [
    GoogleFonts.roboto()
        .copyWith(fontSize: 12, height: 1.4, fontWeight: FontWeight.w700)
  ];
  static List<TextStyle> text12w700grey = [
    GoogleFonts.roboto().copyWith(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w700,
        color: superfleetGrey[0])
  ];
  static List<TextStyle> text14 = [
    GoogleFonts.roboto().copyWith(
      fontSize: 14,
      height: 1.4,
    )
  ];
  static List<TextStyle> text14w700 = [
    GoogleFonts.roboto().copyWith(
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w700,
    )
  ];
  static List<TextStyle> text14w700grey = [
    GoogleFonts.roboto().copyWith(
        fontSize: 14,
        color: superfleetGrey[0],
        height: 1.4,
        fontWeight: FontWeight.w700)
  ];
  static List<TextStyle> text14grey = [
    GoogleFonts.roboto().copyWith(
      fontSize: 14,
      height: 1.4,
      color: superfleetGrey[0],
    )
  ];
  static List<TextStyle> text14grey88 = [
    GoogleFonts.roboto().copyWith(
      fontSize: 14,
      height: 1.4,
      color: const Color(0xff888888),
    )
  ];
  static List<TextStyle> text16 = [
    GoogleFonts.roboto().copyWith(
      fontSize: 16,
      height: 1.4,
    )
  ];
  static List<TextStyle> text16w700 = [
    GoogleFonts.roboto()
        .copyWith(fontSize: 16, height: 1.4, fontWeight: FontWeight.w700)
  ];
  static List<TextStyle> text16w700grey = [
    GoogleFonts.roboto().copyWith(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w700,
        color: const Color.fromRGBO(0, 0, 0, 0.5))
  ];
  static List<TextStyle> text16grey88 = [
    GoogleFonts.roboto()
        .copyWith(fontSize: 16, height: 1.4, color: const Color(0xff888888))
  ];
  static List<TextStyle> orderTileAddress = [
    GoogleFonts.roboto().copyWith(fontSize: 16, fontWeight: FontWeight.w700)
  ];
  static List<TextStyle> orderTilePickupText = [
    GoogleFonts.roboto().copyWith(
        fontSize: 16, fontWeight: FontWeight.w700, color: superfleetGrey[0])
  ];
  static List<BoxDecoration> appbarDecoration = [
    const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color(0xFFCCCCCC),
          blurRadius: 0.0, // no blur
          spreadRadius: 1.0, // spread as far as 1px
          offset: Offset(0.0, 1.0), // Offset downwards
        ),
      ],
    ),
  ];
  static List<BoxDecoration> borderDecoration = [
    const BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Color(0xFFCCCCCC),
          width: 1.0,
        ),
      ),
    ),
  ];
  static List<Color?> primaryColor = [superfleetBlue];
  static List<Color?> secondaryColor = [superfleetGreen];
  static List<Color?> iconColor1 = [superfleetOrange];
  static List<Color?> iconColor2 = [superfleetGreen];
  static List<Color?> superfleetGrey = [const Color(0xFFCCCCCC)];
  static List<Color?> superfleetGreyOpacity = [
    const Color.fromRGBO(0, 0, 0, 0.5)
  ];

  static List<Color?> superfleetRed = [const Color(0xFFCA1E1E)];
}
