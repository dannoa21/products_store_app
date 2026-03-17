part of '../index.dart';

/// Enum representing available font families in the app.
///
/// Use [FontFamilyType] to refer to font families consistently across
/// the app. Access the capitalized name of each font with
/// [FontFamilyType.capitalizedName].
enum FontFamilyType {
  /// The Calistoga font family.
  calistoga,

  /// The Outfit font family.
  outfit,
}

/// Extension on [FontFamilyType] to provide a formatted font family name.
///
/// The [capitalizedName] getter converts the enum value to a readable
/// string with the first letter capitalized. This ensures compatibility
/// with the `fontFamily` property in Flutter's `Text` widget, allowing
/// it to recognize the font names correctly.
///
/// For example, `FontFamilyType.calistoga.capitalizedName` returns
/// `"Calistoga"`.
extension FontFamilyTypeExtension on FontFamilyType {
  /// Returns the capitalized string representation of the font family name.
  ///
  /// This format is essential for Flutter's font family properties to
  /// recognize and correctly display the specified font.
  String get capitalizedName {
    final name = toString().split('.').last;
    return name[0].toUpperCase() + name.substring(1);
  }
}
