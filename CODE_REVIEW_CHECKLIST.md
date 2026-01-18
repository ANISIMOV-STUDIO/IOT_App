# Code Review Checklist

> Comprehensive checklist for reviewing code changes in the IOT_App Flutter project.
>
> **Instructions:** For each PR/commit, go through all applicable sections and check off items as you verify them.

---

## 1. Design System Compliance

### Spacing
- [ ] Uses `AppSpacing.*` constants for all spacing (no hardcoded `EdgeInsets` or `SizedBox` values)
- [ ] Follows 8px grid system (`xxs: 4`, `xs: 8`, `sm: 12`, `md: 16`, `lg: 20`, `lgx: 24`, `xl: 32`, `xxl: 48`)
- [ ] External spacing (between widgets) uses `AppSpacing.sm` (12px)
- [ ] Internal padding (inside widgets) uses `AppSpacing.xs` (8px)
- [ ] Micro-spacing (icon-to-text) uses `AppSpacing.xxs` (4px)
- [ ] No magic numbers like `EdgeInsets.all(16)` or `SizedBox(height: 12)`

### Colors
- [ ] Uses `BreezColors.of(context)` for theme-dependent colors
- [ ] Uses static `AppColors.*` constants for accent/brand colors only
- [ ] No direct usage of `Colors.white`, `Colors.black` (use `AppColors.white`/`AppColors.black`)
- [ ] No hardcoded hex colors like `Color(0xFF123456)`
- [ ] Opacity values use `AppColors.opacity*` constants or `.withValues(alpha: 0.x)` pattern
- [ ] Theme switching works correctly (light/dark modes tested)

### Border Radius
- [ ] Uses `AppRadius.*` constants for all border radius values
  - `card: 16` - Cards
  - `cardSmall: 12` - Buttons, small cards
  - `button: 12` - Buttons
  - `nested: 10` - Nested elements inside cards
  - `chip: 8` - Chips, tags, segmented controls
  - `indicator: 4` - Indicators, badges
- [ ] No hardcoded values like `BorderRadius.circular(8)`

### Sizes & Dimensions
- [ ] Uses `AppSizes.*` for component dimensions
- [ ] Uses `AppIconSizes.*` for icon sizes
- [ ] Uses `AppFontSizes.*` for all font sizes (no hardcoded `fontSize: 14`)
- [ ] Touch targets are minimum 48x48px for mobile (Material Design)

### Animations
- [ ] Uses `AppDurations.*` for animation durations
  - `fast: 150ms` - Hover, focus states
  - `normal: 200ms` - Standard transitions
  - `medium: 300ms` - Expand/collapse
- [ ] Uses `AppCurves.*` for animation curves
  - `standard` - Default easing
  - `emphasize` - Important transitions
- [ ] No hardcoded `Duration(milliseconds: 200)`

---

## 2. Component Usage

### Breez Components
- [ ] Uses `BreezButton` instead of `ElevatedButton`/`TextButton`/`OutlinedButton`
- [ ] Uses `BreezIconButton` instead of `IconButton`
- [ ] Uses `BreezCard` for card containers (not raw `Container` with decoration)
- [ ] Uses `BreezTextField` for text inputs (not raw `TextField`)
- [ ] Uses `BreezSlider` for sliders
- [ ] Uses `BreezDropdown` for dropdowns
- [ ] Uses `BreezCheckbox` for checkboxes
- [ ] Uses `BreezTab` for tab navigation
- [ ] Uses `BreezLoader` (fan icon) for loading states
  - `BreezLoader.small()` - Inline, 16px
  - `BreezLoader.medium()` - Standard, 24px
  - `BreezLoader.large()` - Centered, 32px

### Component Patterns
- [ ] Follows `showCard` pattern for nested components (default `true`, set `false` to avoid double borders)
- [ ] Components with cards have `showCard` parameter implemented correctly
- [ ] Nested components inside cards use `showCard: false`

### Import Pattern
- [ ] Uses unified import: `import 'package:hvac_control/presentation/widgets/breez/breez.dart';`
- [ ] No individual component imports unless necessary

---

## 3. Code Quality

### SOLID Principles
- [ ] **Single Responsibility:** Each widget/class has one clear purpose
- [ ] **Open/Closed:** Components are extensible via parameters, not modification
- [ ] **Liskov Substitution:** Subclasses can replace base classes without breaking behavior
- [ ] **Interface Segregation:** Interfaces are focused (no "god interfaces")
- [ ] **Dependency Inversion:** Depends on abstractions (repositories) not implementations

