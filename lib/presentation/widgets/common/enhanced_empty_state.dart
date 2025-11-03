/// Enhanced Empty State Widgets
/// Main export file for empty state components
library;

// Export all empty state components
export 'empty_states/base_empty_state.dart';
export 'empty_states/animated_icons.dart';
export 'empty_states/empty_state_variants.dart';

// For backwards compatibility, re-export the base as EnhancedEmptyState
import 'empty_states/base_empty_state.dart';
typedef EnhancedEmptyState = BaseEmptyState;