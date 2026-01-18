/// Add Unit Button - Button to add new HVAC unit
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';

/// Compact add button for unit tabs
class AddUnitButton extends StatelessWidget {

  const AddUnitButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => BreezIconButton(
      icon: Icons.add_rounded,
      onTap: onTap,
      compact: true,
      showBorder: false,
    );
}
