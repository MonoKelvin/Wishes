import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../domain/entities/project.dart';
import '../../providers/project_providers.dart';

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
  String _selectedScene = '';
  List<String> _selectedTags = [];
  bool _isInitialized = false;

  // 预置场景列表
  final List<String> _scenes = [
    '装修采购',
    '节日备货',
    '批量采购',
    '日常购物',
    '礼物清单',
    '旅行购物',
    '其他',
  ];

  // 预置标签列表
  final List<String> _availableTags = [
    '紧急',
    '重要',
    '优惠',
    '待比价',
    '已比价',
    '可购买',
  ];

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
            decoration: InputDecoration(
              labelText: '项目名称',
              hintText: '输入心愿项目名称',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              prefixIcon: const Icon(Icons.favorite_outline),
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
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Wrap(
            spacing: AppTheme.spacingXS,
            runSpacing: AppTheme.spacingXS,
            children: _scenes.map((scene) {
              final isSelected = _selectedScene == scene;
              return ChoiceChip(
                label: Text(scene),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedScene = scene;
                    });
                  }
                },
                backgroundColor: AppTheme.surfaceColor,
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textPrimaryColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textHintColor.withOpacity(0.3),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppTheme.spacingL),

          // 标签选择
          Text(
            '添加标签',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Wrap(
            spacing: AppTheme.spacingXS,
            runSpacing: AppTheme.spacingXS,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
                backgroundColor: AppTheme.surfaceColor,
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryColor,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textPrimaryColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textHintColor.withOpacity(0.3),
                  ),
                ),
              );
            }).toList(),
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  _buildInfoRow('创建时间', project.createdAt.toString().substring(0, 19)),
                  _buildInfoRow('更新时间', project.updatedAt.toString().substring(0, 19)),
                  _buildInfoRow('商品数量', '${project.productCount} 件'),
                  _buildInfoRow('状态', project.isCompleted ? '已完成' : '进行中'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
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
      ref.read(projectDetailProvider(widget.projectId).notifier).loadProject();

      // 刷新项目列表
      ref.read(projectListProvider.notifier).refresh();

      // 返回
      context.pop();
    }
  }
}
