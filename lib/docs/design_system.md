# Design System

> BREEZ Home Application - Design Specifications

## Overview

This design system defines the visual language and component library for the BREEZ Home application. It ensures consistency across all screens and platforms (iOS, Android, Web).

---

## Color Palette

### Primary Colors

```dart
primaryOrange:       #FFB267  // Main brand color
primaryOrangeDark:   #E8A055  // Hover states
primaryOrangeLight:  #FFCEA0  // Highlights (70% opacity)
primaryOrangeBorder: #FFB267  // Borders (60% opacity)
```

**Usage:**
- Primary actions and CTAs
- Active states and selection
- Focus indicators
- Brand identity elements

### Background Colors

```dart
backgroundDark:       #211D1D  // Main background
backgroundCard:       #282424  // Card background
backgroundCardBorder: #393535  // Card borders
```

**Usage:**
- App background: backgroundDark
- Cards and panels: backgroundCard
- Separators and borders: backgroundCardBorder

### Text Colors

```dart
textPrimary:   #F8F8F8              // High emphasis (100%)
textSecondary: rgba(255,255,255,0.6) // Medium emphasis (60%)
textTertiary:  rgba(255,255,255,0.4) // Low emphasis (40%)
```

**Usage:**
- Headlines and body text: textPrimary
- Supporting text and labels: textSecondary
- Disabled and placeholder: textTertiary

### Status Colors

```dart
success: #4CAF50  // Green - Success states
error:   #EF4444  // Red - Errors and alerts
warning: #FFA726  // Orange - Warnings
info:    #42A5F5  // Blue - Information
```

### HVAC Mode Colors

```dart
modeCool: #42A5F5  // Cooling mode (Blue)
modeHeat: #EF5350  // Heating mode (Red)
modeFan:  #66BB6A  // Fan mode (Green)
modeDry:  #FFCA28  // Dry mode (Yellow)
modeAuto: #AB47BC  // Auto mode (Purple)
```

---

## Spacing System (8px Grid)

All spacing values are multiples of 8px for visual consistency.

```dart
// Using flutter_screenutil for responsive scaling

XXS:  4.w   // 4px  - Minimal spacing
XS:   8.w   // 8px  - Tight spacing
SM:   12.w  // 12px - Small spacing
MD:   16.w  // 16px - Default spacing
LG:   24.w  // 24px - Large spacing
XL:   32.w  // 32px - Extra large spacing
XXL:  48.w  // 48px - Huge spacing
XXXL: 64.w  // 64px - Maximum spacing
```

**Usage Guidelines:**
- Card padding: MD (16px)
- Section spacing: LG (24px)
- Screen padding: MD or LG
- Element spacing: XS or SM
- Between sections: XL or XXL

---

## Border Radius

```dart
// From lib/core/theme/app_radius.dart

radiusXS:   4.r   // 4px  - Small elements
radiusSM:   8.r   // 8px  - Buttons, chips
radiusMD:   12.r  // 12px - Input fields, small cards
radiusLG:   16.r  // 16px - Cards, panels
radiusXL:   24.r  // 24px - Large cards
radiusXXL:  32.r  // 32px - Special elements
radiusFull: 999.r // 999px - Circular (pills)
```

**Usage:**
- Cards: radiusLG (16px)
- Buttons: radiusMD (12px)
- Input fields: radiusMD (12px)
- Chips/Badges: radiusSM (8px)
- Avatars: radiusFull (circular)

---

## Typography

### Font Family
**System Default** - Uses platform native fonts for optimal performance

### Text Styles

#### Display
```dart
displayLarge:  57.sp, weight: 700, letterSpacing: -0.25
displayMedium: 45.sp, weight: 700
displaySmall:  36.sp, weight: 600
```
**Usage:** Landing pages, hero sections

#### Headlines
```dart
headlineLarge:  32.sp, weight: 600
headlineMedium: 28.sp, weight: 600
headlineSmall:  24.sp, weight: 600
```
**Usage:** Section headers, screen titles

#### Titles
```dart
titleLarge:  22.sp, weight: 600
titleMedium: 18.sp, weight: 600
titleSmall:  16.sp, weight: 600
```
**Usage:** Card titles, list headers

#### Body
```dart
bodyLarge:  16.sp, weight: 400, color: textPrimary
bodyMedium: 14.sp, weight: 400, color: textSecondary
bodySmall:  12.sp, weight: 400, color: textTertiary
```
**Usage:** Body content, descriptions

#### Labels
```dart
labelLarge:  18.sp, weight: 600, color: textPrimary
labelMedium: 14.sp, weight: 500, color: textPrimary
labelSmall:  12.sp, weight: 500, color: textSecondary
```
**Usage:** Form labels, button text

---

## Components

### Buttons

#### Primary Button (OrangeButton)
```dart
Background: primaryOrange
Text: textPrimary (white)
Height: 48.h minimum
Padding: 16.w horizontal, 12.h vertical
Border radius: 12.r
Font: labelLarge (18.sp, weight: 600)
```

#### Outline Button
```dart
Background: transparent
Border: 1px primaryOrange
Text: primaryOrange
Height: 48.h minimum
Padding: 16.w horizontal, 12.h vertical
Border radius: 12.r
Font: labelLarge (18.sp, weight: 600)
```

#### Icon Button
```dart
Size: 48.w x 48.h minimum (accessibility)
Icon size: 24.w
Padding: 12.w
Ripple: primaryOrange with 20% opacity
```

