/// HVAC UI Kit - Swipeable Card
///
/// Card with swipe actions (Tinder-style for quick actions)
library;

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/radius.dart';

/// Swipeable card with left and right actions
class HvacSwipeableCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final String? leftActionLabel;
  final String? rightActionLabel;
  final IconData? leftActionIcon;
  final IconData? rightActionIcon;
  final Color? leftActionColor;
  final Color? rightActionColor;

  const HvacSwipeableCard({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.leftActionLabel = 'Delete',
    this.rightActionLabel = 'Edit',
    this.leftActionIcon = Icons.delete,
    this.rightActionIcon = Icons.edit,
    this.leftActionColor,
    this.rightActionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      startActionPane: onSwipeRight != null
          ? ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => onSwipeRight?.call(),
                  backgroundColor: rightActionColor ?? HvacColors.success,
                  foregroundColor: Colors.white,
                  icon: rightActionIcon,
                  label: rightActionLabel,
                  borderRadius: HvacRadius.mdRadius,
                ),
              ],
            )
          : null,
      endActionPane: onSwipeLeft != null
          ? ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => onSwipeLeft?.call(),
                  backgroundColor: leftActionColor ?? HvacColors.error,
                  foregroundColor: Colors.white,
                  icon: leftActionIcon,
                  label: leftActionLabel,
                  borderRadius: HvacRadius.mdRadius,
                ),
              ],
            )
          : null,
      child: child,
    );
  }
}

/// Dismissible card for permanent deletion
class HvacDismissibleCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDismissed;
  final String? confirmMessage;

  const HvacDismissibleCard({
    super.key,
    required this.child,
    this.onDismissed,
    this.confirmMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key ?? UniqueKey(),
      background: Container(
        color: HvacColors.error,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: HvacSpacing.lg),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      secondaryBackground: Container(
        color: HvacColors.success,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: HvacSpacing.lg),
        child: const Icon(Icons.check, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        if (confirmMessage != null) {
          return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm'),
              content: Text(confirmMessage!),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          );
        }
        return true;
      },
      onDismissed: (_) => onDismissed?.call(),
      child: child,
    );
  }
}

/// HVAC Device quick action card
class HvacDeviceSwipeCard extends StatelessWidget {
  final String deviceName;
  final String status;
  final VoidCallback onTurnOn;
  final VoidCallback onTurnOff;
  final VoidCallback? onSettings;

  const HvacDeviceSwipeCard({
    super.key,
    required this.deviceName,
    required this.status,
    required this.onTurnOn,
    required this.onTurnOff,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return HvacSwipeableCard(
      onSwipeLeft: onTurnOff,
      onSwipeRight: onTurnOn,
      leftActionLabel: 'Turn Off',
      rightActionLabel: 'Turn On',
      leftActionIcon: Icons.power_off,
      rightActionIcon: Icons.power,
      leftActionColor: HvacColors.error,
      rightActionColor: HvacColors.success,
      child: Container(
        padding: EdgeInsets.all(HvacSpacing.md),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: HvacRadius.mdRadius,
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.device_thermostat, size: 40, color: HvacColors.primaryOrange),
            SizedBox(width: HvacSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deviceName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: HvacSpacing.xxs),
                  Text(status, style: TextStyle(fontSize: 14, color: HvacColors.textSecondary)),
                ],
              ),
            ),
            if (onSettings != null)
              IconButton(
                onPressed: onSettings,
                icon: Icon(Icons.settings),
              ),
          ],
        ),
      ),
    );
  }
}
