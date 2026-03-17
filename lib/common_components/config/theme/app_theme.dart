part of '../index.dart';

/// Centralized application theme.
///
/// This acts as the foundation of the design system:
/// - Defines colors using [ColorScheme]
/// - Standardizes typography
/// - Provides consistent component styling (buttons, inputs, cards)
/// - Supports extensibility via [ThemeExtension]
class AppTheme {
  static ThemeData get light {
    /// Primary brand color used across the app
    const primaryColor = Color(0xFF3A6DBA);

    /// Material 3 color system
    ///
    /// Using ColorScheme ensures:
    /// - Easy dark mode support later
    /// - Consistent color usage across components
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

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      /// Global font family
      fontFamily: 'Outfit',

      /// Typography system
      ///
      /// Note:
      /// - Avoid hardcoded colors like Colors.white
      /// - Always rely on colorScheme for adaptability
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

          /// Slightly reduced opacity for secondary text
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),

      /// Elevated button styling
      ///
      /// Ensures all primary buttons look consistent across the app
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

      /// Input field styling (TextField, TextFormField)
      ///
      /// Provides consistent look for all input components
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      /// Card styling
      ///
      /// Used for containers, list items, etc.
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      /// Bottom sheet styling
      bottomSheetTheme: const BottomSheetThemeData(
        dragHandleColor: Color(0x2972767A),
      ),

      /// Custom theme extensions
      ///
      /// Used for semantic colors that are not part of Material defaults
      /// (e.g., success, warning, info)
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
