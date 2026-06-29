import '../../entities/project.dart';
import '../../repositories/project_repository.dart';

class CreateProjectUseCase {
  final ProjectRepository _repository;

  CreateProjectUseCase(this._repository);

  Future<Project> call({
    required String name,
    required String scene,
    required List<String> tags,
  }) async {
    return await _repository.createProject(
      name: name,
      scene: scene,
      tags: tags,
    );
  }
}
