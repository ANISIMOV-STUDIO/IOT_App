import 'package:flutter/material.dart';

enum SmartButtonType { primary, secondary, outline }

class SmartButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final SmartButtonType type;
  final Widget? icon;
  final bool isLoading;

  const SmartButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = SmartButtonType.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );

    return switch (type) {
      SmartButtonType.primary => FilledButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      SmartButtonType.secondary => FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      SmartButtonType.outline => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
    };
  }
}
