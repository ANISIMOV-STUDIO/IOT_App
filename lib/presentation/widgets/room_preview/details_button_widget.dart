/// Details Button Widget
///
/// Interactive button for navigating to room details
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Details button for room preview card
class DetailsButtonWidget extends StatelessWidget {
  final String roomName;
  final VoidCallback? onPressed;
  final bool isMobile;

  const DetailsButtonWidget({
    super.key,
    required this.roomName,
    this.onPressed,
    this.isMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    return HvacInteractiveScale(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10.0 : 12.0,
          vertical: isMobile ? 6.0 : 8.0,
        ),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard.withValues(alpha: 0.95),
          borderRadius: HvacRadius.smRadius,
          border: Border.all(
            color: HvacColors.primaryOrange.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Подробнее',
              style: TextStyle(
                color: HvacColors.primaryOrange,
                fontSize: isMobile ? 11.0 : 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4.0),
            HvacIconHero(
              tag: 'arrow_$roomName',
              icon: Icons.arrow_forward,
              color: HvacColors.primaryOrange,
              size: isMobile ? 12.0 : 14.0,
            ),
          ],
        ),
      ),
    );
  }
}
