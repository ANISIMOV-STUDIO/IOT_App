/// Skeleton Loading Widgets
///
/// Набор виджетов для отображения skeleton screens во время загрузки.
/// Следует Material Design guidelines и best practices от Big Tech компаний.
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';

/// Базовый skeleton box
///
/// Простой прямоугольник с shimmer эффектом для создания skeleton UI.
/// Может быть использован как строительный блок для более сложных skeleton виджетов.
class SkeletonBox extends StatelessWidget {

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppRadius.card,
    this.shape = BoxShape.rectangle,
  });

  /// Фабричный метод для создания круглого skeleton
  factory SkeletonBox.circle({
    required double size,
  }) => SkeletonBox(
      width: size,
      height: size,
      shape: BoxShape.circle,
    );
  /// Ширина skeleton box
  final double? width;

  /// Высота skeleton box
  final double? height;

  /// Радиус скругления углов
  final double borderRadius;

  /// Форма (прямоугольник или круг)
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer(
      baseColor: isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
      highlightColor: isDark ? AppColors.darkShimmerHighlight : AppColors.lightShimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? colors.card : AppColors.lightCard,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius)
              : null,
        ),
      ),
    );
  }
}

/// Skeleton для карточки устройства
///
/// Имитирует структуру карточки устройства с иконкой, текстом и статусом.
class SkeletonDeviceCard extends StatelessWidget {
  const SkeletonDeviceCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: BreezColors.of(context).card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: BreezColors.of(context).border),
      ),
      child: Row(
        children: [
          // Иконка устройства
          SkeletonBox.circle(size: 48),
          const SizedBox(width: AppSpacing.md),

          // Текстовая информация
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Название устройства
                SkeletonBox(
                  width: double.infinity,
                  height: AppFontSizes.h4,
                  borderRadius: AppRadius.indicator,
                ),
                SizedBox(height: AppSpacing.xs),
                // Дополнительная информация
                SkeletonBox(
                  width: 120,
                  height: AppFontSizes.caption,
                  borderRadius: AppRadius.indicator,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Статус badge
          const SkeletonBox(
            width: 60,
            height: 24,
            borderRadius: AppRadius.chip,
          ),
        ],
      ),
    );
}

/// Skeleton для карточки статистики
///
/// Имитирует структуру stat card с иконкой и числовыми значениями.
class SkeletonStatCard extends StatelessWidget {
  const SkeletonStatCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: BreezColors.of(context).card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: BreezColors.of(context).border),
      ),
      child: const Row(
        children: [
          // Иконка
          SkeletonBox(
            width: 48,
            height: 48,
            borderRadius: AppRadius.button,
          ),
          SizedBox(width: AppSpacing.md),

          // Текст
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                SkeletonBox(
                  width: 80,
                  height: AppFontSizes.caption,
                  borderRadius: AppRadius.indicator,
                ),
                SizedBox(height: AppSpacing.xs),
                // Значение
                SkeletonBox(
                  width: double.infinity,
                  height: AppFontSizes.h3,
                  borderRadius: AppRadius.chip,
                ),
              ],
            ),
          ),
        ],
      ),
    );
}

/// Skeleton для графика
///
/// Имитирует структуру графика с заголовком и областью построения.
class SkeletonGraph extends StatelessWidget {

  const SkeletonGraph({
    super.key,
    this.height = 300,
  });
  /// Высота графика
  final double height;

  @override
  Widget build(BuildContext context) => Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: BreezColors.of(context).card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: BreezColors.of(context).border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок графика
          SkeletonBox(
            width: 150,
            height: AppFontSizes.h4,
            borderRadius: AppRadius.chip,
          ),
          SizedBox(height: AppSpacing.lg),

          // Область графика
          Expanded(
            child: SkeletonBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppRadius.button,
            ),
          ),
        ],
      ),
    );
}

/// Skeleton для списка элементов
///
/// Создает список из нескольких skeleton элементов заданного типа.
class SkeletonList extends StatelessWidget {

  const SkeletonList({
    required this.itemCount, required this.itemBuilder, super.key,
    this.separator,
  });

  /// Фабричный метод для создания списка карточек устройств
  factory SkeletonList.devices({
    int count = 3,
  }) => SkeletonList(
      itemCount: count,
      itemBuilder: (context, index) => const SkeletonDeviceCard(),
      separator: const SizedBox(height: AppSpacing.md),
    );

  /// Фабричный метод для создания сетки карточек статистики
  factory SkeletonList.stats({
    int count = 3,
  }) => SkeletonList(
      itemCount: count,
      itemBuilder: (context, index) => const SkeletonStatCard(),
      separator: const SizedBox(width: AppSpacing.lg),
    );
  /// Количество skeleton элементов
  final int itemCount;

  /// Builder функция для создания каждого skeleton элемента
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Разделитель между элементами
  final Widget? separator;

  @override
  Widget build(BuildContext context) => ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) =>
          separator ?? const SizedBox(height: AppSpacing.md),
      itemBuilder: itemBuilder,
    );
}

/// Skeleton для текстовой строки
///
/// Имитирует одну или несколько строк текста с учетом выравнивания и ширины.
class SkeletonText extends StatelessWidget {

  const SkeletonText({
    super.key,
    this.lines = 1,
    this.lineHeight = 12,
    this.lastLineWidth = 0.7,
    this.spacing = 8,
  });

  /// Фабричный метод для заголовка
  factory SkeletonText.heading() => const SkeletonText(
      lineHeight: 20,
    );

  /// Фабричный метод для параграфа
  factory SkeletonText.paragraph({int lines = 3}) => SkeletonText(
      lines: lines,
      lineHeight: 14,
      lastLineWidth: 0.6,
    );
  /// Количество строк
  final int lines;

  /// Высота каждой строки
  final double lineHeight;

  /// Ширина последней строки (процент от общей ширины)
  final double lastLineWidth;

  /// Расстояние между строками
  final double spacing;

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(
            bottom: isLast ? 0 : spacing,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = isLast && lines > 1
                  ? constraints.maxWidth * lastLineWidth
                  : constraints.maxWidth;

              return SkeletonBox(
                width: width,
                height: lineHeight,
                borderRadius: 6,
              );
            },
          ),
        );
      }),
    );
}

// ═══════════════════════════════════════════════════════════════════════════
// SHIMMER WIDGET - Встроенный shimmer эффект для skeleton
// ═══════════════════════════════════════════════════════════════════════════

/// Shimmer эффект для skeleton виджетов
///
/// Создаёт анимированный градиент, скользящий по child виджету.
/// Используется внутри SkeletonBox для создания loading эффекта.
class Shimmer extends StatefulWidget {

  const Shimmer({
    required this.child, required this.baseColor, required this.highlightColor, super.key,
    this.duration = AppDurations.shimmer,
  });
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + 2 * _controller.value, 0),
              end: Alignment(1.0 + 2 * _controller.value, 0),
            ).createShader(bounds),
          child: child,
        ),
      child: widget.child,
    );
}
