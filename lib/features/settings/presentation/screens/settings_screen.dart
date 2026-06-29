import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../providers/settings_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _appkeyController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _appkeyController = TextEditingController(text: settings.appkey);
  }

  @override
  void dispose() {
    _appkeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '折淘客配置',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    '配置折淘客API参数，用于通过链接获取商品信息',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  TextField(
                    controller: _appkeyController,
                    decoration: const InputDecoration(
                      labelText: 'Appkey',
                      hintText: '请输入折淘客对接秘钥',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) =>
                        ref.read(settingsProvider.notifier).updateAppkey(v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          FilledButton.icon(
            onPressed: settings.isSaving
                ? null
                : () async {
                    final success =
                        await ref.read(settingsProvider.notifier).save();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success ? '保存成功' : '保存失败'),
                          backgroundColor: success
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                      );
                    }
                  },
            icon: settings.isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('保存配置'),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Card(
            color: AppTheme.primarySubtleColor,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.help_outline,
                          size: 18, color: AppTheme.primaryColor),
                      SizedBox(width: AppTheme.spacingXS),
                      Text(
                        '使用说明',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    '• Appkey: 在折淘客后台"对接秘钥"页面获取\n'
                    '• 粘贴淘宝商品链接或淘口令即可添加商品\n'
                    '• 支持从淘宝APP分享的链接和口令',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
