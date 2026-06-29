import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../providers/home_providers.dart';
import '../widgets/project_card.dart';
import '../widgets/project_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectListState = ref.watch(projectListProvider);
    final syncState = ref.watch(syncStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('心愿'),
        actions: [
          // 同步按钮
          IconButton(
            icon: syncState.isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            onPressed: syncState.isSyncing
                ? null
                : () {
                    ref.read(syncStateProvider.notifier).syncProducts();
                  },
          ),
          // 用户头像
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: 显示用户信息
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 同步状态信息
          if (syncState.lastSyncTime != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingXS,
              ),
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: AppTheme.spacingXS),
                  Text(
                    '已同步 ${syncState.syncedCount} 件商品',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

          // 项目列表
          Expanded(
            child: projectListState.when(
              data: (projects) => projects.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 80,
                            color: AppTheme.textHintColor,
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          Text(
                            '还没有心愿项目',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            '点击下方按钮创建你的第一个心愿',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.textHintColor,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ProjectList(projects: projects),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: AppTheme.errorColor,
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      '加载失败',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(projectListProvider.notifier).refresh();
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/project/create');
        },
        icon: const Icon(Icons.add),
        label: const Text('创建心愿'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
