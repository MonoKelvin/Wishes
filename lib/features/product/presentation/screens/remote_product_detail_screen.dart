import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../domain/entities/product.dart';
import '../../../project/providers/project_providers.dart';
import '../widgets/product_image_carousel.dart';

class RemoteProductDetailScreen extends ConsumerWidget {
  final Product product;

  const RemoteProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('商品详情'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片轮播
            ProductImageCarousel(
              imageUrls: product.imageUrls,
              height: 300,
            ),

            // 商品信息
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 商品名称
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTheme.spacingS),

                  // 店铺信息
                  if (product.shopName != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.store,
                            size: 16, color: AppTheme.textSecondaryColor),
                        const SizedBox(width: 4),
                        Text(
                          product.shopName!,
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                  ],

                  // 价格信息
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (product.price > 0) ...[
                        Text(
                          product.price.priceString,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (product.originalPrice != null &&
                            product.originalPrice! > 0) ...[
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            product.originalPrice!.priceString,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppTheme.textHintColor,
                                ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorSubtleColor,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: Text(
                              '${((1 - product.price / product.originalPrice!) * 100).toStringAsFixed(0)}% OFF',
                              style: const TextStyle(
                                color: AppTheme.errorColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),

                  // 佣金信息
                  if (product.commissionRate != null &&
                      product.commissionRate! > 0) ...[
                    const SizedBox(height: AppTheme.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successSubtleColor,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Text(
                        '佣金 ${product.commissionRate!.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: AppTheme.successColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  // 优惠券信息
                  if (product.couponInfo != null) ...[
                    const SizedBox(height: AppTheme.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x1AFF6B6B),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Text(
                        product.couponInfo!,
                        style: const TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: AppTheme.spacingM),

                  // 淘口令
                  if (product.tkl != null && product.tkl!.isNotEmpty) ...[
                    _buildInfoRow(
                      context,
                      icon: Icons.content_copy,
                      label: '淘口令',
                      value: product.tkl!,
                      onCopy: () {
                        Clipboard.setData(
                            ClipboardData(text: product.tkl!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已复制淘口令')),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                  ],

                  // 销量
                  if (product.salesCount != null &&
                      product.salesCount! > 0) ...[
                    _buildInfoRow(
                      context,
                      icon: Icons.trending_up,
                      label: '月销量',
                      value: '${product.salesCount}',
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                  ],

                  // 商品详情图片
                  if (product.imageUrls.length > 1) ...[
                    const Divider(),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      '商品图片',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    ...product.imageUrls.skip(1).map((url) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppTheme.spacingS),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppTheme.radiusMedium),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 200,
                              color: AppTheme.primarySubtleColor,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 200,
                              color: AppTheme.primarySubtleColor,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: AppTheme.textHintColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          boxShadow: AppTheme.lightShadow,
        ),
        child: SafeArea(
          child: Row(
            children: [
              // 复制链接按钮
              if (product.affiliateUrl != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: product.affiliateUrl!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已复制推广链接')),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('复制链接'),
                  ),
                ),
              if (product.affiliateUrl != null)
                const SizedBox(width: AppTheme.spacingS),
              // 添加到心愿单
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _addToWishlist(context, ref),
                  icon: const Icon(Icons.favorite_border, size: 18),
                  label: const Text('添加到心愿单'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addToWishlist(BuildContext context, WidgetRef ref) async {
    try {
      final repo = ref.read(productRepositoryProvider);
      await repo.saveProduct(product);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已添加: ${product.name}'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('添加失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onCopy,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondaryColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onCopy != null)
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: onCopy,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }
}
