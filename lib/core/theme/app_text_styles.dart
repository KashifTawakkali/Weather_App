import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const location = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16,
    fontWeight: FontWeight.w300,
  );

  static const greeting = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  static const temperature = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 58,
    fontWeight: FontWeight.w600,
    height: 1,
  );

  static const condition = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const date = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 15,
    fontWeight: FontWeight.w300,
  );

  static const informationLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );

  static const informationValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const sectionTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}
