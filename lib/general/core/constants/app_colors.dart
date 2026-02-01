import 'package:flutter/material.dart';

class AppColors {
  // Brand Identity
  static const Color primary = Color(0xFF48B1A2); // Requested Theme
  static const Color primaryDark = Color(0xFF48B1A2); // Slightly darker teal
  static const Color primaryLight = Color(0xFF99F6E4); // Teal 200
  static const Color accent = Color(
    0xFF2DD4BF,
  ); // Using same primary for accent or could use the other teal

  // Neutral Scales (SaaS Greys)
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color lightBackground = Color(0xFFFFFFFF); // Pure White
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure White

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Semantics
  static const Color secondary = Color(0xFF2CB9B0); // Teal shade
  static const Color success = Color(0xFF2CB9B0); // Using same teal for success
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF2CB9B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Colors.white24, Colors.white10],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: const Color(0xFF64748B).withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: const Color(0xFF64748B).withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF64748B).withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: const Color(0xFF64748B).withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: const Color(0xFF64748B).withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}
