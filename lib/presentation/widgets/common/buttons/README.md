# Animated Button Components

## Overview

A collection of web-optimized animated button components for the BREEZ Home application. Originally refactored from a single 571-line file into modular, maintainable components.

## Components

### 1. AnimatedPrimaryButton (210 lines)
- Primary action button with gradient background
- Scale animation on press
- Haptic feedback support
- Loading state with spinner
- Hover effects with shadow enhancement
- Support for icons and expanded width

### 2. AnimatedOutlineButton (198 lines)
- Secondary action button with border
- Animated border width on hover
- Customizable colors
- Loading state support
- Web-optimized cursor interactions

### 3. AnimatedIconButton (214 lines)
- Circular icon button
- Ripple effect animation
- Tooltip support
- Customizable size and colors
- Hover scale animation
- Disabled state with cursor feedback

### 4. AnimatedTextButton (205 lines)
- Text-only button for links
- Animated underline on hover
- Optional icon support
- Loading state
- Customizable text color
- Multiple size variants

### 5. AnimatedFAB (210 lines)
- Floating Action Button
- Elastic entry animation
- Extended variant with label
- Mini size option
- Hover scale and shadow effects
- Custom colors support

### 6. BaseAnimatedButton (135 lines)
- Shared mixin for common animation logic
- Button size configurations (small, medium, large)
- Common button properties
- Mouse cursor management
- Haptic feedback utilities

## Features

### Web Optimizations
- ✅ `SystemMouseCursors.click` on all interactive elements
- ✅ `SystemMouseCursors.forbidden` for disabled states
- ✅ Hover animations with scale and color transitions
- ✅ Ripple/splash effects using Material InkWell
- ✅ Shadow enhancements on hover

### Responsive Design
- All dimensions use responsive extensions (.w, .h, .sp, .r)
- Flexible sizing with ButtonSize configurations
- Support for expanded width variants
- Proper text overflow handling

### Accessibility
- Minimum tap targets of 48x48dp
- Tooltip support for icon buttons
- Proper disabled state handling
- High contrast text on buttons
- Screen reader compatible with semantic labels

### Animation Performance
- 60fps animations using AnimatedBuilder
- Optimized animation curves
- Proper disposal of animation controllers
- Hardware-accelerated transforms

## Usage

```dart
import 'package:your_app/presentation/widgets/common/animated_button.dart';

// Primary button
AnimatedPrimaryButton(
  label: 'Get Started',
  onPressed: () {},
  icon: Icons.arrow_forward,
  size: ButtonSize.large,
)

// Outline button
AnimatedOutlineButton(
  label: 'Learn More',
  onPressed: () {},
  borderColor: Colors.blue,
)

// Icon button
AnimatedIconButton(
  icon: Icons.favorite,
  onPressed: () {},
  tooltip: 'Like',
  iconColor: Colors.red,
)

// Text button
AnimatedTextButton(
  label: 'View Details',
  onPressed: () {},
  showUnderline: true,
)

// FAB
AnimatedFAB(
  icon: Icons.add,
  onPressed: () {},
  label: 'New Item',
  extended: true,
)
```

## Migration from Original

The original `animated_button.dart` (571 lines) has been preserved for backward compatibility and now re-exports all components from the buttons subdirectory.

```dart
// Old import (still works)
import 'package:your_app/presentation/widgets/common/animated_button.dart';

// New modular imports (recommended)
import 'package:your_app/presentation/widgets/common/buttons/animated_primary_button.dart';
import 'package:your_app/presentation/widgets/common/buttons/animated_outline_button.dart';
// etc...
```

## File Structure

```
lib/presentation/widgets/common/
├── animated_button.dart (5 lines - backward compatibility export)
└── buttons/
    ├── animated_button.dart (17 lines - main export file)
    ├── base_animated_button.dart (135 lines - shared logic)
    ├── animated_primary_button.dart (210 lines)
    ├── animated_outline_button.dart (198 lines)
    ├── animated_icon_button.dart (214 lines)
    ├── animated_text_button.dart (205 lines)
    ├── animated_fab.dart (210 lines)
    ├── button_demo.dart (273 lines - demo/showcase)
    └── README.md (this file)
```

## Benefits of Refactoring

1. **Maintainability**: Each button type is now in its own file (<215 lines each)
2. **Reusability**: Shared logic extracted to base class
3. **Web-Ready**: All buttons have proper cursor management and hover states
4. **Performance**: Optimized animations with proper disposal
5. **Type Safety**: Clear separation of concerns with focused interfaces
6. **Testing**: Easier to unit test individual button components
7. **Documentation**: Each component has clear purpose and usage

## Demo

Run the `ButtonDemo` widget to see all button variants in action:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => ButtonDemo()),
);
```

## Notes

- All buttons follow HVAC design system (colors, typography, spacing, radius)
- Haptic feedback is enabled by default (can be disabled)
- Loading states are built-in for async operations
- All animations respect user's reduce motion preferences
- Components are tree-shakeable for optimal bundle size