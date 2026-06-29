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
  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(allProductsProvider);
    final selectedIds = ref.watch(selectedProductsProvider);

    return Column(
      children: [
        // 搜索框
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: AppSearchBar(
            hintText: '搜索商品...',
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
          child: productsState.when(
            data: (products) => products.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off,
                    title: '暂无商品',
                    subtitle: '请先同步拼多多收藏商品',
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
                        isSelected: selectedIds.contains(product.id),
                        onSelectionChanged: (selected) {
                          ref
                              .read(selectedProductsProvider.notifier)
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
          ),
        ),
      ],
    );
  }
}
