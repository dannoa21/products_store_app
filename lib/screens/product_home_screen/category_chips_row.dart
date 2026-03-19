import 'package:flutter/material.dart';
import 'package:products_store_app/features/product/domain/value_objects/category.dart';

class CategoryChipsRow extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategorySlug; // <- slug
  final Function(String?) onSelected; // <- slug or null

  const CategoryChipsRow({
    super.key,
    required this.categories,
    required this.selectedCategorySlug,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.map((category) {
          final isSelected = category.slug == selectedCategorySlug;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category.name),
              selected: isSelected,
              onSelected: (_) => onSelected(isSelected ? null : category.slug),
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
