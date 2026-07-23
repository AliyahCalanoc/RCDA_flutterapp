import 'package:flutter/material.dart';

/// Global light/dark toggle. Screens read [AppColors] fields directly
/// (no context needed), so toggling this and rebuilding the root is
/// enough to re-theme the whole app — no per-screen changes required.
class ThemeController {
  static final ValueNotifier<bool> isDark = ValueNotifier<bool>(false);
  static void toggle() => isDark.value = !isDark.value;
}

/// RC Driving Academy brand palette.
/// Brand/status colors stay constant across modes; surfaces and text
/// colors flip between a dark theme and a warm light theme (closer to
/// the Recipe Finder reference, which uses a soft cream light mode).
class AppColors {
  // Brand — unchanged in both modes
  static const Color primaryRed = Color(0xFFB3261E);
  static const Color primaryRedDark = Color(0xFF7A1B16);
  static const Color accentOrange = Color(0xFFE8862E);

  // Status — unchanged in both modes
  static const Color success = Color(0xFF4CAF6D);
  static const Color warning = Color(0xFFE8B23E);
  static const Color danger = Color(0xFFE85C4A);

  static bool get _dark => ThemeController.isDark.value;

  static Color get background =>
      _dark ? const Color(0xFF121212) : const Color(0xFFFAF6EF);
  static Color get surface =>
      _dark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
  static Color get surfaceElevated =>
      _dark ? const Color(0xFF262626) : const Color(0xFFF3EEE4);
  static Color get border =>
      _dark ? const Color(0xFF2E2E2E) : const Color(0xFFE8E1D3);

  static Color get textPrimary =>
      _dark ? const Color(0xFFF5F5F5) : const Color(0xFF231F1C);
  static Color get textSecondary =>
      _dark ? const Color(0xFFA3A3A3) : const Color(0xFF756E63);
  static Color get textMuted =>
      _dark ? const Color(0xFF6B6B6B) : const Color(0xFFA39A8B);
}

class AppTheme {
  /// Builds a ThemeData snapshot for whatever mode is currently active.
  /// Call this fresh every time [ThemeController.isDark] changes.
  static ThemeData get current {
    final brightness = AppColors._dark ? Brightness.dark : Brightness.light;
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primaryRed,
        secondary: AppColors.accentOrange,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: DividerThemeData(color: AppColors.border, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: AppColors.textMuted),
      ),
    );
  }
}
