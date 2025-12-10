/// Smart UI Kit - Neumorphic Design System for Smart Home Apps
library smart_ui_kit;

// ============================================
// THEME SYSTEM
// ============================================

// Neumorphic Theme (primary)
export 'src/theme/neumorphic_theme.dart';

// Design Tokens
export 'src/theme/tokens/neumorphic_colors.dart';
export 'src/theme/tokens/neumorphic_shadows.dart';
export 'src/theme/tokens/neumorphic_spacing.dart';
export 'src/theme/tokens/neumorphic_typography.dart';

// Legacy theme (for backwards compatibility)
export 'src/theme/app_theme.dart';
export 'src/theme/tokens/app_colors.dart';
export 'src/theme/tokens/app_spacing.dart';
export 'src/theme/tokens/app_typography.dart';

// ============================================
// NEUMORPHIC WIDGETS
// ============================================

export 'src/widgets/neumorphic/neumorphic_widgets.dart';

// ============================================
// LEGACY WIDGETS (Smart/Zilon)
// ============================================

// Smart widgets
export 'src/widgets/smart/smart_button.dart';
export 'src/widgets/smart/smart_card.dart';

// Zilon widgets
export 'src/widgets/zilon/zilon_control_card.dart';
export 'src/widgets/zilon/zilon_presets_card.dart';
export 'src/widgets/zilon/zilon_quick_actions.dart';
export 'src/widgets/zilon/zilon_schedule_preview.dart';
export 'src/widgets/zilon/zilon_sensor_grid.dart';
export 'src/widgets/zilon/zilon_sidebar.dart';
export 'src/widgets/zilon/zilon_status_card.dart';
