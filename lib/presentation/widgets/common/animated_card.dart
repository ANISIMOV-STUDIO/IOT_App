/// Animated Card Widget - Barrel file
///
/// Re-exports animated card from hvac_ui_kit
library;

// Export from UI Kit
export 'package:hvac_ui_kit/src/widgets/cards/hvac_animated_card.dart';

// For backward compatibility, re-export with old names
export 'package:hvac_ui_kit/src/widgets/cards/hvac_animated_card.dart' show
    HvacAnimatedCard as AnimatedCard,
    HvacAnimatedDeviceCard as AnimatedDeviceCard;
