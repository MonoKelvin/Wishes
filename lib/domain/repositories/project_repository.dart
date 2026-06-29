import '../entities/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects();
  Future<Project> getProject(String id);
  Future<Project> createProject({
    required String name,
    required String scene,
    required List<String> tags,
  });
  Future<Project> updateProject({
    required String id,
    String? name,
    String? scene,
    List<String>? tags,
  });
  Future<void> deleteProject(String id);
  Future<void> togglePin(String id);
  Future<void> markComplete(String id);
}
