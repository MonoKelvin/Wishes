import '../../repositories/project_repository.dart';

class DeleteProjectUseCase {
  final ProjectRepository _repository;

  DeleteProjectUseCase(this._repository);

  Future<void> call(String id) async {
    await _repository.deleteProject(id);
  }
}
