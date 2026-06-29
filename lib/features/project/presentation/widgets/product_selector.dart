import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(allProductsProvider);
    final selectedIds = ref.watch(selectedProductsProvider);

    return Column(
      children: [
        // 搜索框
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '搜索商品...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                        ref.read(allProductsProvider.notifier).loadProducts();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppTheme.surfaceColor,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              if (value.isNotEmpty) {
                ref.read(allProductsProvider.notifier).search(value);
              } else {
                ref.read(allProductsProvider.notifier).loadProducts();
              }
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
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Text(
                  '已选择 ${selectedIds.length} 件商品',
                  style: TextStyle(
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
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: AppTheme.textHintColor,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Text(
                          _searchQuery.isEmpty ? '暂无商品' : '未找到相关商品',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                        ),
                      ],
                    ),
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
