// theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary500,
    pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(), // iOS-style swipe
            TargetPlatform.android: CupertinoPageTransitionsBuilder(), // Enable swipe on Android too
          },
        ),
    // scaffoldBackgroundColor: AppColors.primary50,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary500,
      secondary: AppColors.secondary600,
      error: AppColors.negative500,
      
    ),

  );

  static ThemeData darkTheme = ThemeData(

  );
}