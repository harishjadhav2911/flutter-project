import 'package:flutter/material.dart';

/// AppColors defines the central color palette for FlixGo.
/// Inspired by Netflix's sleek dark theme with signature red accents.
class AppColors {
  // Brand Colors
  static const Color primaryRed = Color(0xFFE50914);
  static const Color primaryRedHover = Color(0xFFF40612);
  static const Color accentRedGlow = Color(0x66E50914);

  // Backgrounds
  static const Color background = Color(0xFF09090D);
  static const Color backgroundSecondary = Color(0xFF111118);
  static const Color surface = Color(0xFF161622);
  static const Color surfaceLight = Color(0xFF222232);
  static const Color surfaceBorder = Color(0xFF2D2D42);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA6A6BD);
  static const Color textMuted = Color(0xFF6E6E87);

  // Status & Badges
  static const Color starGold = Color(0xFFFFB800);
  static const Color badgeBg = Color(0x33E50914);
  static const Color greenTag = Color(0xFF46D369);

  // Overlays & Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0x8009090D), Color(0xFF09090D)],
    stops: [0.3, 0.7, 1.0],
  );

  static const LinearGradient horizontalVignette = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xE609090D), Color(0x9909090D), Colors.transparent],
    stops: [0.0, 0.4, 0.9],
  );

  static const LinearGradient cardOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC09090D), Color(0xF009090D)],
    stops: [0.4, 0.8, 1.0],
  );
}
