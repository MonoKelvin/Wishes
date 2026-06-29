import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../domain/entities/product.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../project/providers/project_providers.dart';
import '../../providers/home_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  final _linkController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isConverting = false;
  bool _hasCheckedClipboard = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkClipboard();
    }
  }

  bool _isTaobaoLink(String text) {
    final lower = text.toLowerCase();
    return lower.contains('taobao.com') ||
        lower.contains('tmall.com') ||
        lower.contains('tb.cn') ||
        lower.contains('m.tb.cn');
  }

  bool _isTaobaoToken(String text) {
    // 淘口令通常格式：¥xxxx¥ 或 €xxxx€ 或₤xxxx₤
    final trimmed = text.trim();
    return (trimmed.startsWith('¥') && trimmed.endsWith('¥') && trimmed.length > 2) ||
        (trimmed.startsWith('€') && trimmed.endsWith('€') && trimmed.length > 2) ||
        (trimmed.startsWith('₤') && trimmed.endsWith('₤') && trimmed.length > 2);
  }

  Future<void> _checkClipboard() async {
    if (_hasCheckedClipboard) return;
    _hasCheckedClipboard = true;

    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data == null || data.text == null || data.text!.trim().isEmpty) return;

      final text = data.text!.trim();
      if (!_isTaobaoLink(text) && !_isTaobaoToken(text)) return;

      if (!mounted) return;
      _showClipboardDialog(text);
    } catch (_) {
      // 剪切板读取失败，忽略
    }
  }

  void _showClipboardDialog(String text) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('检测到商品链接'),
        content: Text(
          text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resolveAndNavigate(text);
            },
            child: const Text('查看商品'),
          ),
        ],
      ),
    );
  }

  Future<void> _resolveAndNavigate(String text) async {
    try {
      final repo = ref.read(productRepositoryProvider);
      final product = await repo.convertLink(text);
      if (product != null && mounted) {
        context.push('/product/remote', extra: product);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('无法解析该链接'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('解析失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectListState = ref.watch(projectListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('心愿'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 粘贴链接区域
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      hintText: '粘贴商品链接或淘口令...',
                      prefixIcon: const Icon(Icons.link, size: 20),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                FilledButton(
                  onPressed: _isConverting ? null : _convertLink,
                  child: _isConverting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('添加'),
                ),
              ],
            ),
          ),

          // 搜索栏
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '搜索商品关键词...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                FilledButton.tonal(
                  onPressed: _search,
                  child: const Text('搜索'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),

          // 项目列表
          Flexible(
            child: projectListState.when(
              data: (projects) => projects.isEmpty
                  ? EmptyState(
                      icon: Icons.favorite_border,
                      title: '还没有心愿项目',
                      subtitle: '粘贴商品链接或搜索商品添加',
                      action: ElevatedButton.icon(
                        onPressed: () => context.push('/project/create'),
                        icon: const Icon(Icons.add),
                        label: const Text('创建心愿'),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(projectListProvider.notifier).refresh(),
                      child: _ProjectList(projects: projects),
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

  Future<void> _convertLink() async {
    final link = _linkController.text.trim();
    if (link.isEmpty) return;

    setState(() => _isConverting = true);
    try {
      final repo = ref.read(productRepositoryProvider);
      final product = await repo.convertLink(link);
      if (product != null && mounted) {
        // 导航到商品详情页，让用户确认后再添加
        _linkController.clear();
        context.push('/product/remote', extra: product);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('无法解析该链接，请检查链接是否正确'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('添加失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isConverting = false);
    }
  }

  void _search() {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) return;

    _showSearchResults(context, keyword);
  }

  void _showSearchResults(BuildContext context, String keyword) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (ctx, scrollController) =>
            _SearchResultsSheet(keyword: keyword, scrollController: scrollController),
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  final List<dynamic> projects;

  const _ProjectList({required this.projects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primarySubtleColor,
              child: Icon(
                project.isPinned
                    ? Icons.push_pin
                    : project.isCompleted
                        ? Icons.check_circle_outline
                        : Icons.favorite_border,
                color: AppTheme.primaryColor,
              ),
            ),
            title: Text(project.name),
            subtitle: Text(
              '${project.productCount} 件商品 · ¥${project.totalPrice.toStringAsFixed(2)}',
            ),
            trailing: project.isPinned
                ? Icon(Icons.push_pin, size: 16, color: AppTheme.primaryColor)
                : null,
            onTap: () => context.push('/project/${project.id}'),
          ),
        );
      },
    );
  }
}

class _SearchResultsSheet extends ConsumerStatefulWidget {
  final String keyword;
  final ScrollController scrollController;

  const _SearchResultsSheet({
    required this.keyword,
    required this.scrollController,
  });

  @override
  ConsumerState<_SearchResultsSheet> createState() =>
      _SearchResultsSheetState();
}

class _SearchResultsSheetState extends ConsumerState<_SearchResultsSheet> {
  List<Product> _items = [];
  bool _isLoading = true;
  String? _error;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repo = ref.read(productRepositoryProvider);
      final items = await repo.searchRemoteProducts(
        widget.keyword,
        page: _page,
      );
      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '搜索失败，请检查网络或Appkey配置是否正确';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '搜索: ${widget.keyword}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_error!),
                          const SizedBox(height: AppTheme.spacingS),
                          ElevatedButton(
                            onPressed: _loadResults,
                            child: const Text('重试'),
                          ),
                        ],
                      ),
                    )
                  : _items.isEmpty
                      ? const Center(child: Text('未找到相关商品'))
                      : ListView.builder(
                          controller: widget.scrollController,
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          itemCount: _items.length,
                          itemBuilder: (ctx, index) {
                            final product = _items[index];
                            return Card(
                              margin: const EdgeInsets.only(
                                  bottom: AppTheme.spacingS),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.thumbnailUrl,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 56,
                                      height: 56,
                                      color: AppTheme.surfaceColor,
                                      child: const Icon(
                                          Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (product.price > 0)
                                      Text(
                                        '¥${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: AppTheme.errorColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    if (product.shopName != null)
                                      Text(
                                        product.shopName!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.push('/product/remote',
                                        extra: product);
                                  },
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push('/product/remote',
                                      extra: product);
                                },
                              ),
                            );
                          },
                        ),
        ),
        if (!_isLoading && _items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: _page > 1
                      ? () {
                          _page--;
                          _loadResults();
                        }
                      : null,
                  child: const Text('上一页'),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Text('第 $_page 页'),
                const SizedBox(width: AppTheme.spacingM),
                OutlinedButton(
                  onPressed: () {
                    _page++;
                    _loadResults();
                  },
                  child: const Text('下一页'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
