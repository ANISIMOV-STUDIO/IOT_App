# HVAC UI Kit 🎨

Professional Flutter UI Kit with glassmorphism, adaptive layouts, and smooth 60 FPS animations.

## Features

✨ **Glassmorphism Design System**
- Frosted glass effects with BackdropFilter
- Premium "Liquid Glass" style (2025)
- Configurable blur levels

🎭 **Adaptive Layouts**
- Mobile, Tablet, Desktop breakpoints
- Big-tech responsive patterns (Google, Apple, Microsoft)
- Smart sizing with flutter_screenutil

⚡ **Performance Optimized**
- 60 FPS smooth animations
- RepaintBoundary isolation
- Spring physics animations

🌈 **Premium Theme System**
- Midnight & Gray color palette
- Monochromatic design philosophy
- Muted semantic colors

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  hvac_ui_kit:
    path: ../hvac_ui_kit  # Local development
    # git:
    #   url: https://github.com/your-org/hvac_ui_kit.git
    #   ref: main
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        theme: HvacTheme.darkTheme(),
        home: MyHomePage(),
      ),
    );
  }
}
```

## Components

### Theme System

```dart
// Use predefined theme
MaterialApp(
  theme: HvacTheme.darkTheme(),
);

// Access colors
Container(
  color: HvacColors.backgroundCard,
  child: Text(
    'Hello',
    style: TextStyle(color: HvacColors.textPrimary),
  ),
);
```

### Glassmorphism

```dart
// Glass Card with blur
GlassCard(
  padding: EdgeInsets.all(16),
  enableBlur: true,
  child: YourContent(),
);

// Glass Container (low-level)
GlassContainer(
  blurSigma: HvacColors.blurMedium,
  backgroundColor: HvacColors.glassShimmerBase,
  borderColor: HvacColors.glassBorder,
  child: Content(),
);

// Shimmer Animation
ShimmerAnimation(
  child: Icon(Icons.star),
);
```

### Adaptive Layouts

```dart
AdaptiveControl(
  builder: (context, deviceSize) {
    switch (deviceSize) {
      case DeviceSize.compact:
        return MobileLayout();
      case DeviceSize.medium:
        return TabletLayout();
      case DeviceSize.expanded:
        return DesktopLayout();
    }
  },
);
```

### Smooth Animations

```dart
// Fade in
SmoothAnimations.fadeIn(
  duration: AnimationDurations.normal,
  child: YourWidget(),
);

// Slide in
SmoothAnimations.slideIn(
  begin: Offset(0, 0.05),
  child: YourWidget(),
);

// Scale in
SmoothAnimations.scaleIn(
  begin: 0.95,
  child: YourWidget(),
);

// Staggered list
ListView(
  children: SmoothAnimations.staggeredList(
    children: widgets,
    staggerDelay: AnimationDurations.staggerMedium,
  ),
);
```

### Reusable Widgets

```dart
// Adaptive Slider
AdaptiveSlider(
  label: 'Fan Speed',
  icon: Icons.air,
  value: 50,
  max: 100,
  onChanged: (value) => print(value),
);

// Temperature Badge
TemperatureBadge(
  temperature: 22.5,
  label: 'Room',
);

// Status Indicator
StatusIndicator(
  isActive: true,
  activeLabel: 'Online',
  inactiveLabel: 'Offline',
);
```

## Theme Customization

```dart
// Create custom theme
final customTheme = ThemeData(
  // Use base theme
  ...HvacTheme.darkTheme(),

  // Override specific values
  colorScheme: ColorScheme.dark(
    primary: HvacColors.accent,
    secondary: HvacColors.neutral100,
  ),
);
```

## Architecture

```
hvac_ui_kit/
├── lib/
│   ├── hvac_ui_kit.dart          # Main export file
│   └── src/
│       ├── theme/
│       │   ├── colors.dart         # Color palette
│       │   ├── typography.dart     # Text styles
│       │   ├── spacing.dart        # Spacing constants
│       │   ├── radius.dart         # Border radius
│       │   ├── theme.dart          # Complete theme
│       │   └── glassmorphism.dart  # Glass components
│       ├── widgets/
│       │   ├── glass_card.dart
│       │   ├── adaptive_slider.dart
│       │   ├── status_indicator.dart
│       │   └── temperature_badge.dart
│       ├── animations/
│       │   ├── smooth_animations.dart
│       │   └── spring_physics.dart
│       └── utils/
│           ├── adaptive_layout.dart
│           ├── performance_utils.dart
│           └── responsive_utils.dart
├── example/               # Example app
├── test/                 # Unit tests
└── pubspec.yaml
```

## Performance Guidelines

- Use `RepaintBoundary` for complex widgets
- Keep blur sigma between 8-12 for optimal performance
- Enable blur conditionally based on device capabilities
- Use `const` constructors whenever possible

## Design Philosophy

**Monochromatic + Single Noble Accent**
- 95% neutral grays
- 5% sophisticated accent color
- Muted semantic colors
- No "rainbow" or "traffic light" design

**Inspired by:**
- Apple Design Language
- Tesla UI/UX
- Google Material Design 3
- Microsoft Fluent Design

## License

MIT License - See LICENSE file for details

## Contributing

Contributions are welcome! Please read CONTRIBUTING.md for guidelines.

## Changelog

### 1.0.0 (2025-01-03)
- Initial release
- Glassmorphism components
- Adaptive layout system
- Smooth 60 FPS animations
- Premium color palette
- Performance optimizations
