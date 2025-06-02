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
      secondary: Color(0xffcb3b36),
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
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffd1261b),
      onPrimary: Colors.white,
      secondary: Color(0xffcb3b36),
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white70,
      background: Colors.white,
      onBackground: Colors.black,
      //surface: Color(0xffF6FAF8),
      surface: Color(0xffFDFDFD),
      onSurface: Colors.black,
      secondaryContainer: Color(0xffffffff),
      onSecondaryContainer: Colors.black,
    ),
    textTheme: kMyTextTheme,
  );
}
