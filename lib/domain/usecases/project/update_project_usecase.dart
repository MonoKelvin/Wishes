import '../../entities/project.dart';
import '../../repositories/project_repository.dart';

class UpdateProjectUseCase {
  final ProjectRepository _repository;

  UpdateProjectUseCase(this._repository);

  Future<Project> call({
    required String id,
    String? name,
    String? scene,
    List<String>? tags,
  }) async {
    return await _repository.updateProject(
      id: id,
      name: name,
      scene: scene,
      tags: tags,
    );
  }
}
