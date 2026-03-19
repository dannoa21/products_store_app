import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_store_app/features/product/domain/repositories/category_repository.dart';
import 'package:products_store_app/features/product/domain/repositories/product_repository.dart';
import 'package:products_store_app/features/product/presentation/blocs/category_cubit.dart';
import 'package:products_store_app/features/product/presentation/blocs/product_cubit.dart';
import 'package:products_store_app/screens/product_detail_screen/index.dart';
import 'package:products_store_app/screens/product_home_screen/index.dart';
import 'package:products_store_app/screens/testing_screen/index.dart';
import 'package:products_store_app/utils/constants/index.dart';

part 'theme/app_colors_extension.dart';
part 'theme/app_theme.dart';
part 'theme/font_family_types.dart';
part 'spacing/spacing.dart';
part 'routing/route_generator.dart';
