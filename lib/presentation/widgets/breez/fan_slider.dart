/// Fan Slider Widget - compact slider for fan speed control
library;

import 'package:flutter/material.dart';
import 'breez_slider.dart';

/// Compact fan slider with label, icon, and percentage display
/// Uses BreezLabeledSlider for consistent styling and accessibility
class FanSlider extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BreezLabeledSlider(
      label: label,
      value: value.toDouble(),
      color: color,
      icon: icon,
      enabled: onChanged != null,
      semanticLabel: '$label: $value%',
      suffix: '%',
      // Не вызываем callback во время перетаскивания - только UI обновление
      onChanged: null,
      // Отправляем изменения только когда пользователь отпустил слайдер
      onChangeEnd: onChanged != null
          ? (v) => onChanged!(v.round())
          : null,
    );
  }

}
