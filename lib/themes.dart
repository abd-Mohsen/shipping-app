import 'package:flutter/material.dart';

import 'constants.dart';

///custom themes

class MyThemes {
  static ThemeData myDarkMode = ThemeData.dark().copyWith(
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      // primary: Color(0xff3864d7),
      primary: Color(0xff274a6c),
      onPrimary: Colors.white,
      secondary: Color(0xffcb3b36),
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white70,
      surface: Color(0xff272524),
      onSurface: Color(0xffd0cbcb),
      secondaryContainer: Color(0xff323333),
      secondaryFixed: Color(0xff2c2e2e),
      onSecondaryContainer: Color(0xffd0cbcb),
      primaryContainer: Color(0xffFFA500),
    ),
    textTheme: kMyTextTheme,
  );

  static ThemeData myLightMode = ThemeData.light().copyWith(
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003366),
      onPrimary: Colors.white,
      secondary: Color(0xffcb3b36),
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white70,
      //surface: Color(0xffF6FAF8),
      surface: Color(0xffe8e8e9),
      onSurface: Color(0xff666666),
      secondaryContainer: Color(0xffeeefdd),
      onSecondaryContainer: Color(0xff666666),
      primaryContainer: Color(0xffFFA500),
    ),
    textTheme: kMyTextTheme,
  );
}