### DRY (Don't Repeat Yourself)
- [ ] No code duplication - repeated logic extracted to methods/widgets
- [ ] Conditional rendering doesn't duplicate UI code (extract common parts)
- [ ] Uses `Map` lookup instead of verbose `switch-case` statements where appropriate

### Code Organization
- [ ] Constants extracted to `abstract class _WidgetNameConstants`
- [ ] Magic numbers eliminated (all values are named constants)
- [ ] Private widgets extracted (`_Header`, `_Content`, `_TimeBlock`, etc.)
- [ ] File structure follows template:
  - Imports
  - Constants section
  - Main widget
  - State class (if stateful)
  - Private widgets
- [ ] Proper widget decomposition (widgets are small and focused)
- [ ] Methods extracted for complex logic (`_buildHeader()`, `_handleTap()`, etc.)

### Naming Conventions
- [ ] Files use correct patterns:
  - Components: `breez_*.dart`
  - BLoC: `*_bloc.dart`, `*_event.dart`, `*_state.dart`
  - Screens: `*_screen.dart`
  - Widgets: descriptive names (`daily_schedule_widget.dart`)
- [ ] Private widgets: `_WidgetName` (leading underscore)
- [ ] Private methods: `_methodName` (leading underscore)
- [ ] Booleans: `isEnabled`, `hasData`, `canSubmit`, `shouldShow`
- [ ] Callbacks: `onTap`, `onChanged`, `onHover`
- [ ] Constants class: `_WidgetNameConstants` (private, abstract)

---

## 4. Accessibility

### Semantics
- [ ] All interactive elements have `Semantics` wrappers
- [ ] Buttons have `Semantics(button: true, label: '...')`
- [ ] Headers have `Semantics(header: true)`
- [ ] Toggles have `Semantics(toggled: bool, label: '...')`
- [ ] Images have `Semantics(image: true, label: '...')`
- [ ] Screen reader friendly descriptions provided

### UX Considerations
- [ ] Touch targets are minimum 48x48px on mobile
- [ ] Focus indicators visible for keyboard navigation
- [ ] Color contrast meets WCAG AA standards (4.5:1 for text)
- [ ] Interactive elements have visible hover/pressed states
- [ ] Error messages are clear and actionable
- [ ] Loading states have appropriate feedback (loaders, disabled states)

---

## 5. Architecture

### Clean Architecture Layers
- [ ] Layer boundaries respected:
  - **Presentation:** Only UI, BLoC, and widgets
  - **Domain:** Entities, repository interfaces, use cases
  - **Data:** Repository implementations, API clients, DTOs
  - **Core:** Theme, DI, services
- [ ] No business logic in widgets (moved to BLoC)
- [ ] No direct API calls from widgets (goes through repositories)
- [ ] Dependencies point inward (Presentation → Domain ← Data)

### BLoC Pattern
- [ ] Events use `sealed class` pattern with `final class` subtypes
- [ ] State uses `Equatable` with proper `props` implementation
- [ ] State has status enum: `initial`, `loading`, `success`, `failure`
- [ ] Optimistic updates implemented where appropriate:
  1. Update UI immediately
  2. Send request to server
  3. Rollback on error
- [ ] Pending states tracked with `isPending*` flags
- [ ] Error handling with rollback mechanism
- [ ] No state mutations (uses `copyWith`)

### State Management
- [ ] Loading states block UI appropriately
- [ ] Pending operations show `BreezLoader`
- [ ] Interactive elements disabled during pending operations
- [ ] Error states display user-friendly messages
- [ ] Success states provide feedback (snackbar, visual confirmation)

---

## 6. File Structure & Organization

### Project Structure
- [ ] Files in correct directories:
  - `lib/core/theme/` - Design system
  - `lib/core/di/` - Dependency injection
  - `lib/domain/` - Entities, repository interfaces
  - `lib/data/` - Repository implementations, DTOs
  - `lib/presentation/bloc/` - BLoC state management
  - `lib/presentation/widgets/breez/` - Reusable components
  - `lib/presentation/screens/` - Screen widgets

### Imports Organization
- [ ] Imports organized in three sections:
  1. Flutter SDK imports (`package:flutter/...`)
  2. Third-party packages (`package:other_package/...`)
  3. Relative imports (`../../../...`)
- [ ] No unused imports
- [ ] Import statements sorted alphabetically within each section

