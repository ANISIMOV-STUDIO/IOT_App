/// Add Unit Button - Button to add new HVAC unit
library;

import 'package:flutter/material.dart';
import '../../../widgets/breez/breez_card.dart';

/// Compact add button for unit tabs
class AddUnitButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AddUnitButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BreezIconButton(
      icon: Icons.add_rounded,
      onTap: onTap,
      compact: true,
      showBorder: false,
    );
  }
}
