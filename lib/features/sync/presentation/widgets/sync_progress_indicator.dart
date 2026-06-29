import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../providers/sync_providers.dart';

class SyncProgressIndicator extends ConsumerWidget {
  const SyncProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProgressProvider);

    if (!syncState.isSyncing && syncState.errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: AppTheme.lightShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (syncState.isSyncing) ...[
            // 同步中状态
            Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '正在同步商品...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      if (syncState.totalCount > 0)
                        Text(
                          '已同步 ${syncState.syncedCount}/${syncState.totalCount}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (syncState.totalCount > 0) ...[
              const SizedBox(height: AppTheme.spacingS),
              LinearProgressIndicator(
                value: syncState.progress,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ],
          ] else if (syncState.errorMessage != null) ...[
            // 错误状态
            Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppTheme.errorColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Text(
                    syncState.errorMessage!,
                    style: TextStyle(
                      color: AppTheme.errorColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(syncProgressProvider.notifier).startSync();
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
