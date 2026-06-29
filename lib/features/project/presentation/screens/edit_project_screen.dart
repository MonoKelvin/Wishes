import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/constants/preset_data.dart';
import '../../../../shared/widgets/scene_selector.dart';
import '../../../../shared/widgets/tag_selector.dart';
import '../../../../shared/widgets/info_row.dart';
import '../../../../domain/entities/project.dart';
import '../../providers/project_providers.dart';
import '../../../home/providers/home_providers.dart';

class EditProjectScreen extends ConsumerStatefulWidget {
  final String projectId;

  const EditProjectScreen({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedScene = presetScenes.first;
  List<String> _selectedTags = [];
  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _initializeForm(Project project) {
    if (!_isInitialized) {
      _nameController.text = project.name;
      _selectedScene = project.scene;
      _selectedTags = List.from(project.tags);
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectDetailProvider(widget.projectId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('编辑项目'),
        actions: [
          TextButton(
            onPressed: _saveProject,
            child: const Text(
              '保存',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: projectState.when(
        data: (project) {
          _initializeForm(project);
          return _buildForm(project);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('加载失败: $error'),
        ),
      ),
    );
  }

  Widget _buildForm(Project project) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        children: [
          // 项目名称
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '项目名称',
              hintText: '输入心愿项目名称',
              prefixIcon: Icon(Icons.favorite_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入项目名称';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingL),

          // 场景选择
          Text(
            '选择场景',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingS),
          SceneSelector(
            scenes: presetScenes,
            selectedScene: _selectedScene,
            onSceneSelected: (scene) {
              setState(() {
                _selectedScene = scene;
              });
            },
          ),
          const SizedBox(height: AppTheme.spacingL),

          // 标签选择
          Text(
            '添加标签',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingS),
          TagSelector(
            availableTags: presetTags,
            selectedTags: _selectedTags,
            onTagsChanged: (tags) {
              setState(() {
                _selectedTags = tags;
              });
            },
          ),
          const SizedBox(height: AppTheme.spacingL),

          // 项目信息
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '项目信息',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  InfoRow(
                    label: '创建时间',
                    value: project.createdAt.formatted,
                  ),
                  InfoRow(
                    label: '更新时间',
                    value: project.updatedAt.formatted,
                  ),
                  InfoRow(
                    label: '商品数量',
                    value: '${project.productCount} 件',
                  ),
                  InfoRow(
                    label: '状态',
                    value: project.isCompleted ? '已完成' : '进行中',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      ref.read(updateProjectUseCaseProvider).call(
            id: widget.projectId,
            name: _nameController.text,
            scene: _selectedScene,
            tags: _selectedTags,
          );

      // 刷新项目详情
      ref.invalidate(projectDetailProvider(widget.projectId));

      // 刷新项目列表
      ref.read(projectListProvider.notifier).refresh();

      // 返回
      context.pop();
    }
  }
}
