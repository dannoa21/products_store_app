part of 'index.dart';

class ProductHomeScreen extends StatelessWidget {
  const ProductHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Product Detail'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RouteNames.productDetail,
              arguments: '123', // example product ID
            );
          },
        ),
      ),
    );
  }
}
