/// Animated Card Widget - Barrel file
///
/// Re-exports animated card from hvac_ui_kit
library;

// Export from UI Kit
export 'package:hvac_ui_kit/src/widgets/cards/hvac_animated_card.dart';

// For backward compatibility, create type aliases
import 'package:hvac_ui_kit/src/widgets/cards/hvac_animated_card.dart'
    as hvac_card;

typedef AnimatedCard = hvac_card.HvacAnimatedCard;
typedef AnimatedDeviceCard = hvac_card.HvacAnimatedDeviceCard;
