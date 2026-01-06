/// BREEZ Skeleton - Компоненты-заглушки с эффектом shimmer для загрузки
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';

/// Базовый wrapper с эффектом shimmer
///
/// Обеспечивает анимированный градиент для состояний загрузки
class BreezShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool enabled;

  const BreezShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  @override
  State<BreezShimmer> createState() => _BreezShimmerState();
}

class _BreezShimmerState extends State<BreezShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(BreezShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final colors = BreezColors.of(context);
    final baseColor = colors.card;
    final highlightColor = colors.cardLight;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Трансформация градиента для скользящего shimmer эффекта
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

/// Базовый skeleton-бокс со скруглёнными углами
class BreezSkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final bool shimmer;

  const BreezSkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppRadius.button,
    this.shimmer = true,
  });

  /// Создать квадратный skeleton
  const BreezSkeletonBox.square({
    super.key,
    required double size,
    this.borderRadius = AppRadius.button,
    this.shimmer = true,
  })  : width = size,
        height = size;

  /// Создать круглый skeleton
  factory BreezSkeletonBox.circle({
    Key? key,
    required double size,
    bool shimmer = true,
  }) {
    return BreezSkeletonBox(
      key: key,
      width: size,
      height: size,
      borderRadius: size / 2,
      shimmer: shimmer,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    if (shimmer) {
      return BreezShimmer(child: box);
    }
    return box;
  }
}

/// Skeleton строки текста
class BreezSkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final bool shimmer;

  const BreezSkeletonText({
    super.key,
    this.width,
    this.height = 14,
    this.shimmer = true,
  });

  /// Короткая строка текста (60% ширины)
  const BreezSkeletonText.short({
    super.key,
    this.height = 14,
    this.shimmer = true,
  }) : width = null;

  @override
  Widget build(BuildContext context) {
    return BreezSkeletonBox(
      width: width,
      height: height,
      borderRadius: height / 2,
      shimmer: shimmer,
    );
  }
}

/// Skeleton параграфа с несколькими строками
class BreezSkeletonParagraph extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double spacing;
  final bool shimmer;

  const BreezSkeletonParagraph({
    super.key,
    this.lines = 3,
    this.lineHeight = 14,
    this.spacing = 8,
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        // Последняя строка короче
        final isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? spacing : 0),
          child: FractionallySizedBox(
            widthFactor: isLast ? 0.6 : 1.0,
            child: BreezSkeletonText(
              height: lineHeight,
              shimmer: shimmer,
            ),
          ),
        );
      }),
    );
  }
}

/// Skeleton карточки с настраиваемым layout
class BreezSkeletonCard extends StatelessWidget {
  final double? height;
  final bool showAvatar;
  final bool showTitle;
  final bool showSubtitle;
  final bool showContent;
  final int contentLines;
  final bool shimmer;

  const BreezSkeletonCard({
    super.key,
    this.height,
    this.showAvatar = false,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showContent = false,
    this.contentLines = 3,
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showAvatar || showTitle || showSubtitle)
            Row(
              children: [
                if (showAvatar) ...[
                  BreezSkeletonBox.circle(size: 40, shimmer: shimmer),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showTitle)
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          child: BreezSkeletonText(
                            height: 16,
                            shimmer: shimmer,
                          ),
                        ),
                      if (showTitle && showSubtitle) const SizedBox(height: 8),
                      if (showSubtitle)
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: BreezSkeletonText(
                            height: 12,
                            shimmer: shimmer,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          if (showContent) ...[
            const SizedBox(height: 16),
            BreezSkeletonParagraph(
              lines: contentLines,
              shimmer: shimmer,
            ),
          ],
        ],
      ),
    );
  }
}

/// Skeleton элемента списка
class BreezSkeletonListItem extends StatelessWidget {
  final bool showLeading;
  final bool showTrailing;
  final double? leadingSize;
  final bool shimmer;

  const BreezSkeletonListItem({
    super.key,
    this.showLeading = true,
    this.showTrailing = false,
    this.leadingSize,
    this.shimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (showLeading) ...[
            BreezSkeletonBox.circle(
              size: leadingSize ?? 40,
              shimmer: shimmer,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: BreezSkeletonText(height: 14, shimmer: shimmer),
                ),
                const SizedBox(height: 6),
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: BreezSkeletonText(height: 12, shimmer: shimmer),
                ),
              ],
            ),
          ),
          if (showTrailing) ...[
            const SizedBox(width: 12),
            BreezSkeletonBox(
              width: 60,
              height: 24,
              shimmer: shimmer,
            ),
          ],
        ],
      ),
    );
  }
}

/// Builder для генерации skeleton списка
class BreezSkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final EdgeInsets? padding;

  const BreezSkeletonList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
  });

  /// Создать список skeleton элементов
  factory BreezSkeletonList.items({
    Key? key,
    int count = 5,
    bool showLeading = true,
    bool showTrailing = false,
    EdgeInsets? padding,
  }) {
    return BreezSkeletonList(
      key: key,
      itemCount: count,
      padding: padding,
      itemBuilder: (_, __) => BreezSkeletonListItem(
        showLeading: showLeading,
        showTrailing: showTrailing,
      ),
    );
  }

  /// Создать список skeleton карточек
  factory BreezSkeletonList.cards({
    Key? key,
    int count = 3,
    double? cardHeight,
    EdgeInsets? padding,
  }) {
    return BreezSkeletonList(
      key: key,
      itemCount: count,
      padding: padding,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: BreezSkeletonCard(height: cardHeight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => itemBuilder(context, index),
        ),
      ),
    );
  }
}

/// Сетка skeleton элементов
class BreezSkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final Widget Function(BuildContext, int) itemBuilder;

  const BreezSkeletonGrid({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.childAspectRatio = 1.0,
    required this.itemBuilder,
  });

  /// Создать сетку skeleton боксов
  factory BreezSkeletonGrid.boxes({
    Key? key,
    int count = 6,
    int crossAxisCount = 2,
    double aspectRatio = 1.0,
  }) {
    return BreezSkeletonGrid(
      key: key,
      itemCount: count,
      crossAxisCount: crossAxisCount,
      childAspectRatio: aspectRatio,
      itemBuilder: (_, __) => const BreezSkeletonBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
