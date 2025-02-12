import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppConstants.primaryColor,
    scaffoldBackgroundColor: AppConstants.backgroundColor,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppConstants.textColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppConstants.primaryColor,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
