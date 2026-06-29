import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../app/theme.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;

  const ProductImageCarousel({
    super.key,
    required this.imageUrls,
    this.height = 300,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return Container(
        height: widget.height,
        color: AppTheme.primarySubtleColor,
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 60,
            color: AppTheme.textHintColor,
          ),
        ),
      );
    }

    return Stack(
      children: [
        // 图片轮播
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.imageUrls[index],
                width: double.infinity,
                height: widget.height,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppTheme.primarySubtleColor,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppTheme.primarySubtleColor,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppTheme.textHintColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // 指示器
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrls.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? AppTheme.primaryColor
                        : AppTheme.primaryMutedColor,
                  ),
                ),
              ),
            ),
          ),

        // 图片计数
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.overlayDarkColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.imageUrls.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// 需要在theme.dart中添加 overlayDarkColor
