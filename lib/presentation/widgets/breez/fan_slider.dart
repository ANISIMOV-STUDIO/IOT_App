/// Fan Slider Widget - compact slider for fan speed control
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// ScrollBehavior для слайдера - разрешает touch для drag (не scroll)
class _SliderScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    // НЕ включаем touch - чтобы слайдер мог его использовать
  };
}

/// Compact fan slider with label, icon, and percentage display
/// Uses local state for immediate visual feedback during drag
class FanSlider extends StatefulWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  final ValueChanged<int>? onChanged;

  const FanSlider({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.onChanged,
  });

  @override
  State<FanSlider> createState() => _FanSliderState();
}

class _FanSliderState extends State<FanSlider> {
  late double _localValue;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value.toDouble();
  }

  @override
  void didUpdateWidget(FanSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Синхронизируем с внешним значением, только если не идёт перетаскивание
    if (!_isDragging && widget.value != oldWidget.value) {
      _localValue = widget.value.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayValue = _localValue.round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(widget.icon, size: 12, color: widget.color),
                const SizedBox(width: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            Text(
              '$displayValue%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: widget.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // ScrollConfiguration предотвращает перехват touch родительским scroll
        ScrollConfiguration(
          behavior: _SliderScrollBehavior(),
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: widget.color,
              inactiveTrackColor: isDark
                  ? AppColors.darkHoverOverlay
                  : AppColors.lightHoverOverlay,
              thumbColor: widget.color,
              overlayColor: widget.color.withValues(alpha: 0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: _localValue,
              min: 0,
              max: 100,
              onChangeStart: widget.onChanged != null
                  ? (_) => setState(() => _isDragging = true)
                  : null,
              onChanged: widget.onChanged != null
                  ? (v) {
                      setState(() => _localValue = v);
                      // Вызываем callback на каждое изменение,
                      // restartable() в BLoC отменит предыдущие запросы
                      widget.onChanged!(v.round());
                    }
                  : null,
              onChangeEnd: widget.onChanged != null
                  ? (v) {
                      setState(() => _isDragging = false);
                      // Финальный вызов для гарантии отправки последнего значения
                      widget.onChanged!(v.round());
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