### File Contents
- [ ] Public APIs have documentation comments (`///`)
- [ ] Complex logic has explanatory comments
- [ ] Constants section at top of file (after imports)
- [ ] Private widgets after public widgets
- [ ] No commented-out code left in files
- [ ] No TODO comments without tracking (use issue tracker)

---

## 7. Performance

### Build Performance
- [ ] No expensive operations in `build()` method
- [ ] Uses `const` constructors wherever possible
- [ ] Keys used appropriately (for lists, reorderable items)
- [ ] No unnecessary rebuilds (checked with DevTools)
- [ ] Large lists use `ListView.builder` or `GridView.builder` (not `.map().toList()`)

### Memory Management
- [ ] Controllers disposed properly (`dispose()` method)
- [ ] Streams closed properly
- [ ] Listeners removed in `dispose()`
- [ ] No memory leaks (checked with DevTools)

### State Updates
- [ ] Uses `mounted` check before `setState()` after async operations
- [ ] Avoids calling `setState()` in loops
- [ ] BLoC events don't cause unnecessary state emissions
- [ ] Equatable's `props` includes all state fields

---

## 8. Responsive Design

### Breakpoints
- [ ] Uses `AppBreakpoints` for device detection
  - `isMobile(context)` - < 600px
  - `isTablet(context)` - 600-1024px
  - `isDesktop(context)` - > 1024px
- [ ] Or uses context extensions: `context.isMobile`, `context.isTablet`, `context.isDesktop`
- [ ] Grid columns adapt: `AppBreakpoints.getGridColumns(context)`

### Adaptive Layouts
- [ ] Mobile layout differs from desktop where appropriate
- [ ] Touch targets sized correctly for mobile (48x48px minimum)
- [ ] Compact mode works on small screens
- [ ] Tablet layout provides optimal use of space
- [ ] Desktop layout uses multi-column where beneficial

### Mobile UI Patterns
- [ ] Internal tabs use segmented control style (not navigation tabs)
- [ ] Avoid double navigation (bottom bar + tabs that look like navigation)
- [ ] Fixed heights for tab content to prevent layout shifts
- [ ] Bottom sheet used appropriately for mobile actions

---

## 9. Loading States & Loaders

### BreezLoader Usage
- [ ] Uses `BreezLoader` (fan icon from `material_symbols_icons`)
- [ ] Correct size for context:
  - `small()` - Inline with text, 16px
  - `medium()` - Standard, 24px (default)
  - `large()` - Centered/overlay, 32px
- [ ] Color matches context (e.g., heating/cooling color)
- [ ] Full-screen loaders use `BreezLoaderWithText(text: '...')`

### Pending State Patterns
- [ ] Temperature changes show loader instead of value during pending
- [ ] Sliders disabled with `isPending` flag
- [ ] Power toggle shows full-card overlay with loader
- [ ] Buttons disabled during pending operations
- [ ] State tracks pending operations:
  - `isPendingHeatingTemperature`
  - `isPendingCoolingTemperature`
  - `isPendingSupplyFan`
  - `isPendingExhaustFan`
  - `isTogglingPower`
  - `isTogglingSchedule`

---

## 10. Testing

### Manual Testing
- [ ] `flutter analyze` passes with zero errors/warnings
- [ ] No console errors in debug mode
- [ ] No console warnings in debug mode
- [ ] Dark theme renders correctly
- [ ] Light theme renders correctly
- [ ] Tested on mobile viewport (< 600px)
- [ ] Tested on tablet viewport (600-1024px) if applicable
- [ ] Tested on desktop viewport (> 1024px) if applicable
- [ ] Hot reload works without errors
- [ ] Hot restart works without errors

### Functional Testing
- [ ] All interactive elements respond correctly
- [ ] Loading states display properly
- [ ] Error states display user-friendly messages
- [ ] Optimistic updates rollback on error
- [ ] Navigation works as expected
- [ ] Forms validate correctly
- [ ] API integration works (if applicable)

### Edge Cases
- [ ] Empty states handled gracefully
- [ ] Error states handled gracefully
- [ ] Long text doesn't overflow
- [ ] Small screens don't cause layout issues
- [ ] Large datasets perform well
- [ ] Network errors handled appropriately

---

## 11. Git & Version Control

### Commit Quality
- [ ] Commit message follows conventions:
  - Format: `type(scope): description`
  - Types: `feat`, `fix`, `refactor`, `style`, `docs`, `test`, `chore`
  - Example: `feat(climate): add optimistic temperature updates`
- [ ] Commit message is clear and descriptive
- [ ] Commits are atomic (one logical change per commit)
- [ ] No merge conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)

