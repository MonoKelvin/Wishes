import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../providers/project_providers.dart';
import 'product_card.dart';

class ProductSelector extends ConsumerStatefulWidget {
  final String projectId;
  final Set<String> initialSelectedIds;

  const ProductSelector({
    super.key,
    required this.projectId,
    this.initialSelectedIds = const {},
  });

  @override
  ConsumerState<ProductSelector> createState() => _ProductSelectorState();
}

class _ProductSelectorState extends ConsumerState<ProductSelector> {
  final _linkController = TextEditingController();
  bool _isConverting = false;
  String _searchMode = 'local'; // 'local' or 'link'

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(allProductsProvider);
    final selectedIds = ref.watch(selectedProductsProvider);

    return Column(
      children: [
        // 搜索模式切换
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingXS,
          ),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('本地商品'),
                selected: _searchMode == 'local',
                onSelected: (v) {
                  if (v) {
                    setState(() => _searchMode = 'local');
                    ref.read(allProductsProvider.notifier).loadProducts();
                  }
                },
              ),
              const SizedBox(width: AppTheme.spacingS),
              ChoiceChip(
                label: const Text('粘贴链接添加'),
                selected: _searchMode == 'link',
                onSelected: (v) {
                  if (v) setState(() => _searchMode = 'link');
                },
              ),
            ],
          ),
        ),

        // 搜索框或链接输入
        if (_searchMode == 'local')
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
            ),
            child: AppSearchBar(
              hintText: '搜索本地商品...',
              onSearch: (keyword) {
                if (keyword.isNotEmpty) {
                  ref.read(allProductsProvider.notifier).search(keyword);
                } else {
                  ref.read(allProductsProvider.notifier).loadProducts();
                }
              },
              onClear: () {
                ref.read(allProductsProvider.notifier).loadProducts();
              },
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
            ),
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
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                FilledButton(
                  onPressed: _isConverting ? null : _convertAndAdd,
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

        // 已选数量
        if (selectedIds.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingXS,
            ),
            color: AppTheme.primarySubtleColor,
            child: Row(
              children: [
                Text(
                  '已选择 ${selectedIds.length} 件商品',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ref.read(selectedProductsProvider.notifier).clear();
                  },
                  child: const Text('清除选择'),
                ),
              ],
            ),
          ),

        // 商品列表
        Expanded(
          child: _searchMode == 'local'
              ? productsState.when(
                  data: (products) => products.isEmpty
                      ? const EmptyState(
                          icon: Icons.search_off,
                          title: '暂无商品',
                          subtitle: '请先通过链接添加商品或浏览推荐商品',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingM,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              isSelected:
                                  selectedIds.contains(product.id),
                              onSelectionChanged: (selected) {
                                ref
                                    .read(
                                        selectedProductsProvider.notifier)
                                    .toggle(product.id);
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
                )
              : const Center(
                  child: Text(
                    '粘贴商品链接后点击"添加"按钮',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _convertAndAdd() async {
    final link = _linkController.text.trim();
    if (link.isEmpty) return;

    setState(() => _isConverting = true);
    try {
      final repo = ref.read(productRepositoryProvider);
      final product = await repo.convertLink(link);
      if (product != null && mounted) {
        await repo.saveProduct(product);
        ref.read(selectedProductsProvider.notifier).toggle(product.id);
        _linkController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已添加: ${product.name}'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        // 切换到本地商品模式显示已添加的商品
        setState(() => _searchMode = 'local');
        ref.read(allProductsProvider.notifier).loadProducts();
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
            content: Text('添加失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isConverting = false);
    }
  }
}
