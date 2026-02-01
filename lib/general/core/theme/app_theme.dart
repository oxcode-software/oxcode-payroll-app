import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      backgroundColor: AppColors.lightBackground,
      surfaceColor: AppColors.lightSurface,
      textColor: AppColors.textPrimaryLight,
      secondaryTextColor: AppColors.textSecondaryLight,
    );
  }

  static ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      backgroundColor: AppColors.darkBackground,
      surfaceColor: AppColors.darkSurface,
      textColor: AppColors.textPrimaryDark,
      secondaryTextColor: AppColors.textSecondaryDark,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color backgroundColor,
    required Color surfaceColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: AppColors.primary,

      // Color Scheme
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        background: backgroundColor,
        onBackground: textColor,
        surface: surfaceColor,
        onSurface: textColor,
      ),

      // Typography
      textTheme:
          GoogleFonts.outfitTextTheme(
            ThemeData(brightness: brightness).textTheme,
          ).copyWith(
            displayLarge: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 32.sp,
              letterSpacing: -1.0,
            ),
            displayMedium: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
              letterSpacing: -0.5,
            ),
            titleLarge: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              letterSpacing: -0.5,
            ),
            bodyLarge: TextStyle(color: textColor, fontSize: 16.sp),
            bodyMedium: TextStyle(color: secondaryTextColor, fontSize: 14.sp),
            labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
          ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textColor, size: 24.w),
        titleTextStyle: GoogleFonts.outfit(
          color: textColor,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
        ),
      ),

      // Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? Colors.white
            : AppColors.darkSurface,
        contentPadding: EdgeInsets.all(20.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: brightness == Brightness.light
                ? const Color(0xFFE2E8F0)
                : const Color(0xFF334155),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: TextStyle(color: secondaryTextColor, fontSize: 14.sp),
        prefixIconColor: secondaryTextColor,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: brightness == Brightness.light
                ? const Color(0xFFE2E8F0)
                : const Color(0xFF334155),
          ),
        ),
      ),

      // Bottom Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: AppColors.primary.withOpacity(0.1),
        labelTextStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: secondaryTextColor,
          ),
        ),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(color: AppColors.primary, size: 24.w);
          }
          return IconThemeData(color: secondaryTextColor, size: 24.w);
        }),
      ),
    );
  }
}
