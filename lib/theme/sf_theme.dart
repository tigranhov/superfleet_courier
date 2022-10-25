import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'sf_theme.tailor.dart';

@Tailor(themes: ['light'])
class _$SFTheme {
  static List<TextStyle> text12 = [
    GoogleFonts.roboto().copyWith(fontSize: 12.sp, color: Color(0xff000000))
  ];

  static List<TextStyle> text12grey = [
    GoogleFonts.roboto().copyWith(fontSize: 12.sp, color: superfleetGrey)
  ];
  static List<TextStyle> text12w700 = [
    GoogleFonts.roboto().copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700)
  ];
  static List<TextStyle> text12w700grey = [
    GoogleFonts.roboto().copyWith(
        fontSize: 12.sp, fontWeight: FontWeight.w700, color: superfleetGrey)
  ];
  static List<TextStyle> text14 = [
    GoogleFonts.roboto().copyWith(fontSize: 14.sp)
  ];
  static List<TextStyle> text14w700 = [
    GoogleFonts.roboto().copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700)
  ];
  static List<TextStyle> text14w700grey = [
    GoogleFonts.roboto().copyWith(
        fontSize: 14.sp, color: superfleetGrey, fontWeight: FontWeight.w700)
  ];
  static List<TextStyle> text14grey = [
    GoogleFonts.roboto().copyWith(fontSize: 14.sp, color: superfleetGrey)
  ];

  static List<Color?> primaryColor = [superfleetBlue];
  static List<Color?> secondaryColor = [superfleetGreen];
  static List<Color?> iconColor1 = [superfleetOrange];
  static List<Color?> iconColor2 = [superfleetGreen];
}
