import 'package:flutter/material.dart';
import 'package:products_store_app/common_components/config/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode
          .light, // automatic switching //TODO: Add in-app toggle for theme mode
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
    );
  }
}
