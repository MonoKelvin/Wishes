import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../providers/home_providers.dart';
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
            icon: const Icon(Icons.person_outline),
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
              color: AppTheme.primarySubtleColor,
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: AppTheme.spacingXS),
                  Text(
                    '已同步 ${syncState.syncedCount} 件商品',
                    style: const TextStyle(
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
                  ? EmptyState(
                      icon: Icons.favorite_border,
                      title: '还没有心愿项目',
                      subtitle: '点击下方按钮创建你的第一个心愿',
                      action: ElevatedButton.icon(
                        onPressed: () => context.push('/project/create'),
                        icon: const Icon(Icons.add),
                        label: const Text('创建心愿'),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(projectListProvider.notifier).refresh(),
                      child: ProjectList(projects: projects),
                    ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => ErrorState(
                message: '加载失败',
                onRetry: () =>
                    ref.read(projectListProvider.notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/project/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