### Cards

#### Standard Card
```dart
Background: backgroundCard
Border: 1px backgroundCardBorder
Padding: 20.w
Border radius: 16.r
Elevation: 0 (flat design)
```

#### Selected Card
```dart
Background: backgroundCard
Border: 2px primaryOrange
Padding: 20.w
Border radius: 16.r
Elevation: 0
```

### Input Fields

```dart
Background: backgroundCard
Border: 1px backgroundCardBorder
Focused border: 2px primaryOrange
Error border: 1px error
Padding: 16.w horizontal, 16.h vertical
Border radius: 12.r
Label: bodyMedium (14.sp, textSecondary)
Input text: bodyLarge (16.sp, textPrimary)
```

### Switches

```dart
Track (off): backgroundCardBorder
Track (on):  primaryOrange
Thumb (off): textTertiary
Thumb (on):  white
Size: Material 3 standard (52x32)
```

### Sliders

```dart
Active track: primaryOrange
Inactive track: backgroundCardBorder
Thumb: white (20x20)
Overlay: primaryOrange 20% opacity
Track height: 4.h
```

---

## Icons

### Icon Sizes
```dart
Small:    16.w
Medium:   20.w
Default:  24.w
Large:    32.w
XLarge:   48.w
```

### Icon Library
- **Primary:** Material Icons (Flutter default)
- **Secondary:** Line Icons (line_icons package)
- **Custom:** SVG assets for brand-specific icons

---

## Shadows & Elevation

**Flat Design Approach** - No shadows used in the current design

**Alternatives:**
- Borders for card separation
- Background color contrast
- Subtle gradients for depth

If shadows needed:
```dart
boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 8,
    offset: Offset(0, 2),
  ),
]
```

---

## Animations

### Duration
```dart
Fast:   150ms  // Micro-interactions
Normal: 300ms  // Standard transitions
Slow:   500ms  // Complex animations
```

### Curves
```dart
Standard:     Curves.easeInOut
Decelerate:   Curves.easeOut
Accelerate:   Curves.easeIn
Emphasized:   Curves.easeInOutCubic
Bounce:       Curves.elasticOut
```

### Common Animations
- Button press: Scale 0.95, 150ms
- Card entry: SlideIn + FadeIn, 300ms
- Modal: SlideUp + FadeIn, 300ms
- Tab switch: FadeThrough, 200ms

**Framework:** flutter_animate (v4.5.0)

---

## Responsive Breakpoints

```dart
Mobile:   < 600px   // Phone portrait
Tablet:   600-1024px // Tablet or phone landscape
Desktop:  > 1024px  // Desktop or large tablet
```

### Adaptive Layout
- **Mobile:** Single column, bottom navigation
- **Tablet:** Two columns, side navigation option
- **Desktop:** Three columns, persistent sidebar

---

## Accessibility

### WCAG AA Compliance

**Color Contrast Ratios:**
- textPrimary on backgroundDark: 17.2:1 ✅ (AAA)
- textSecondary on backgroundCard: 7.1:1 ✅ (AA)
- primaryOrange on backgroundDark: 8.4:1 ✅ (AAA)

**Minimum Requirements:**
- Normal text: 4.5:1
- Large text (18sp+): 3:1
- UI components: 3:1

### Touch Targets
- Minimum size: 48x48dp
- Minimum spacing: 8dp
- All interactive elements comply

### Semantic Labels
- All images have alt text
- All icons have descriptions
- Buttons have meaningful labels
- Form fields have labels

### Haptic Feedback
- Light: Menu selection, tab switch
- Medium: Toggle, checkbox
- Heavy: Error, success confirmation

---

## Grid System

**8px Base Grid**
- All measurements are multiples of 8
- Half-steps (4px) for fine-tuning
- Consistent visual rhythm

**Layout Grid:**
- Margins: 16px (mobile), 24px (tablet+)
- Gutters: 16px
- Columns: 4 (mobile), 8 (tablet), 12 (desktop)

---

## Best Practices

### DO ✅
- Use themed colors from AppTheme
- Follow 8px spacing grid
- Use .w, .h, .sp for responsive sizing
- Add const constructors
- Use semantic labels for accessibility
- Add haptic feedback to interactions
- Keep files under 300 lines
- Use meaningful widget names

### DON'T ❌
- Hard-code pixel values
- Use random spacing
- Ignore accessibility guidelines
- Skip const constructors
- Forget haptic feedback
- Create files over 300 lines
- Use magic numbers
- Omit semantic labels

---

## File Organization

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart      // Main theme
│   │   ├── spacing.dart        // Spacing constants
│   │   └── app_radius.dart     // Radius constants
│   └── utils/
│       └── responsive_utils.dart // Breakpoint helpers
├── presentation/
│   └── widgets/
│       ├── orange_button.dart  // Primary button
│       ├── gradient_button.dart
│       └── [other widgets]
└── docs/
    ├── design_system.md        // This file
    ├── component_library.md    // Component catalog
    └── responsive_test_report.md
```

---

## Resources

- **Figma Design:** [Link to design file]
- **flutter_screenutil:** https://pub.dev/packages/flutter_screenutil
- **flutter_animate:** https://pub.dev/packages/flutter_animate
- **WCAG Guidelines:** https://www.w3.org/WAI/WCAG21/quickref/

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-11-02 | Initial design system documentation |

---

**Maintained by:** Development Team
**Last Updated:** November 2, 2025
