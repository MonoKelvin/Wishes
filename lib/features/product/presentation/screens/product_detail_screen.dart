import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../providers/product_providers.dart';
import '../widgets/product_image_carousel.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productDetailProvider(productId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('商品详情'),
      ),
      body: productState.when(
        data: (product) => SingleChildScrollView(
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

                    // 价格信息
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
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
                    ),
                    const SizedBox(height: AppTheme.spacingM),

                    // 商品详情图片
                    if (product.imageUrls.length > 1) ...[
                      Text(
                        '商品详情',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      ...product.imageUrls.skip(1).map((url) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppTheme.spacingS),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
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
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => ErrorState(
          message: '加载失败',
          onRetry: () => ref.invalidate(productDetailProvider(productId)),
        ),
      ),
      bottomNavigationBar: productState.when(
        data: (product) => Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            boxShadow: AppTheme.lightShadow,
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: () => _openPddApp(context, product.id),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.open_in_new),
                  SizedBox(width: 8),
                  Text(
                    '去拼多多查看',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _openPddApp(BuildContext context, String goodsId) async {
    final pddUrl = 'pdd://goods_detail?goods_id=$goodsId';
    final webUrl = 'https://mobile.yangkeduo.com/goods.html?goods_id=$goodsId';

    try {
      final pddUri = Uri.parse(pddUrl);
      if (await canLaunchUrl(pddUri)) {
        await launchUrl(pddUri);
      } else {
        final webUri = Uri.parse(webUrl);
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('无法打开拼多多，请检查是否已安装'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
