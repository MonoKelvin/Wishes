import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../domain/entities/project.dart';
import '../../../../core/utils/extensions.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXS,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: InkWell(
        onTap: () {
          context.push('/project/${project.id}');
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部行：项目名称和状态
              Row(
                children: [
                  // 项目名称
                  Expanded(
                    child: Text(
                      project.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 置顶图标
                  if (project.isPinned)
                    Icon(
                      Icons.push_pin,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                  // 完成状态
                  if (project.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Text(
                        '已完成',
                        style: TextStyle(
                          color: AppTheme.successColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingS),

              // 场景标签
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLightColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  project.scene,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),

              // 进度条
              if (project.productCount > 0) ...[
                LinearProgressIndicator(
                  value: project.isCompleted ? 1.0 : 0.0, // TODO: 计算实际进度
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    project.isCompleted
                        ? AppTheme.successColor
                        : AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
              ],

              // 底部信息行
              Row(
                children: [
                  // 商品数量
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${project.productCount} 件商品',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  // 总价
                  Text(
                    project.totalPrice.priceString,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
