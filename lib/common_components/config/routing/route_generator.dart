part of '../index.dart';

/// Simple route generator for the product app.
/// Only handles ProductHomeScreen and ProductDetailScreen.
class RouteGenerator {
  /// Generates routes based on [settings.name].
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.productHome:
        //TODO: MOVE THE BLOC PROVIDER here
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (context) =>
                  ProductCubit(repository: context.read<ProductRepository>()),
              child: ProductHomeScreen(),
            );
          },
        );

      case RouteNames.productDetail:
        // Expecting the product ID to be passed as an argument
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProductDetailCubit(
              repository: context.read<ProductRepository>(),
            )..fetchProductDetail(productId),
            child: ProductDetailScreen(productId: productId),
          ),
        );
      case RouteNames.testing:
        return MaterialPageRoute(builder: (_) => const TestingScreen());

      default:
        // Fallback screen if route is not found
        return MaterialPageRoute(builder: (_) => const TestingScreen());
    }
  }
}
