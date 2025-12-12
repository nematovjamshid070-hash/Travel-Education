import 'package:flutter/material.dart';

/// Centralized color system (blue-forward, high-contrast, attention-grabbing).
class AppColors {
  static const Color primary = Color(0xFF0B5FFF); // Vivid Blue
  static const Color primaryDark = Color(0xFF0847C6);
  static const Color secondary = Color(0xFF00C2FF); // Cyan highlight
  static const Color tertiary = Color(0xFF00E5A8); // Mint highlight

  static const Color background = Color(0xFFF4F8FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceTint = Color(0xFFF0F6FF);

  static const Color text = Color(0xFF0B1220);
  static const Color textSubtle = Color(0xFF4A5A73);
  static const Color border = Color(0x1A0B5FFF); // primary with alpha

  static const Color danger = Color(0xFFFF3B30);
  static const Color success = Color(0xFF1DB954);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0B5FFF),
      Color(0xFF00C2FF),
    ],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0B5FFF),
      Color(0xFF0847C6),
    ],
  );
}
