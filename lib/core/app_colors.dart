import 'package:flutter/material.dart';

class AppColors {
  // Primary & Accent
  static const Color primary = Color(0xFFC6FF00); // Electric Lime
  static const Color accent = Color(0xFF00E5FF);  // Cyan

  // Backgrounds
  static const Color background = Color(0xFF121212); // Deep Slate/Black
  static const Color surface = Color(0xFF1E1E1E);    // Lighter Slate
  
  // States
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF69F0AE);
  static const Color warning = Color(0xFFFFD740);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  
  // Gradients
  static const LinearGradient sportyGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
