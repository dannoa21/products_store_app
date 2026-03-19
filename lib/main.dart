import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_store_app/common_components/config/index.dart';
import 'package:products_store_app/core/network/network_service.dart';
import 'package:products_store_app/features/product/data/repositories/category_remote_repository.dart';
import 'package:products_store_app/features/product/data/repositories/product_remote_repository.dart';
import 'package:products_store_app/features/product/domain/repositories/category_repository.dart';
import 'package:products_store_app/features/product/domain/repositories/product_repository.dart';
import 'package:products_store_app/features/product/presentation/blocs/category_cubit.dart';
import 'package:products_store_app/features/product/presentation/blocs/product_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => NetworkImplService()),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRemoteRepository(
            networkService: context.read<NetworkImplService>(),
          ),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRemoteRepository(
            networkService: context.read<NetworkImplService>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProductCubit(repository: context.read<ProductRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                CategoryCubit(repository: context.read<CategoryRepository>())
                  ..fetchCategories(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode
              .light, // automatic switching //TODO: Add in-app toggle for theme mode
          onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
        ),
      ),
    );
  }
}
