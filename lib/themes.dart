import 'package:flutter/material.dart';

import 'constants.dart';

///custom themes

class MyThemes {
  static ThemeData myDarkMode = ThemeData.dark().copyWith(
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd1261b),
      onPrimary: Colors.white,
      secondary: Color(0xff03DAC6),
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white70,
      background: Color(0xff1e234c),
      onBackground: Color(0xffA4A4A4),
      surface: Color(0xff1e234c),
      onSurface: Color(0xffD7D7D7),
      secondaryContainer: Color(0xff42476b),
      onSecondaryContainer: Colors.white,
    ),
    textTheme: kMyTextTheme,
  );

  static ThemeData myLightMode = ThemeData.light().copyWith(
    splashColor: Colors.transparent,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xffd1261b),
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white70,
      background: Colors.white,
      onBackground: Colors.black,
      surface: const Color(0xfff4f6f9),
      onSurface: Colors.black,
      secondaryContainer: const Color(0xffffffff),
      onSecondaryContainer: Colors.black,
    ),
    textTheme: kMyTextTheme,
  );
}
