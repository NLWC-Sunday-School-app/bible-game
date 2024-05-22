import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.yellow),
    // Define other theme properties
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.indigo,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
    // Define other theme properties
  );
}
