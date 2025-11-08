/// Tooltip Types and Enums
///
/// Common types used by tooltip components
library;

/// Position options for tooltip
enum TooltipPosition {
  top,
  bottom,
  left,
  right,
  topStart,
  topEnd,
  bottomStart,
  bottomEnd,
}

/// Tooltip trigger type
enum TooltipTrigger {
  hover,
  tap,
  longPress,
  manual,
}

/// Tooltip animation type
enum TooltipAnimation {
  fade,
  scale,
  slideUp,
  slideDown,
}
