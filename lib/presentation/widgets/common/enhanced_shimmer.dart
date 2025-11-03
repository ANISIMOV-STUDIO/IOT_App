/// Enhanced Shimmer Loading Components
/// Main export file for shimmer and skeleton components
library;

// Export all shimmer components
export 'shimmer/base_shimmer.dart';
export 'shimmer/skeleton_primitives.dart';
export 'shimmer/skeleton_cards.dart';
export 'shimmer/skeleton_lists.dart';
export 'shimmer/skeleton_screens.dart';
export 'shimmer/pulse_skeleton.dart';

// For backwards compatibility, re-export main components with original names
import 'shimmer/base_shimmer.dart';
typedef EnhancedShimmer = BaseShimmer;