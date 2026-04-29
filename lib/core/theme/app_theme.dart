import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryLight,
          onPrimaryContainer: Colors.white,
          secondary: AppColors.accent,
          onSecondary: Colors.white,
          secondaryContainer: Color(0xFFFFF3E0),
          onSecondaryContainer: AppColors.textPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.statusCritical,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          titleTextStyle: AppTextStyles.heading3.copyWith(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: AppDim.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDim.radiusL),
          ),
          color: AppColors.surface,
          margin: EdgeInsets.zero,
          surfaceTintColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDim.radiusM),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: AppTextStyles.buttonText,
            minimumSize: const Size(double.infinity, AppDim.buttonHeight),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDim.radiusM),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: AppTextStyles.buttonText,
            minimumSize: const Size(double.infinity, AppDim.buttonHeight),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.buttonText,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            borderSide: const BorderSide(color: AppColors.statusCritical),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDim.radiusM),
            borderSide: const BorderSide(color: AppColors.statusCritical, width: 2),
          ),
          labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textDisabled),
          errorStyle: AppTextStyles.body2.copyWith(color: AppColors.statusCritical),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDim.radiusRound),
          ),
          side: const BorderSide(color: AppColors.border),
          labelStyle: AppTextStyles.body2,
          backgroundColor: AppColors.surface,
          selectedColor: AppColors.primary,
          secondaryLabelStyle: AppTextStyles.body2.copyWith(color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: AppDim.paddingS, vertical: AppDim.paddingXS),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: AppDim.paddingM),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDim.radiusM),
          ),
        ),
      );
}
