import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle h1 = TextStyle(
    fontFamily: 'PermanentMarker',
    fontSize: 30,
    color: AppColors.red,
    height: 1.1,
  );

  static const TextStyle logo = TextStyle(
    fontFamily: 'PermanentMarker',
    fontSize: 22,
    color: AppColors.white,
    letterSpacing: 4,
  );

  static const TextStyle eyebrow = TextStyle(
    fontFamily: 'Audiowide',
    color: AppColors.green,
    letterSpacing: 2,
  );

  static const TextStyle tagline = TextStyle(
    fontFamily: 'Audiowide',
    fontSize: 12,
    letterSpacing: 3,
  );

  static const TextStyle sectionLabel = TextStyle(
    fontFamily: 'Audiowide',
    color: AppColors.muted,
    letterSpacing: 4,
  );
}
