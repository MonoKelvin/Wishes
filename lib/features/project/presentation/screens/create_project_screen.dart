import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../shared/constants/preset_data.dart';
import '../../../../shared/widgets/scene_selector.dart';
import '../../../../shared/widgets/tag_selector.dart';
import '../../providers/project_providers.dart';
import '../../../home/providers/home_providers.dart';
import '../widgets/product_selector.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  ConsumerState<CreateProjectScreen> createState() =>
      _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedScene = presetScenes.first;
  final List<String> _selectedTags = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProductIds = ref.watch(selectedProductsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('创建心愿'),
        actions: [
          TextButton(
            onPressed: _createProject,
            child: Text(
              '创建',
              style: TextStyle(
                color: selectedProductIds.isNotEmpty
                    ? AppTheme.primaryColor
                    : AppTheme.textHintColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // 表单区域
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              color: AppTheme.surfaceColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: AppTheme.spacingM),

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
                  const SizedBox(height: AppTheme.spacingM),

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
                        _selectedTags.clear();
                        _selectedTags.addAll(tags);
                      });
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // 商品选择区域标题
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              child: Row(
                children: [
                  Text(
                    '选择商品',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  if (selectedProductIds.isNotEmpty)
                    Text(
                      '已选 ${selectedProductIds.length} 件',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),

            // 商品选择器
            const Expanded(
              child: ProductSelector(projectId: ''),
            ),
          ],
        ),
      ),
    );
  }

  void _createProject() {
    if (_formKey.currentState!.validate()) {
      final selectedIds = ref.read(selectedProductsProvider);
      if (selectedIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请至少选择一件商品'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      // 创建项目
      ref.read(createProjectUseCaseProvider).call(
            name: _nameController.text,
            scene: _selectedScene,
            tags: _selectedTags,
          );

      // 刷新项目列表
      ref.read(projectListProvider.notifier).refresh();

      // 清除选择
      ref.read(selectedProductsProvider.notifier).clear();

      // 返回首页
      context.pop();
    }
  }
}
