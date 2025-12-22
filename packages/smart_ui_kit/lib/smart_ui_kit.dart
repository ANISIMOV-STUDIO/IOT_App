/// Smart UI Kit - Glassmorphism Design System for Smart Home Apps
///
/// Modern glass-effect UI components with blur, transparency, and elegant shadows.
/// All components are backwards-compatible with existing Neumorphic* names.
library smart_ui_kit;

// ============================================
// FLUTTER CORE
// ============================================

export 'package:flutter/material.dart';

// ============================================
// THEME & TOKENS
// ============================================

// Glass theme provider and data
export 'src/theme/glass_theme.dart';

// Color palette
export 'src/theme/glass_colors.dart';

// Spacing tokens (kept from neumorphic, still useful)
export 'src/theme/tokens/neumorphic_spacing.dart';

// Typography
export 'src/theme/tokens/neumorphic_typography.dart';

// ============================================
// CORE COMPONENTS
// ============================================

// Card components (GlassCard, GlassInteractiveCard + Neumorphic* aliases)
export 'src/widgets/glass/glass_card.dart';

// Button components (GlassButton, GlassIconButton + Neumorphic* aliases)
export 'src/widgets/glass/glass_button.dart';

// Toggle switch (GlassToggle + NeumorphicToggle alias)
export 'src/widgets/glass/glass_toggle.dart';

// Badge, Progress, Loading (GlassBadge, GlassProgressBar, GlassLoadingIndicator, GlassMainContent)
export 'src/widgets/glass/glass_components.dart';

// ============================================
// CONTROL COMPONENTS
// ============================================

// Slider (GlassSlider + NeumorphicSlider alias)
export 'src/widgets/glass/glass_slider.dart';

// Temperature dial (GlassTemperatureDial + NeumorphicTemperatureDial alias)
export 'src/widgets/glass/glass_temperature_dial.dart';

// Segmented control (GlassSegmentedControl + NeumorphicSegmentedControl alias)
export 'src/widgets/glass/glass_segmented_control.dart';

// Preset grid (GlassPresetGrid + NeumorphicPresetGrid alias)
export 'src/widgets/glass/glass_preset_grid.dart';

// ============================================
// LAYOUT COMPONENTS
// ============================================

// Sidebar navigation (GlassSidebar, GlassNavItem + Neumorphic* aliases)
export 'src/widgets/glass/glass_sidebar.dart';

// Bottom navigation (GlassBottomNav + NeumorphicBottomNav alias)
export 'src/widgets/glass/glass_bottom_nav.dart';

// Responsive dashboard shell
export 'src/widgets/glass/glass_dashboard_shell.dart';

// Bento grid layout
export 'src/widgets/layout/bento_grid.dart';
