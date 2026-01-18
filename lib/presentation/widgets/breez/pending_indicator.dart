/// Pending Indicator - Visual feedback for pending operations
///
/// Добавляет пульсирующую анимацию когда операция ожидает подтверждения.
/// Использует BREEZ design tokens для согласованности с дизайн-системой.
library;

import 'package:flutter/material.dart';

/// Стандартная длительность shimmer анимации
const Duration _kShimmerDuration = Duration(milliseconds: 1500);

/// Индикатор ожидания подтверждения от устройства
///
/// Оборачивает виджет и добавляет пульсирующую прозрачность
/// когда [isPending] == true
class PendingIndicator extends StatefulWidget {

  const PendingIndicator({
    required this.child, super.key,
    this.isPending = false,
    this.minOpacity = 0.5,
    this.maxOpacity = 1.0,
  });
  /// Дочерний виджет
  final Widget child;

  /// Включена ли анимация ожидания
  final bool isPending;

  /// Минимальная прозрачность при пульсации (0.0 - 1.0)
  final double minOpacity;

  /// Максимальная прозрачность (обычно 1.0)
  final double maxOpacity;

  @override
  State<PendingIndicator> createState() => _PendingIndicatorState();
}

class _PendingIndicatorState extends State<PendingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _kShimmerDuration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: widget.maxOpacity,
      end: widget.minOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isPending) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PendingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPending != oldWidget.isPending) {
      if (widget.isPending) {
        _controller.repeat(reverse: true);
      } else {
        _controller..stop()
        ..value = 0.0; // Reset to full opacity
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPending) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) => Opacity(
          opacity: _opacityAnimation.value,
          child: child,
        ),
      child: widget.child,
    );
  }
}
