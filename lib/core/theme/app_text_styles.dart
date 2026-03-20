// lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _serif = 'PlayfairDisplay';
  static const String _sans = 'DMSans';

  // Display / Hero
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _serif,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _serif,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.25,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _serif,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _serif,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _serif,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.4,
  );

  // Label / UI
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
    letterSpacing: 0.5,
  );

  // Price
  static const TextStyle priceHero = TextStyle(
    fontFamily: _sans,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle priceLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle priceMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle priceStrike = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    decoration: TextDecoration.lineThrough,
  );

  // Button
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
    letterSpacing: 0.5,
  );

  static const TextStyle captionBold = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
}
