import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../domain/entities/category.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryTile({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppTheme.spacingXS),
      child: FilterChip(
        label: Text(category.name),
        selected: isSelected,
        onSelected: onTap != null ? (_) => onTap!() : null,
      ),
    );
  }
}
