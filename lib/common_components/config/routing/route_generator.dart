part of '../index.dart';

/// Simple route generator for the product app.
/// Only handles ProductHomeScreen and ProductDetailScreen.
class RouteGenerator {
  /// Generates routes based on [settings.name].
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.productHome:
        return MaterialPageRoute(
          builder: (_) => const ProductHomeScreen(),
        );

      case RouteNames.productDetail:
        // Expecting the product ID to be passed as an argument
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );
      case RouteNames.testing:
        return MaterialPageRoute(builder: (_) => const TestingScreen());

      default:
        // Fallback screen if route is not found
        return MaterialPageRoute(builder: (_) => const TestingScreen());
    }
  }
}
