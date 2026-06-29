import 'package:flutter/material.dart';

import '../../app/theme.dart';

class SceneSelector extends StatelessWidget {
  final List<String> scenes;
  final String selectedScene;
  final ValueChanged<String> onSceneSelected;

  const SceneSelector({
    super.key,
    required this.scenes,
    required this.selectedScene,
    required this.onSceneSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppTheme.spacingXS,
      runSpacing: AppTheme.spacingXS,
      children: scenes.map((scene) {
        final isSelected = selectedScene == scene;
        return ChoiceChip(
          label: Text(scene),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onSceneSelected(scene);
            }
          },
        );
      }).toList(),
    );
  }
}
