# Glassmorphic Components Library

## Overview
A modular, web-optimized collection of glassmorphic card components for the HVAC Control application. This library provides various card styles with blur effects, gradients, neumorphic designs, and glow effects.

## Components Structure

### File Organization (All files < 200 lines)
```
glassmorphic/
├── base_glassmorphic_container.dart (146 lines) - Core blur effect logic
├── glassmorphic_card.dart (198 lines) - Standard & elevated variants
├── gradient_card.dart (198 lines) - Gradient cards with animations
├── neumorphic_card.dart (197 lines) - Depth-based shadow cards
├── glow_card.dart (172 lines) - Animated glow effects
├── glassmorphic.dart (11 lines) - Main export file
└── example_usage.dart (199 lines) - Usage examples
```

## Components

### 1. Base Glassmorphic Container
Core component providing:
- Optimized blur effects (reduced on web for performance)
- Responsive border radius and padding
- Configurable backdrop filters
- Web-specific optimizations

### 2. Glassmorphic Card Variants
- **GlassmorphicCard**: Standard card with hover effects
- **ElevatedGlassmorphicCard**: Enhanced shadows and blur

### 3. Gradient Cards
- **GradientCard**: Animated gradient with hover effects
- **AnimatedGradientBackground**: Moving gradient animation

### 4. Neumorphic Cards
- **NeumorphicCard**: Standard depth-based shadows
- **SoftNeumorphicCard**: Subtle shadow effects
- **ConcaveNeumorphicCard**: Inset appearance

### 5. Glow Cards
- **GlowCard**: Animated pulsing glow
- **StaticGlowCard**: Performance-optimized static glow
- **NeonGlowCard**: Vibrant neon effects

## Web Optimizations

### Performance Features
- Reduced blur values on web (70% of mobile)
- Conditional animations based on platform
- Optimized shadow calculations
- Cursor management for web interactions

### Responsive Design
All dimensions use responsive extensions:
- `.w` for width values
- `.h` for height values
- `.sp` for font sizes
- `.r` for border radius

## Usage Examples

### Basic Glassmorphic Card
```dart
GlassmorphicCard(
  width: double.infinity,
  onTap: () => print('Tapped'),
  child: Text('Hello World'),
)
```

### Gradient Card with Colors
```dart
GradientCard(
  colors: [Colors.blue, Colors.purple],
  child: Text('Premium Feature'),
)
```

### Neumorphic Card
```dart
NeumorphicCard(
  depth: 4.0,
  onTap: () => handleTap(),
  child: Icon(Icons.settings),
)
```

### Glow Card with Custom Color
```dart
GlowCard(
  glowColor: HvacColors.primaryOrange,
  glowIntensity: 1.5,
  child: Text('Active Mode'),
)
```

## Migration from Legacy Code

### Before (528 lines in single file):
```dart
import 'package:hvac_control/presentation/widgets/common/glassmorphic_card.dart';
```

### After (Modular imports):
```dart
// Import all components
import 'package:hvac_control/presentation/widgets/common/glassmorphic/glassmorphic.dart';

// Or import specific components
import 'package:hvac_control/presentation/widgets/common/glassmorphic/glassmorphic_card.dart';
import 'package:hvac_control/presentation/widgets/common/glassmorphic/gradient_card.dart';
```

## Backward Compatibility
The original `glassmorphic_card.dart` file now acts as a compatibility wrapper, re-exporting all components. Existing code will continue to work without modification.

## Design Principles

### Clean Architecture
- Single Responsibility: Each component has one purpose
- Open/Closed: Extensible through composition
- Dependency Inversion: Components depend on abstractions

### Responsive Design
- Mobile-first approach
- All dimensions responsive
- Platform-specific optimizations

### Performance
- Web-optimized blur effects
- Conditional animations
- Efficient shadow calculations
- 60fps animation target

## Testing
Run tests with:
```bash
flutter test lib/presentation/widgets/common/glassmorphic/
```

## Accessibility
- Minimum tap targets: 48x48dp
- Proper cursor management on web
- Semantic widgets for screen readers
- Color contrast compliance

## Contributing
When adding new card variants:
1. Keep files under 200 lines
2. Use responsive dimensions
3. Include web optimizations
4. Add to main export file
5. Update example_usage.dart