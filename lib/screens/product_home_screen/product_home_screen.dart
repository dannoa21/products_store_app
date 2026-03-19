part of 'index.dart';

class ProductHomeScreen extends StatefulWidget {
  const ProductHomeScreen({super.key});

  @override
  State<ProductHomeScreen> createState() => _ProductHomeScreenState();
}

class _ProductHomeScreenState extends State<ProductHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Initial fetch
    context.read<ProductCubit>().fetchProducts();

    /// Infinite scroll
    _scrollController.addListener(_paginationListener);
  }

  void _paginationListener() {
    if (_scrollController.position.pixels + 100 >
        _scrollController.position.maxScrollExtent) {
      context.read<ProductCubit>().fetchMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    context.read<ProductCubit>().fetchProducts(query: _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          /// 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _onSearch(),
              decoration: InputDecoration(
                hintText: 'Search products...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ),
            ),
          ),

          // 2️⃣ Category chips
          BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoaded) {
                return CategoryChipsRow(
                  categories: state.categories,
                  selectedCategorySlug: state.selected?.slug,
                  onSelected: (nameOrNull) {
                    final loaded = state;
                    final selectedCategory = nameOrNull == null
                        ? null
                        : loaded.categories.firstWhere(
                            (c) => c.slug == nameOrNull,
                          );
                    context.read<CategoryCubit>().selectCategory(
                      selectedCategory,
                    );
                    final query = _searchController.text;
                    context.read<ProductCubit>().fetchProducts(
                      query: query.isEmpty ? null : query,
                      category:
                          selectedCategory?.slug, // slug goes to products API
                    );
                  },
                );
              }

              // if (state is CategoryLoading) {
              //   return const SizedBox(
              //     height: 48,
              //     child: Center(child: CircularProgressIndicator()),
              //   );
              // }
              // if (state is CategoryError) {
              //   return Padding(
              //     padding: const EdgeInsets.all(12),
              //     child: Text('Failed to load categories'),
              //   );
              // }
              // maybe handle initial state or other states if needed (doesn't seem like it'll be needed)
              return const SizedBox.shrink();
            },
          ),

          /// 📦 Product list
          Expanded(
            child: BlocConsumer<ProductCubit, ProductState>(
              listener: (context, state) {
                if (state is ProductError && state.products.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      action: SnackBarAction(
                        label: 'Retry',
                        onPressed: () {
                          context.read<ProductCubit>().fetchMoreProducts();
                        },
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                /// Initial loading
                if (state is ProductLoading && state.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                /// Error (with empty list)
                if (state is ProductError && state.products.isEmpty) {
                  return Center(child: Text(state.message));
                }

                final products = state.products;

                if (products.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: products.length + 1, // +1 for loader
                  itemBuilder: (context, index) {
                    if (index == products.length) {
                      /// Bottom loader
                      if (state is ProductLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    }

                    final product = products[index];

                    return ProductCard(
                      product: product,
                      onTap: () {
                        // Navigate later
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Products')),
  //     body: Center(
  //       child: ElevatedButton(
  //         child: const Text('Go to Product Detail'),
  //         onPressed: () {
  //           Navigator.pushNamed(
  //             context,
  //             RouteNames.productDetail,
  //             arguments: '123', // example product ID
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
}
