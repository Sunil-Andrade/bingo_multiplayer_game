import 'package:flutter/material.dart';

/// App-wide design constants.
abstract final class AppColors {
  // Brand
  static const Color coral = Color(0xFFFF6F61);
  static const Color mint = Color(0xFFE8F5F0);
  static const Color charcoal = Color(0xFF2D3436);

  // Backgrounds
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);

  // Neutral
  static const Color border = Color(0xFFE0E0E0);
  static const Color mutedText = Color(0xFF7A8082);
  static const Color disabled = Color(0xFFF2F2F2);

  // Game states
  static const Color selected = coral;
  static const Color active = coral;
  static const Color hover = mint;
  static const Color inactive = mint;
}

/// Spacing based on an 8px grid.
abstract final class AppSpacing {
  static const double xs = 8.0;
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 40.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

/// Border radius constants.
abstract final class AppRadius {
  static const double card = 16.0;
  static const double input = 16.0;
  static const double button = 999.0;
  static const double chip = 999.0;
}

/// App shadows.
abstract final class AppShadows {
  static const List<BoxShadow> softFloat = [
    BoxShadow(
      color: Color.fromRGBO(45, 52, 54, 0.05),
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];
}

/// Common borders.
abstract final class AppBorders {
  static const Border charcoal = Border.fromBorderSide(
    BorderSide(color: AppColors.charcoal, width: 2.0),
  );

  static const Border light = Border.fromBorderSide(
    BorderSide(color: AppColors.border, width: 2.0),
  );
}

/// Common text styles.
///
/// Requires Quicksand to be added to pubspec.yaml.
abstract final class AppTextStyles {
  static const String fontFamily = 'Quicksand';

  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.charcoal,
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.charcoal,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.charcoal,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.charcoal,
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static const TextStyle number = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.charcoal,
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
  );
}

/// Common input decoration.
abstract final class AppInputStyles {
  static InputDecoration decoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.mint,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.coral, width: 2.0),
      ),
    );
  }
}

/// Main application theme.
abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,

      fontFamily: AppTextStyles.fontFamily,

      colorScheme: const ColorScheme.light(
        primary: AppColors.coral,
        onPrimary: AppColors.white,
        secondary: AppColors.mint,
        onSecondary: AppColors.charcoal,
        surface: AppColors.white,
        onSurface: AppColors.charcoal,
        error: AppColors.coral,
        onError: AppColors.white,
      ),

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.heading,
        headlineMedium: AppTextStyles.title,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.label,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coral,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: const StadiumBorder(),
          textStyle: AppTextStyles.button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.charcoal,
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.charcoal, width: 2.0),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: const StadiumBorder(),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.charcoal),
        ),
      ),
    );
  }
}
