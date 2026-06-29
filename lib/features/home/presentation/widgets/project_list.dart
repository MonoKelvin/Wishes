import 'package:flutter/material.dart';

import '../../../../domain/entities/project.dart';
import 'project_card.dart';

class ProjectList extends StatelessWidget {
  final List<Project> projects;

  const ProjectList({
    super.key,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    // 排序：置顶的在前面，然后按更新时间倒序
    final sortedProjects = List<Project>.from(projects)
      ..sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });

    return ListView.builder(
      itemCount: sortedProjects.length,
      itemBuilder: (context, index) {
        return ProjectCard(project: sortedProjects[index]);
      },
    );
  }
}
