import 'package:flutter/material.dart';

/// Centralized color palette derived from the Chat Zone app icon.
/// Do not use raw Color values anywhere else in the app — always
/// reference these constants so the palette stays consistent.
class AppColors {
  AppColors._();

  // Brand colors
  static const Color primaryTeal = Color(0xFF1DBF9B);
  static const Color primaryTealDark = Color(0xFF149A7C);
  static const Color primaryTealLight = Color(0xFF5FE0C4);

  static const Color navyDeep = Color(0xFF0B1E33);
  static const Color navySurface = Color(0xFF132C48);
  static const Color navySurfaceElevated = Color(0xFF1B3B5C);

  static const Color slate = Color(0xFF6B7A8D);
  static const Color slateLight = Color(0xFF9BAAC0);

  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);

  static const Color errorRed = Color(0xFFE14B4B);
  static const Color warningAmber = Color(0xFFE0A730);

  // Message bubble colors
  static const Color bubbleSentLight = primaryTeal;
  static const Color bubbleReceivedLight = Color(0xFFEDEFF2);
  static const Color bubbleSentDark = primaryTealDark;
  static const Color bubbleReceivedDark = navySurfaceElevated;

  // Status
  static const Color onlineGreen = Color(0xFF3DDC84);
}
