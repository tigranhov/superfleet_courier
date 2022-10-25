import 'package:flutter/material.dart';
import 'package:superfleet_courier/theme/colors.dart';

class ColorTheme extends ThemeExtension<ColorTheme> {
  const ColorTheme(
      {this.primaryColor = superfleetBlue,
      this.secondaryColor = superfleetGreen,
      this.iconColor1 = superfleetOrange,
      this.iconColor2 = superfleetGreen});

  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? iconColor1;
  final Color? iconColor2;

  @override
  ThemeExtension<ColorTheme> lerp(ThemeExtension<ColorTheme>? other, double t) {
    if (other is! ColorTheme) {
      return this;
    }
    return ColorTheme(
        primaryColor: Color.lerp(primaryColor, other.primaryColor, t),
        secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t),
        iconColor1: Color.lerp(iconColor1, other.iconColor1, t),
        iconColor2: Color.lerp(iconColor2, other.iconColor2, t));
  }

  @override
  ThemeExtension<ColorTheme> copyWith(
      {Color? primaryColor,
      Color? secondaryColor,
      Color? iconColor1,
      Color? iconColor2}) {
    return ColorTheme(
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        iconColor1: iconColor1 ?? this.iconColor1,
        iconColor2: iconColor2 ?? this.iconColor2);
  }
}
