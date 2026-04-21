import 'package:flutter/material.dart';

class AppColors {
  // Brand Identity
  static const Color pearGreen = Color(0xFFA8BF3F); // Primary Brand Color
  static const Color deepGreen = Color(0xFF1F3D2B); // Headings & Body Text
  // static const Color cream = Color(0xFFF6F3EA); // Main Background
  static const Color leafGreen = Color(0xFF7AA33A); // Secondary Accent
  static const Color shadowGrey = Color(0xFFD8D8D8);
  static const Color white = Color(0xFFFFFFFF);

  // Semantic Aliases
  static const Color primary = pearGreen;
  static const Color secondary = leafGreen;

  // Neutral
  // static const Color background = cream;
  static const Color surface = white;
  static const Color textPrimary = deepGreen;
  static const Color textSecondary = Color(0xFF757575);

  // Functional
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);

  // Trust & Action Palette
  static const Color offWhite = Color(0xFFF8F9FA); // The new main background
  static const Color coralAction = Color(0xFFE05D3A); // For primary buttons
  static const Color slateTrust = Color(0xFF2A4365); // For headers/text
  static const Color amberAlert = Color(0xFFF2A900); // For warnings
  static const Color emeraldSuccess = Color(0xFF00A859); // For success states
}
