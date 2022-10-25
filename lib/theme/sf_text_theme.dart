import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superfleet_courier/theme/colors.dart';

class SFTextTheme extends ThemeExtension<SFTextTheme> {
  const SFTextTheme(
      {this.text12,
      this.text12w700,
      this.text12grey,
      this.text14,
      this.text14w700,
      this.text14grey,
      this.text14w700grey});
  final TextStyle? text12;
  final TextStyle? text12w700;
  final TextStyle? text12grey;
  final TextStyle? text14;
  final TextStyle? text14w700;
  final TextStyle? text14w700grey;
  final TextStyle? text14grey;

  @override
  ThemeExtension<SFTextTheme> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<SFTextTheme> lerp(
      ThemeExtension<SFTextTheme>? other, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  static light() => SFTextTheme(
      text12: GoogleFonts.roboto().copyWith(fontSize: 12.sp),
      text12grey:
          GoogleFonts.roboto().copyWith(fontSize: 12.sp, color: superfleetGrey),
      text12w700: GoogleFonts.roboto()
          .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700),
      text14: GoogleFonts.roboto().copyWith(fontSize: 14.sp),
      text14grey:
          GoogleFonts.roboto().copyWith(fontSize: 14.sp, color: superfleetGrey),
      text14w700: GoogleFonts.roboto()
          .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700),
      text14w700grey: GoogleFonts.roboto().copyWith(
          fontSize: 14.sp, fontWeight: FontWeight.w700, color: superfleetGrey));
}
