part of '../index.dart';

/// Centralized application theme.
/// Supports both light and dark modes.
/// Acts as the foundation of the design system:
/// - Defines colors using [ColorScheme]
/// - Standardizes typography
/// - Provides consistent component styling (buttons, inputs, cards)
/// - Supports extensibility via [ThemeExtension]
class AppTheme {
  /// Light mode theme
  static ThemeData get light {
    const primaryColor = Color(0xFF3A6DBA);

    final colorScheme = ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: const Color(0xFF007AFE),
      onSecondary: Colors.white,
      surface: const Color(0xFFF8F8F8),
      onSurface: const Color(0xFF1A1A1A),
      error: const Color(0xFFFC0330),
      onError: Colors.white,
    );

    return _buildTheme(colorScheme);
  }

  /// Dark mode theme
  static ThemeData get dark {
    const primaryColor = Color(0xFF3A6DBA);

    final colorScheme = ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: const Color(0xFF007AFE),
      onSecondary: Colors.black,
      surface: const Color(0xFF1E1E1E),
      onSurface: Colors.white,
      error: const Color(0xFFFC0330),
      onError: Colors.black,
    );

    return _buildTheme(colorScheme);
  }

  /// Shared theme builder for both light and dark
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Outfit',

      /// Typography
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),

      /// Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      /// Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      /// Cards
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      /// Bottom sheets
      bottomSheetTheme: const BottomSheetThemeData(
        dragHandleColor: Color(0x2972767A),
      ),

      /// Custom semantic colors
      extensions: const [
        AppColorsExtension(
          success: Color(0xFF37C83D),
          warning: Color(0xFFFFA726),
          info: Color(0xFF007AFE),
        ),
      ],
    );
  }
}
