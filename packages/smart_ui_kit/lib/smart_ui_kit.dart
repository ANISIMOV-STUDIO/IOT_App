/// Smart UI Kit - Neumorphic Design System for Smart Home Apps
/// 
/// Uses flutter_neumorphic_plus for base components
/// with custom IoT-specific widgets and theme extensions
library smart_ui_kit;

// ============================================
// FLUTTER_NEUMORPHIC_PLUS (base components)
// ============================================

// Re-export flutter_neumorphic_plus but hide conflicting names
export 'package:flutter_neumorphic_plus/flutter_neumorphic.dart'
    hide 
      NeumorphicTheme,      // We use our own wrapper
      NeumorphicThemeData,  // We use our own
      NeumorphicColors,     // We have our own colors
      NeumorphicSlider,     // We have custom slider
      NeumorphicToggle,     // We have compat wrapper
      NeumorphicButton;     // We have compat wrapper

// ============================================
// CUSTOM THEME & TOKENS
// ============================================

// Our theme wrapper (includes NeumorphicTheme, NeumorphicThemeData)
export 'src/widgets/neumorphic/neumorphic_theme_wrapper.dart';

// Backwards-compatible wrappers (NeumorphicCard, NeumorphicButton, NeumorphicToggle)
export 'src/widgets/neumorphic/neumorphic_compat.dart';

// Design tokens
export 'src/theme/tokens/neumorphic_colors.dart';
export 'src/theme/tokens/neumorphic_shadows.dart';
export 'src/theme/tokens/neumorphic_spacing.dart';
export 'src/theme/tokens/neumorphic_typography.dart';

// ============================================
// CUSTOM IOT WIDGETS
// ============================================

// Temperature control (Syncfusion)
export 'src/widgets/neumorphic/neumorphic_temperature_dial.dart';

// Custom slider with local state
export 'src/widgets/neumorphic/neumorphic_slider.dart';

// Layout components
export 'src/widgets/neumorphic/neumorphic_sidebar.dart';
export 'src/widgets/neumorphic/neumorphic_dashboard_shell.dart';

// IoT-specific components
export 'src/widgets/neumorphic/neumorphic_device_card.dart';
export 'src/widgets/neumorphic/neumorphic_air_quality.dart';

// ============================================
// LEGACY (for backwards compatibility)
// ============================================

export 'src/theme/app_theme.dart';
export 'src/theme/tokens/app_colors.dart';
export 'src/theme/tokens/app_spacing.dart';
export 'src/theme/tokens/app_typography.dart';
