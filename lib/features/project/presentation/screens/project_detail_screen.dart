import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../providers/project_providers.dart';
import '../widgets/product_card.dart';
import '../widgets/category_tile.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final String projectId;

  const ProjectDetailScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectDetailProvider(projectId));
    final productsState = ref.watch(projectProductsProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: projectState.when(
          data: (project) => Text(project.name),
          loading: () => const Text('加载中...'),
          error: (_, __) => const Text('项目详情'),
        ),
        actions: [
          // 更多菜单
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              final actions = ref.read(projectDetailActionsProvider(projectId));
              switch (value) {
                case 'pin':
                  actions.togglePin();
                  break;
                case 'complete':
                  actions.markComplete();
                  break;
                case 'delete':
                  _showDeleteDialog(context, ref);
                  break;
              }
            },
            itemBuilder: (context) => [
              projectState.when(
                data: (project) => PopupMenuItem(
                  value: 'pin',
                  child: Row(
                    children: [
                      Icon(
                        project.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(project.isPinned ? '取消置顶' : '置顶'),
                    ],
                  ),
                ),
                loading: () => const PopupMenuItem(value: '', child: SizedBox()),
                error: (_, __) => const PopupMenuItem(value: '', child: SizedBox()),
              ),
              projectState.when(
                data: (project) => project.isCompleted
                    ? const PopupMenuItem(value: '', child: SizedBox())
                    : PopupMenuItem(
                        value: 'complete',
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20),
                            const SizedBox(width: 8),
                            const Text('标记完成'),
                          ],
                        ),
                      ),
                loading: () => const PopupMenuItem(value: '', child: SizedBox()),
                error: (_, __) => const PopupMenuItem(value: '', child: SizedBox()),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: AppTheme.errorColor),
                    SizedBox(width: 8),
                    Text('删除', style: TextStyle(color: AppTheme.errorColor)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: projectState.when(
        data: (project) => Column(
          children: [
            // 统计区域
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              color: AppTheme.surfaceColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    '商品数量',
                    '${project.productCount}',
                    Icons.shopping_bag_outlined,
                  ),
                  _buildStatItem(
                    context,
                    '总价',
                    project.totalPrice.priceString,
                    Icons.attach_money,
                  ),
                  _buildStatItem(
                    context,
                    '状态',
                    project.isCompleted ? '已完成' : '进行中',
                    project.isCompleted
                        ? Icons.check_circle
                        : Icons.access_time,
                    color: project.isCompleted
                        ? AppTheme.successColor
                        : AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // 分类列表
            if (project.categories.isNotEmpty)
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  itemCount: project.categories.length,
                  itemBuilder: (context, index) {
                    return CategoryTile(category: project.categories[index]);
                  },
                ),
              ),

            // 商品列表
            Expanded(
              child: productsState.when(
                data: (products) => products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 60,
                              color: AppTheme.textHintColor,
                            ),
                            const SizedBox(height: AppTheme.spacingM),
                            Text(
                              '还没有商品',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: 打开商品选择器
                              },
                              child: const Text('添加商品'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: products[index],
                            onTogglePurchase: () {
                              // TODO: 实现已购/未购切换
                              ref.invalidate(projectProductsProvider(projectId));
                            },
                          );
                        },
                      ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('加载失败: $error'),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('加载失败: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 打开商品选择器
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: color ?? AppTheme.primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: color ?? AppTheme.textPrimaryColor,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除项目'),
        content: const Text('确定要删除这个项目吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final actions = ref.read(projectDetailActionsProvider(projectId));
              actions.delete();
              Navigator.pop(context);
              context.pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
