/// HVAC UI Kit - Professional Flutter UI Components
///
/// A comprehensive UI kit with glassmorphism design, adaptive layouts,
/// and smooth 60 FPS animations for HVAC and IoT applications.
///
/// ## Features
/// - Glassmorphism & Frosted Glass Effects
/// - Adaptive Layouts (Mobile, Tablet, Desktop)
/// - Smooth Spring Physics Animations
/// - Premium Monochromatic Color Palette
/// - Performance Optimized Components
///
/// ## Usage
/// ```dart
/// import 'package:hvac_ui_kit/hvac_ui_kit.dart';
///
/// MaterialApp(
///   theme: HvacTheme.darkTheme(),
///   home: GlassCard(
///     child: Text('Hello'),
///   ),
/// );
/// ```
library hvac_ui_kit;

// ============================================================================
// THEME SYSTEM
// ============================================================================
export 'src/theme/colors.dart';
export 'src/theme/typography.dart';
export 'src/theme/spacing.dart';
export 'src/theme/radius.dart';
export 'src/theme/shadows.dart';
export 'src/theme/decorations.dart';
export 'src/theme/theme.dart' hide HvacDecorations;
export 'src/theme/glassmorphism.dart';

// ============================================================================
// WIDGETS
// ============================================================================

// Buttons
export 'src/widgets/buttons/buttons.dart';

// Cards (Complete card system)
export 'src/widgets/cards/cards.dart';

// Lists (Material 3 lists)
export 'src/widgets/lists/lists.dart';

// Tables (Data tables)
export 'src/widgets/tables/tables.dart';

// Navigation (Material 3 navigation)
export 'src/widgets/navigation/navigation.dart';

// Inputs (Material 3 inputs)
export 'src/widgets/inputs/inputs.dart';

// Material 3 Components (Segmented, Badge, Rail, Search, Menu, Date)
export 'src/widgets/material3/material3.dart';

// States (Empty, Error, Loading)
export 'src/widgets/states/states.dart';

// Shimmer & Skeleton Components
export 'src/widgets/shimmer/shimmer.dart';

// Glassmorphic Components
export 'src/widgets/glass/glass.dart';

// Tooltip System
export 'src/widgets/overlays/tooltip/tooltip.dart';

// Web Components
export 'src/widgets/web/web.dart' hide HvacResponsiveGrid;

// Icon Components
export 'src/widgets/icons/icons.dart';

// Feedback Components (Dialogs, Snackbar, Bottom sheets)
export 'src/widgets/feedback/feedback.dart';

// Layout Components (Grid, Containers, Spacing, Dividers)
export 'src/widgets/layout/layout.dart';

// Other Widgets
export 'src/widgets/adaptive_slider.dart';
export 'src/widgets/status_indicator.dart';
export 'src/widgets/temperature_badge.dart';
export 'src/widgets/animated_badge.dart';
export 'src/widgets/progress_indicator.dart';
export 'src/widgets/hvac_interactive.dart';
export 'src/widgets/hvac_skeleton_loader.dart' hide HvacSkeletonLoader;
export 'src/widgets/hvac_swipeable_card.dart';
export 'src/widgets/hvac_gradient_border.dart';
export 'src/widgets/hvac_neumorphic.dart';
export 'src/widgets/hvac_refresh.dart';
export 'src/widgets/hvac_liquid_swipe.dart';
export 'src/widgets/hvac_animated_charts.dart';

// ============================================================================
// ANIMATIONS
// ============================================================================
export 'src/animations/smooth_animations.dart';
export 'src/animations/animation_durations.dart';
export 'src/animations/spring_curves.dart';
export 'src/animations/hvac_hero_animations.dart';

// ============================================================================
// UTILS
// ============================================================================
export 'src/utils/adaptive_layout.dart';
export 'src/utils/performance_utils.dart';
export 'src/utils/responsive_utils.dart';
export 'src/utils/responsive_extensions.dart' show ResponsiveConfig, responsive, ResponsiveExtension, ResponsiveInit;

// ============================================================================
// RE-EXPORTS (for convenience)
// ============================================================================
// Note: flutter_screenutil has been removed - using fixed values now