### Code Hygiene
- [ ] No commented-out code blocks
- [ ] No debug `print()` statements left in code
- [ ] No temporary test code left in files
- [ ] No unused variables or imports
- [ ] No dead code (unreachable code paths)

### PR Quality
- [ ] PR description explains what and why
- [ ] PR title is clear and descriptive
- [ ] PR is focused (not mixing unrelated changes)
- [ ] Screenshots provided for UI changes
- [ ] Breaking changes documented

---

## 12. Documentation

### Code Documentation
- [ ] Public APIs have doc comments (`///`)
- [ ] Complex algorithms explained with comments
- [ ] Widget parameters documented
- [ ] Non-obvious behavior explained
- [ ] Examples provided for complex APIs

### Files & Updates
- [ ] No proactive README/documentation files created unless requested
- [ ] Existing documentation updated if behavior changes
- [ ] Breaking changes documented in CHANGELOG.md
- [ ] Architecture changes reflected in PROJECT_CONTEXT.md

---

## Quick Reference

### Design System Constants Locations

| Constant | File Path | Usage |
|----------|-----------|-------|
| `AppSpacing.*` | `lib/core/theme/spacing.dart` | All spacing/padding/margins |
| `AppColors.*` | `lib/core/theme/app_colors.dart` | Static colors (accent, error, etc.) |
| `BreezColors.of(context)` | `lib/core/theme/app_colors.dart` | Theme-dependent colors |
| `AppRadius.*` | `lib/core/theme/app_radius.dart` | Border radius values |
| `AppSizes.*` | `lib/core/theme/app_sizes.dart` | Component dimensions |
| `AppIconSizes.*` | `lib/core/theme/app_icon_sizes.dart` | Icon sizes |
| `AppFontSizes.*` | `lib/core/theme/app_font_sizes.dart` | Typography sizes |
| `AppDurations.*` | `lib/core/theme/app_animations.dart` | Animation durations |
| `AppCurves.*` | `lib/core/theme/app_animations.dart` | Animation curves |
| `AppBreakpoints.*` | `lib/core/theme/breakpoints.dart` | Responsive breakpoints |

### Component Import
```dart
// Single import for all Breez components
import 'package:hvac_control/presentation/widgets/breez/breez.dart';
```

### Run Checks
```bash
# Analyze code
flutter analyze

# Run tests
flutter test

# Check formatting
dart format --set-exit-if-changed .

# Run build (check for runtime errors)
flutter build apk --debug
```

---

## Reference Files

Use these as gold standard examples:

| Aspect | Reference File | What to Learn |
|--------|----------------|---------------|
| Widget Structure | `lib/presentation/screens/schedule/widgets/daily_schedule_widget.dart` | Complete structure: constants, SRP, Semantics |
| Component Design | `lib/presentation/widgets/breez/breez_tab.dart` | Accessibility, hover states, extracted methods |
| Compact Mode | `lib/presentation/screens/climate/widgets/temp_column.dart` | Compact pattern, Semantics on buttons |
| BLoC Pattern | `lib/presentation/bloc/climate/climate_bloc.dart` | Optimistic updates, sealed events |
| Responsive Layout | `lib/presentation/screens/climate/climate_screen.dart` | Mobile/tablet/desktop layouts |

---

## Common Issues & Solutions

### Issue: Late initialization error on hot reload
**Solution:** Initialize variables at declaration, not in `initState()`:
```dart
// Bad
late int _selectedIndex;
@override
void initState() {
  _selectedIndex = 0;
}

// Good
int _selectedIndex = 0;
```

### Issue: RenderFlex overflow
**Solution:** Use `Expanded`, `Flexible`, or `ListView`, not `Spacer` in constrained space:
```dart
// Bad
Column(children: [Widget(), Spacer(), Widget()])

// Good
Column(children: [Widget(), Expanded(child: Widget())])
```

### Issue: setState() after dispose
**Solution:** Always check `mounted` before `setState()` after async operations:
```dart
final result = await someAsyncOperation();
if (mounted) {
  setState(() => _value = result);
}
```

### Issue: Hardcoded colors not respecting theme
**Solution:** Use `BreezColors.of(context)` for theme-dependent colors:
```dart
// Bad
color: Colors.white

// Good
final colors = BreezColors.of(context);
color: colors.text
```

---

**Last Updated:** 2026-01-18

**Project:** IOT_App - Flutter HVAC Control

**Maintainer:** Development Team
