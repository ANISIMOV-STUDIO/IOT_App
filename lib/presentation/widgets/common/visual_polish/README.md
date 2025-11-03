# Visual Polish Components

A collection of premium UI components with animations, hover effects, and responsive design for the HVAC Control mobile application.

## Architecture

This directory contains modularized visual polish components extracted from the monolithic `visual_polish_components.dart` file (previously 548 lines). Each component is now in its own focused file (<150 lines) following SOLID principles.

## Components

### 1. StatusIndicator (`status_indicator.dart`)
- **Purpose**: Displays active/inactive status with animated pulse effect
- **Lines**: 142
- **Features**:
  - Animated pulse for active state
  - Glow effect with customizable colors
  - Web hover states with scale animation
  - Responsive sizing with `.r` extension
- **Usage**:
```dart
StatusIndicator(
  isActive: true,
  activeLabel: 'Online',
  activeColor: HvacColors.success,
  enablePulse: true,
)
```

### 2. AnimatedBadge (`animated_badge.dart`)
- **Purpose**: Elastic animated badge for labels and notifications
- **Lines**: 148
- **Features**:
  - Elastic entry animation
  - Shimmer effect for "new" badges
  - Interactive hover/press states
  - Optional icon support
  - Haptic feedback on tap
- **Usage**:
```dart
AnimatedBadge(
  label: 'Premium',
  icon: Icons.star,
  isNew: true,
  onTap: () => print('Badge tapped'),
)
```

### 3. PremiumProgressIndicator (`premium_progress_indicator.dart`)
- **Purpose**: High-end progress bar with gradient fill
- **Lines**: 145
- **Features**:
  - Smooth animated progress updates
  - Customizable gradient
  - Optional percentage display
  - Hover effect with size increase
  - Success indicator at 100%
- **Usage**:
```dart
PremiumProgressIndicator(
  value: 0.75,
  showPercentage: true,
  label: 'Upload Progress',
)
```

### 4. FloatingTooltip (`floating_tooltip.dart`)
- **Purpose**: Overlay tooltip with fade/slide animations
- **Lines**: 143
- **Features**:
  - Smooth fade and slide animations
  - Automatic positioning (top/bottom)
  - Mouse region detection for web
  - Responsive max width constraints
  - Custom styling support
- **Usage**:
```dart
FloatingTooltip(
  message: 'Click to view details',
  position: TooltipPosition.top,
  child: IconButton(icon: Icon(Icons.info)),
)
```

### 5. AnimatedDivider (`animated_divider.dart`)
- **Purpose**: Decorative divider with gradient and animations
- **Lines**: 149
- **Features**:
  - Multiple styles (gradient, solid, primary, dashed)
  - Scale animation on mount
  - Optional shimmer effect
  - Vertical divider variant
  - Responsive height/width
- **Usage**:
```dart
AnimatedDivider(
  style: DividerStyle.gradient,
  animate: true,
)
```

## Web Optimizations

All components include web-specific enhancements:
- **Hover States**: Interactive feedback on mouse enter/exit
- **Smooth Animations**: 60fps target with optimized transitions
- **Mouse Cursors**: Appropriate cursor styles for interactive elements
- **Responsive Sizing**: All dimensions use responsive extensions (.w, .h, .r, .sp)

## Responsive Design

- **Mobile**: <600dp - Full width, touch-optimized
- **Tablet**: 600-1024dp - Adaptive sizing
- **Desktop**: >1024dp - Mouse-optimized interactions

## Migration Guide

### Old Import:
```dart
import '../widgets/common/visual_polish_components.dart';
```

### New Import (Recommended):
```dart
// Import all components
import '../widgets/common/visual_polish/visual_polish_components.dart';

// Or import individually
import '../widgets/common/visual_polish/status_indicator.dart';
```

The original file now acts as a compatibility layer, re-exporting all components from the new structure.

## Performance Considerations

1. **Animation Controllers**: Properly disposed in all stateful widgets
2. **Const Constructors**: Used where possible for better performance
3. **Overlay Management**: FloatingTooltip properly manages overlay lifecycle
4. **Hover Optimization**: Web-only hover effects don't affect mobile performance

## Testing

Each component should have corresponding tests:
- `test/widgets/visual_polish/status_indicator_test.dart`
- `test/widgets/visual_polish/animated_badge_test.dart`
- `test/widgets/visual_polish/premium_progress_indicator_test.dart`
- `test/widgets/visual_polish/floating_tooltip_test.dart`
- `test/widgets/visual_polish/animated_divider_test.dart`

## Dependencies

- `flutter_animate`: For advanced animations
- `hvac_ui_kit`: Design system tokens
- `haptic_service`: Haptic feedback support

## Accessibility

All components support:
- Minimum tap targets: 48x48dp
- Semantic labels (where applicable)
- High contrast mode compatibility
- Screen reader support through Flutter's built-in semantics