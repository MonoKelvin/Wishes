import 'package:flutter/material.dart';

import '../../app/theme.dart';

class TagSelector extends StatelessWidget {
  final List<String> availableTags;
  final List<String> selectedTags;
  final ValueChanged<List<String>> onTagsChanged;

  const TagSelector({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppTheme.spacingXS,
      runSpacing: AppTheme.spacingXS,
      children: availableTags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return FilterChip(
          label: Text(tag),
          selected: isSelected,
          onSelected: (selected) {
            final newTags = List<String>.from(selectedTags);
            if (selected) {
              newTags.add(tag);
            } else {
              newTags.remove(tag);
            }
            onTagsChanged(newTags);
          },
        );
      }).toList(),
    );
  }
}
