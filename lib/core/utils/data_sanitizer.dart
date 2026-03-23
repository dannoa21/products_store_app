import 'package:flutter/foundation.dart';

class DataSanitizer {
  const DataSanitizer._();

  static const double invalidPrice = -1.0;

  static void logWarning(String message) {
    debugPrint('Product data warning: $message');
  }

  static void logError(String message) {
    debugPrint('Product data error: $message');
  }

  static bool isValidImageUrl(dynamic value) {
    if (value is! String || value.trim().isEmpty) return false;
    final uri = Uri.tryParse(value.trim());
    bool isValid =
        uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        (uri.host.isNotEmpty);

    if (!isValid) {
      logWarning('Invalid image URL: $value');
    }
    return isValid;
  }

  static String readString(
    Map<String, dynamic> data,
    String key, {
    required String fallback,
  }) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return fallback;
  }

  static int readInt(
    Map<String, dynamic> data,
    String key, {
    int fallback = -1,
  }) {
    final value = data[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return fallback;
  }

  static double readDouble(
    Map<String, dynamic> data,
    String key, {
    required double fallback,
  }) {
    final value = data[key];
    if (value is num) return value.toDouble();
    return fallback;
  }

  static double readPrice(
    Map<String, dynamic> data, {
    required String context,
    String key = 'price',
  }) {
    final value = data[key];
    if (value is num && value >= 0) {
      return value.toDouble();
    }
    logError(
      'Invalid or missing price for $context. value=$value. Using unavailable price.',
    );
    return invalidPrice;
  }

  static String readImageUrl(
    Map<String, dynamic> data, {
    required String key,
    required String context,
  }) {
    final value = data[key];
    if (isValidImageUrl(value)) {
      return (value as String).trim();
    }
    logWarning(
      'Invalid or missing image URL for $context.$key. value=$value. Using placeholder.',
    );
    return '';
  }

  static List<String> readImageList(
    Map<String, dynamic> data, {
    required String key,
    required String context,
  }) {
    final raw = data[key];
    if (raw is! List) {
      logWarning(
        'Missing or invalid image list for $context.$key. value=$raw. Using placeholder.',
      );
      return const [];
    }

    final validUrls = raw
        .where(isValidImageUrl)
        .map((e) => e.toString().trim())
        .toList();
    if (validUrls.isEmpty) {
      logWarning('No valid image URLs for $context.$key. Using placeholder.');
    }
    return validUrls;
  }
}
