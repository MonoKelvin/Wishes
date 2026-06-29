import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../app/theme.dart';
import '../../../../domain/entities/product.dart';
import '../../../../core/utils/extensions.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTogglePurchase;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectionChanged;

  const ProductCard({
    super.key,
    required this.product,
    this.onTogglePurchase,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: InkWell(
        onTap: () => context.push('/product/${product.id}'),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingS),
          child: Row(
            children: [
              // 选择框（如果需要）
              if (onSelectionChanged != null)
                Checkbox(
                  value: isSelected,
                  onChanged: onSelectionChanged,
                  activeColor: AppTheme.primaryColor,
                ),

              // 商品图片
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                child: CachedNetworkImage(
                  imageUrl: product.thumbnailUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: AppTheme.primarySubtleColor,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: AppTheme.primarySubtleColor,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: AppTheme.textHintColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),

              // 商品信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 商品名称
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // 价格
                    Row(
                      children: [
                        Text(
                          product.price.priceString,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                        ),
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            product.originalPrice!.priceString,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // 项目标签
                    if (product.projectIds.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        children: product.projectIds.take(2).map((id) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primarySubtleColor,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: const Text(
                              '已选',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),

              // 购买状态切换
              if (onTogglePurchase != null)
                IconButton(
                  icon: Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? AppTheme.successColor
                        : AppTheme.textHintColor,
                  ),
                  onPressed: onTogglePurchase,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
