import '../../core/error/exceptions.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../mappers/project_mapper.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final LocalDataSource _localDataSource;

  ProjectRepositoryImpl({
    required LocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<List<Project>> getProjects() async {
    try {
      final localProjects = _localDataSource.getAllProjects();
      return localProjects.map((e) => ProjectMapper.toEntity(e)).toList();
    } catch (e) {
      throw CacheException('获取项目列表失败: $e');
    }
  }

  @override
  Future<Project> getProject(String id) async {
    try {
      final localProject = _localDataSource.getProject(id);
      if (localProject == null) {
        throw CacheException('项目不存在');
      }
      return ProjectMapper.toEntity(localProject);
    } catch (e) {
      throw CacheException('获取项目失败: $e');
    }
  }

  @override
  Future<Project> createProject({
    required String name,
    required String scene,
    required List<String> tags,
  }) async {
    try {
      final now = DateTime.now();
      final id = now.millisecondsSinceEpoch.toString();

      final project = Project(
        id: id,
        name: name,
        scene: scene,
        tags: tags,
        categories: [],
        createdAt: now,
        updatedAt: now,
        isPinned: false,
        isCompleted: false,
        productCount: 0,
        totalPrice: 0,
      );

      final localProject = ProjectMapper.toLocal(project);
      await _localDataSource.saveProject(localProject);

      return project;
    } catch (e) {
      throw CacheException('创建项目失败: $e');
    }
  }

  @override
  Future<Project> updateProject({
    required String id,
    String? name,
    String? scene,
    List<String>? tags,
  }) async {
    try {
      final localProject = _localDataSource.getProject(id);
      if (localProject == null) {
        throw CacheException('项目不存在');
      }

      final project = ProjectMapper.toEntity(localProject);
      final updatedProject = project.copyWith(
        name: name ?? project.name,
        scene: scene ?? project.scene,
        tags: tags ?? project.tags,
        updatedAt: DateTime.now(),
      );

      final updatedLocalProject = ProjectMapper.toLocal(updatedProject);
      await _localDataSource.saveProject(updatedLocalProject);

      return updatedProject;
    } catch (e) {
      throw CacheException('更新项目失败: $e');
    }
  }

  @override
  Future<void> deleteProject(String id) async {
    try {
      await _localDataSource.deleteProject(id);
    } catch (e) {
      throw CacheException('删除项目失败: $e');
    }
  }

  @override
  Future<void> togglePin(String id) async {
    try {
      final localProject = _localDataSource.getProject(id);
      if (localProject == null) {
        throw CacheException('项目不存在');
      }

      final project = ProjectMapper.toEntity(localProject);
      final updatedProject = project.copyWith(
        isPinned: !project.isPinned,
        updatedAt: DateTime.now(),
      );

      final updatedLocalProject = ProjectMapper.toLocal(updatedProject);
      await _localDataSource.saveProject(updatedLocalProject);
    } catch (e) {
      throw CacheException('更新项目置顶状态失败: $e');
    }
  }

  @override
  Future<void> markComplete(String id) async {
    try {
      final localProject = _localDataSource.getProject(id);
      if (localProject == null) {
        throw CacheException('项目不存在');
      }

      final project = ProjectMapper.toEntity(localProject);
      final updatedProject = project.copyWith(
        isCompleted: true,
        updatedAt: DateTime.now(),
      );

      final updatedLocalProject = ProjectMapper.toLocal(updatedProject);
      await _localDataSource.saveProject(updatedLocalProject);
    } catch (e) {
      throw CacheException('标记项目完成失败: $e');
    }
  }
}
