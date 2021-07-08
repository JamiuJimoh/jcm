import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static AppTheme themeData = AppTheme._();

  static const Color _darkPrimaryColor = Color(0xFF512DA8);
  static const Color _lightPrimaryColor = Color(0xFFD1C4E9);
  static const Color _primaryColor = Color(0xFF673AB7);
  static const Color _textColor = Color(0xFFFFFFFF);
  static const Color _accentColor = Color(0xFFFF5722);
  static const Color _primaryTextColor = Color(0xFF212121);
  static const Color _secondaryTextColor = Color(0xFF757575);
  static const Color _dividerColor = Color(0xFFBDBDBD);

  static final ThemeData lightMode = ThemeData(
    primarySwatch: Colors.deepPurple,
    accentColor: Colors.deepOrange,
    appBarTheme: AppBarTheme(elevation: 0.5),
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: Colors.grey[200],
    brightness: Brightness.light,
  );
  static final ThemeData darkMode = ThemeData(
    primarySwatch: Colors.deepPurple,
    accentColor: Colors.deepOrange,
    appBarTheme: AppBarTheme(elevation: 0.5),
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: Colors.black38,
    brightness: Brightness.dark,
  );
}
