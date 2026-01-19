/// Fan Slider Widget - compact slider for fan speed control
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_slider.dart';

/// Compact fan slider with label, icon, and percentage display
/// Uses BreezLabeledSlider for consistent styling and accessibility
class FanSlider extends StatefulWidget {

  const FanSlider({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    super.key,
    this.onChanged,
    this.isPending = false,
  });
  final String label;
  final int? value;
  final Color color;
  final IconData icon;
  final ValueChanged<int>? onChanged;

  /// Ожидание подтверждения от сервера - блокирует слайдер
  final bool isPending;

  @override
  State<FanSlider> createState() => _FanSliderState();
}

class _FanSliderState extends State<FanSlider> {
  int? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(FanSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local value if external value changes (and we assume we aren't dragging,
    // though strictly speaking we can't detect drag state here easily without more complex logic.
    // However, since the external update usually comes from the API response which happens
    // after we release, this simple sync is usually sufficient and correct).
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Если значение null — показываем отключённый слайдер с прочерком
    final hasValue = _currentValue != null;
    // Блокируем слайдер если нет значения или ожидаем ответа от сервера
    final isEnabled = hasValue && widget.onChanged != null && !widget.isPending;

    return BreezLabeledSlider(
      label: widget.label,
      value: _currentValue?.toDouble() ?? 0,
      min: 20, // Минимальная скорость вентилятора 20%
      color: widget.color,
      icon: widget.icon,
      enabled: isEnabled,
      semanticLabel: hasValue
          ? '${widget.label}: $_currentValue%'
          : '${widget.label}: нет данных',
      suffix: hasValue ? '%' : '',
      valueOverride: hasValue ? null : '—',
      // Обновляем локальное состояние при перетаскивании для визуала
      onChanged: isEnabled
          ? (v) => setState(() => _currentValue = v.round())
          : null,
      // Отправляем запрос только когда пользователь отпустил слайдер
      onChangeEnd: isEnabled
          ? (v) => widget.onChanged!(v.round())
          : null,
    );
  }
}
