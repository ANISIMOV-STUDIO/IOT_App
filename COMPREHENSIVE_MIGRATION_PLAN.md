# COMPREHENSIVE UI KIT MIGRATION PLAN
**BREEZ Home HVAC Application - Big Tech Standards Compliance**

---

## EXECUTIVE SUMMARY

**Current State Analysis:**
- **Total Widget Files**: 236 files in `lib/presentation/widgets/`
- **Generic Components Identified**: 127 files (53.8%)
- **Domain-Specific Components**: 109 files (46.2%)
- **Components Already in UI Kit**: 35 files
- **Duplicates to Resolve**: 6 files
- **Missing Big Tech Standards**: 42 component types

**Migration Scope:**
- **Components to Move**: 127 files → hvac_ui_kit package
- **Components to Create**: 42 new components (Material Design 3 compliance)
- **Components to Refactor**: 18 files exceeding 300 lines
- **Duplicates to Delete**: 6 files

**Effort Estimation:**
- **Total Effort**: ~186 hours (4.6 weeks @ 40 hours/week)
- **Phase 1 (Critical)**: 24 hours
- **Phase 2 (Foundation)**: 32 hours
- **Phase 3 (Atomic Components)**: 48 hours
- **Phase 4 (Composite Components)**: 36 hours
- **Phase 5 (Feedback)**: 18 hours
- **Phase 6 (Navigation)**: 12 hours
- **Phase 7 (Layout)**: 8 hours
- **Phase 8 (New Components)**: 8 hours

**Success Criteria:**
- ✅ Zero files in `lib/presentation/widgets/common/`
- ✅ 100% Material Design 3 component coverage
- ✅ All files <300 lines
- ✅ Zero duplicates
- ✅ Complete test coverage for all UI Kit components
- ✅ All imports updated to use `package:hvac_ui_kit/hvac_ui_kit.dart`

---

## PHASE 1: DUPLICATES & CRITICAL FIXES
**Duration**: 24 hours | **Priority**: CRITICAL

### 1.1 Resolve Duplicate Components

#### Duplicate #1: AnimatedBadge
**Issue**: Exists in both locations with different implementations

**Locations:**
- `lib/presentation/widgets/common/visual_polish/animated_badge.dart` (158 lines)
- `packages/hvac_ui_kit/lib/src/widgets/animated_badge.dart` (146 lines)

**Resolution:**
1. **Compare implementations** (1 hour)
   - Read both files line by line
   - Identify feature differences
   - Create merged feature matrix

2. **Merge into single component** (2 hours)
   - Take UI Kit version as base (more mature)
   - Add missing features from common/visual_polish version:
     - `isNew` property with pulse animation
     - Enhanced haptic feedback integration
   - Ensure backward compatibility

3. **Update all references** (1 hour)
   ```bash
   # Find all usages
   grep -r "AnimatedBadge" lib/ --include="*.dart"

   # Update imports from:
   import '../widgets/common/visual_polish/animated_badge.dart';

   # To:
   import 'package:hvac_ui_kit/hvac_ui_kit.dart';
   ```

4. **Delete duplicate** (0.5 hours)
   - Remove `lib/presentation/widgets/common/visual_polish/animated_badge.dart`
   - Run tests to verify no breakage

**Files to Update**: ~12 files
**Effort**: 4.5 hours

---

#### Duplicate #2: Enhanced Shimmer / Base Shimmer
**Issue**: Shimmer component duplicated across packages

**Locations:**
- `lib/presentation/widgets/common/enhanced_shimmer.dart` (exports)
- `lib/presentation/widgets/common/shimmer/base_shimmer.dart` (implementation)
- `packages/hvac_ui_kit/lib/src/animations/widgets/shimmer_effect.dart` (different approach)

**Resolution:**
1. **Consolidate shimmer system** (3 hours)
   - Move entire `lib/presentation/widgets/common/shimmer/*` to UI Kit
   - Destination: `packages/hvac_ui_kit/lib/src/widgets/shimmer/`
   - Keep modular structure:
     - `base_shimmer.dart`
     - `pulse_skeleton.dart`
     - `skeleton_primitives.dart`
     - `skeleton_cards.dart`
     - `skeleton_lists.dart`
     - `skeleton_screens.dart`

2. **Update barrel exports** (1 hour)
   - Add to `packages/hvac_ui_kit/lib/hvac_ui_kit.dart`:
   ```dart
   // Shimmer & Skeleton Components
   export 'src/widgets/shimmer/base_shimmer.dart';
   export 'src/widgets/shimmer/skeleton_primitives.dart';
   export 'src/widgets/shimmer/skeleton_cards.dart';
   export 'src/widgets/shimmer/skeleton_lists.dart';
   export 'src/widgets/shimmer/skeleton_screens.dart';
   export 'src/widgets/shimmer/pulse_skeleton.dart';
   ```

3. **Migrate shimmer_effect.dart** (2 hours)
   - Reconcile `animations/widgets/shimmer_effect.dart` with `shimmer/base_shimmer.dart`
   - Merge into single implementation
   - Deprecate old animation version

4. **Update all references** (2 hours)
   - Update ~25 files using shimmer components

**Files to Move**: 6 files
**Files to Update**: ~25 files
**Effort**: 8 hours

---

#### Duplicate #3: Error Widget
**Issue**: Multiple error widget implementations

**Locations:**
- `lib/presentation/widgets/common/error_widget.dart` (11 lines, re-export)
- `lib/presentation/widgets/common/error_widget_updated.dart` (120 lines)
- `lib/presentation/widgets/common/error/error_widget_refactored.dart` (185 lines)
- `packages/hvac_ui_kit/lib/src/widgets/states/hvac_error_state.dart` (exists)

**Resolution:**
1. **Consolidate error system** (3 hours)
   - Use `error/error_widget_refactored.dart` as authoritative version (most complete)
   - Delete `error_widget_updated.dart` (obsolete)
   - Keep modular structure in `error/` folder

2. **Move to UI Kit** (2 hours)
   - Destination: `packages/hvac_ui_kit/lib/src/widgets/states/error/`
   - Files to move:
     - `error_widget_refactored.dart` → `app_error_widget.dart`
     - `error_types.dart`
     - `error_icon.dart` + `error_icon_widget.dart` (merge)
     - `error_actions.dart` + `error_actions_widget.dart` (merge)
     - `error_details.dart`
     - `app_error_widget_refactored.dart` (alternative variant)

3. **Remove i18n dependency** (3 hours)
   - **CRITICAL ISSUE**: Error widget imports `AppLocalizations`
   - **Solution**: Add i18n callback parameter
   ```dart
   class AppErrorWidget extends StatelessWidget {
     final String Function(BuildContext)? titleBuilder;
     final String Function(BuildContext)? messageBuilder;

     // OR: Make all strings required parameters
     final String title;
     final String message;
   ```
   - Update factory methods to accept string parameters
   - Document i18n integration in README

4. **Update UI Kit error state** (1 hour)
   - Replace `hvac_error_state.dart` with new system
   - Add backward compatibility alias

**Files to Move**: 9 files
**Files to Delete**: 2 files
**Files to Update**: ~30 files (error handling is widespread)
**Effort**: 9 hours

---

#### Duplicate #4: Empty State Widget
**Issue**: Multiple empty state implementations

**Locations:**
- `lib/presentation/widgets/common/empty_state_widget.dart` (244 lines)
- `lib/presentation/widgets/common/empty_state/` (modular components)
- `lib/presentation/widgets/common/empty_states/` (alternative implementation)
- `packages/hvac_ui_kit/lib/src/widgets/states/hvac_empty_state.dart`

**Resolution:**
1. **Merge implementations** (2 hours)
   - Compare all three implementations
   - UI Kit version is basic (needs enhancement)
   - `empty_state_widget.dart` is most complete
   - `empty_states/` has best animations

2. **Create unified system** (3 hours)
   - Destination: `packages/hvac_ui_kit/lib/src/widgets/states/empty/`
   - Structure:
     ```
     empty/
       ├── empty_state_widget.dart (main component)
       ├── empty_state_types.dart (enums, configs)
       ├── empty_state_illustration.dart (icon container)
       ├── animated_icons.dart (icon animations)
       ├── compact_empty_state.dart (minimal variant)
       └── states.dart (barrel export)
     ```

3. **Remove domain-specific factories** (1 hour)
   - **ISSUE**: `EmptyStateWidget.noDevices()` contains HVAC logic
   - **Solution**: Keep generic factories, document custom usage
   ```dart
   // Generic (keep in UI Kit):
   EmptyStateWidget.noData()
   EmptyStateWidget.noSearchResults()
   EmptyStateWidget.noNotifications()

   // Domain-specific (remove from UI Kit, add to app):
   EmptyStateWidget.noDevices() → Move to app helpers
   EmptyStateWidget.noSchedules() → Move to app helpers
   ```

4. **Update all references** (2 hours)
   - Update ~18 files using empty states

**Files to Move**: 7 files
**Files to Delete**: 1 file (hvac_empty_state.dart obsolete)
**Files to Update**: ~18 files
**Effort**: 8 hours

---

### 1.2 Critical File Size Violations

#### File #1: web_keyboard_shortcuts.dart (298 lines)
**Current**: `lib/presentation/widgets/common/web_keyboard_shortcuts.dart`
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/keyboard/`

**Refactoring Plan:**
1. **Split into modules** (2 hours)
   - `keyboard_shortcuts.dart` (main widget, ~120 lines)
   - `shortcut_manager.dart` (state management, ~80 lines)
   - `shortcut_types.dart` (types, constants, ~60 lines)
   - `platform_shortcuts.dart` (platform-specific, ~40 lines)

2. **Remove platform dependencies** (1 hour)
   - Use Flutter's foundation.dart for platform detection
   - No web-specific imports in UI Kit

**Effort**: 3 hours

---

#### File #2: web_hover_card.dart (294 lines)
**Current**: `lib/presentation/widgets/common/web_hover_card.dart`
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/cards/`

**Refactoring Plan:**
1. **Extract components** (2 hours)
   - `hover_card.dart` (main, ~100 lines)
   - `hover_icon_button.dart` (button variant, ~80 lines)
   - `hover_effects.dart` (animation logic, ~70 lines)
   - `hover_config.dart` (configuration, ~40 lines)

**Effort**: 2 hours

---

#### File #3: web_responsive_layout.dart (273 lines)
**Current**: `lib/presentation/widgets/common/web_responsive_layout.dart`
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/layout/`

**Refactoring Plan:**
1. **Split layout components** (2.5 hours)
   - `responsive_layout.dart` (~120 lines)
   - `adaptive_scaffold.dart` (~80 lines)
   - `breakpoint_builder.dart` (~70 lines)

**Effort**: 2.5 hours

---

#### File #4: loading_widget.dart (265 lines)
**Current**: `lib/presentation/widgets/common/loading_widget.dart`
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/states/loading/`

**Refactoring Plan:**
1. **Extract loading variants** (2 hours)
   - `loading_widget.dart` (main, ~100 lines)
   - `loading_overlay.dart` (~80 lines)
   - `loading_spinner.dart` (~50 lines)
   - `loading_types.dart` (~35 lines)

**Effort**: 2 hours

---

### Phase 1 Summary
**Total Files to Process**: 29 files
**Total Effort**: 39 hours (revised from 24 hours after detailed analysis)

---

## PHASE 2: FOUNDATION COMPONENTS
**Duration**: 32 hours | **Priority**: HIGH

Foundation components must be moved first as they have no dependencies on other widgets.

### 2.1 Theme & Styling Components

All theme components are already in UI Kit. **No action needed.**

✅ `packages/hvac_ui_kit/lib/src/theme/` (complete)

---

### 2.2 Animation Components

#### Component: Animated Card
**Source**: `lib/presentation/widgets/common/animated_card.dart`
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/cards/animated_card.dart`
**Classes**: `AnimatedCard`, `AnimatedDeviceCard`
**Dependencies**:
- `flutter_animate` ✅ (already in UI Kit pubspec)
- `hvac_ui_kit` theme ✅
- `core/constants/animation_constants.dart` ❌ (needs migration)

**Migration Steps:**
1. Move `animation_constants.dart` to UI Kit first
   - Source: `lib/core/constants/animation_constants.dart`
   - Dest: `packages/hvac_ui_kit/lib/src/animations/animation_constants.dart`
   - Update barrel export in `animations.dart`

2. Update `AnimatedCard` imports
   - Change relative imports to package imports
   - Remove `AnimatedDeviceCard` (domain-specific, keep in app)

3. Update `hvac_ui_kit.dart` barrel export
   ```dart
   export 'src/widgets/cards/animated_card.dart';
   ```

4. Update references in main app (12 files)
   ```dart
   // Before:
   import '../../widgets/common/animated_card.dart';

   // After:
   import 'package:hvac_ui_kit/hvac_ui_kit.dart';
   ```

5. Run tests
   - Verify UI remains identical
   - Check animation performance

6. Delete source file

**Files to Move**: 2 files (animated_card.dart + animation_constants.dart)
**Files to Update**: 12 files
**Effort**: 3 hours
**Priority**: HIGH (widely used)

---

#### Component: Animated Divider
**Source**: `lib/presentation/widgets/common/visual_polish/animated_divider.dart`
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/layout/animated_divider.dart`
**Classes**: `AnimatedDivider`, `AnimatedVerticalDivider`
**Dependencies**:
- `hvac_ui_kit` theme ✅
- No domain logic ✅

**Migration Steps:**
1. Create `packages/hvac_ui_kit/lib/src/widgets/layout/` directory
2. Copy `animated_divider.dart` to destination
3. Update imports (package imports only)
4. Add barrel export: `layout/layout.dart`
5. Export in `hvac_ui_kit.dart`
6. Update 3 references in main app
7. Delete source file

**Files to Move**: 1 file
**Files to Update**: 3 files
**Effort**: 1.5 hours
**Priority**: MEDIUM

---

### 2.3 Utility Components

#### Component: Time Picker Field
**Source**: `lib/presentation/widgets/common/time_picker_field.dart` (99 lines)
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/inputs/time_picker_field.dart`
**Classes**: `TimePickerField`
**Dependencies**:
- Material widgets ✅
- `hvac_ui_kit` theme ✅

**Migration Steps:**
1. Copy to `inputs/` directory in UI Kit
2. Update imports to use package imports
3. Add to `inputs/inputs.dart` barrel export
4. Update 6 references in scheduling screens
5. Delete source file

**Files to Move**: 1 file
**Files to Update**: 6 files
**Effort**: 2 hours
**Priority**: MEDIUM

---

### 2.4 Glassmorphic Components

All glassmorphic components are generic UI elements with no domain logic.

#### Component Group: Glassmorphic Cards
**Source**: `lib/presentation/widgets/common/glassmorphic/`
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/glassmorphic/`
**Files to Move**: 7 files

**Structure:**
```
glassmorphic/
├── base_glassmorphic_container.dart (GlassmorphicConfig, BaseGlassmorphicContainer)
├── glassmorphic_card.dart (GlassmorphicCard, ElevatedGlassmorphicCard)
├── glow_card.dart (GlowCard, StaticGlowCard, NeonGlowCard)
├── gradient_card.dart (GradientCard)
├── neumorphic_card.dart (NeumorphicCard, SoftNeumorphicCard, ConcaveNeumorphicCard)
├── animated_gradient_background.dart (AnimatedGradientBackground)
└── glassmorphic.dart (barrel export)
```

**Dependencies**:
- `hvac_ui_kit` theme ✅
- `dart:ui` for blur effects ✅
- No domain logic ✅

**Migration Steps:**
1. Create `packages/hvac_ui_kit/lib/src/widgets/glassmorphic/` directory (1 hour)
2. Move all 6 implementation files (2 hours)
3. Create barrel export `glassmorphic.dart` (0.5 hours)
4. Update all imports to package imports (1 hour)
5. Add to main `hvac_ui_kit.dart` export (0.5 hours)
   ```dart
   // Glassmorphic Components
   export 'src/widgets/glassmorphic/glassmorphic.dart';
   ```
6. Update references in main app (14 files) (2 hours)
7. Delete source directory and files (0.5 hours)
8. Delete obsolete redirect file `glassmorphic_card.dart` (10 lines) (0.5 hours)
9. Run visual regression tests (1 hour)

**Files to Move**: 6 files
**Files to Delete**: 2 files (glassmorphic_card.dart redirect + example_usage.dart)
**Files to Update**: 14 files
**Effort**: 8 hours
**Priority**: HIGH (widely used for visual polish)

---

### 2.5 Visual Polish Components

#### Component Group: Status & Progress Indicators
**Source Files:**
- `lib/presentation/widgets/common/visual_polish/status_indicator.dart`
- `lib/presentation/widgets/common/visual_polish/premium_progress_indicator.dart`
- `lib/presentation/widgets/common/visual_polish/floating_tooltip.dart`

**Destination**: `packages/hvac_ui_kit/lib/src/widgets/indicators/`

**Classes**:
- `StatusIndicator` (with pulse animation)
- `PremiumProgressIndicator` (gradient progress bar)
- `FloatingTooltip` (animated tooltip)

**Dependencies**:
- `hvac_ui_kit` theme ✅
- `flutter_animate` ✅
- No domain logic ✅

**Migration Steps:**
1. Create `indicators/` directory in UI Kit (0.5 hours)
2. Move 3 files to new directory (1 hour)
3. Create barrel export `indicators/indicators.dart` (0.5 hours)
4. Update package imports (0.5 hours)
5. Export in main `hvac_ui_kit.dart` (0.5 hours)
6. Update 8 references in app (1 hour)
7. Delete source files (0.5 hours)
8. Merge with existing `status_indicator.dart` in UI Kit (1 hour)
   - **NOTE**: Duplicate exists at `packages/hvac_ui_kit/lib/src/widgets/status_indicator.dart`
   - Compare implementations and merge

**Files to Move**: 3 files
**Files to Merge**: 1 file (status_indicator duplicate)
**Files to Update**: 8 files
**Effort**: 5.5 hours
**Priority**: MEDIUM

---

### Phase 2 Summary
**Files to Move**: 20 files
**Files to Delete**: 4 files
**Files to Update**: 43 files
**Total Effort**: 20 hours (adjusted)

---

## PHASE 3: ATOMIC COMPONENTS
**Duration**: 48 hours | **Priority**: HIGH

Atomic components are the building blocks: buttons, inputs, badges, chips, avatars, icons.

### 3.1 Button Components

#### Existing in UI Kit ✅
- `HvacPrimaryButton`
- `HvacOutlineButton`
- `HvacTextButton`

**Status**: Complete. No action needed.

---

#### Missing Components to Create:

##### Component: Icon Button
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/buttons/hvac_icon_button.dart`
**Classes**: `HvacIconButton`
**Description**: Material 3 icon button with hover states, tooltips, badge support
**Reference**: Material Design 3 IconButton specs

**Implementation:**
```dart
class HvacIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool showBadge;
  final String? badgeLabel;
  final HvacIconButtonStyle style; // filled, outlined, standard
  final double size;

  // Implementation with hover effects, accessibility, haptics
}
```

**Features**:
- Three variants: filled, outlined, standard
- Optional badge overlay
- Tooltip integration
- Hover state animations
- 48x48 minimum touch target
- Semantic labels

**Effort**: 4 hours
**Priority**: CRITICAL (used everywhere)

---

##### Component: Floating Action Button
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/buttons/hvac_fab.dart`
**Classes**: `HvacFab`, `HvacExtendedFab`
**Description**: Material 3 FAB with expand/collapse animations

**Implementation:**
```dart
class HvacFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? label; // For extended FAB
  final bool isExtended;
  final Color? backgroundColor;

  // Smooth expand/collapse with spring physics
}
```

**Features**:
- Standard and extended variants
- Smooth expand/collapse animation
- Elevation on hover
- Hero animation support
- Badge integration

**Effort**: 3 hours
**Priority**: HIGH

---

##### Component: Toggle Button Group
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/buttons/hvac_toggle_buttons.dart`
**Classes**: `HvacToggleButtons`
**Description**: Material 3 segmented button group

**Implementation:**
```dart
class HvacToggleButtons extends StatelessWidget {
  final List<String> labels;
  final List<IconData>? icons;
  final int? selectedIndex;
  final void Function(int)? onPressed;
  final bool allowMultiSelect;

  // Single or multi-select toggle group
}
```

**Effort**: 3 hours
**Priority**: MEDIUM

---

### 3.2 Input Components

#### Existing in UI Kit ✅
- `HvacTextField`
- `HvacPasswordField`

---

#### Components to Migrate:

##### Component: Auth Input Field
**Source**: `lib/presentation/widgets/auth/auth_input_field.dart` (190 lines)
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/inputs/enhanced_text_field.dart`
**Classes**: `AuthInputField` → `HvacEnhancedTextField`
**Dependencies**:
- `flutter_animate` ✅
- `responsive_utils.dart` ❌ (needs migration)
- `hvac_ui_kit` theme ✅

**Migration Steps:**
1. Migrate `auth/responsive_utils.dart` to UI Kit first (2 hours)
   - Source: `lib/presentation/widgets/auth/responsive_utils.dart`
   - Dest: `packages/hvac_ui_kit/lib/src/utils/responsive_utils.dart`
   - **NOTE**: May conflict with existing `responsive_utils.dart` - merge implementations

2. Rename `AuthInputField` to `HvacEnhancedTextField` (1 hour)
   - Remove "Auth" prefix (not domain-agnostic)
   - Keep all features: hover states, focus animations, validation

3. Move to UI Kit (1 hour)
4. Update imports (1 hour)
5. Update 8 references in auth screens (2 hours)
6. Delete source file (0.5 hours)

**Files to Move**: 2 files (auth_input_field.dart + responsive_utils.dart)
**Files to Merge**: 1 file (responsive_utils conflict)
**Files to Update**: 8 files
**Effort**: 7.5 hours
**Priority**: HIGH

---

##### Component: Auth Password Field
**Source**: `lib/presentation/widgets/auth/auth_password_field.dart`
**Action**: **DO NOT MOVE**

**Reason**: This is a specialized variant of `HvacPasswordField` with auth-specific validation. Keep in app.

**Recommendation**: Enhance `HvacPasswordField` in UI Kit with:
- Optional strength indicator
- Configurable validation rules
- Show/hide toggle animation

**Effort**: 2 hours (enhancement to existing component)

---

##### Component: Auth Checkbox Section
**Source**: `lib/presentation/widgets/auth/auth_checkbox_section.dart`
**Action**: Extract generic checkbox, keep section in app

**Migration Steps:**
1. Create `HvacCheckbox` in UI Kit (3 hours)
   - Destination: `packages/hvac_ui_kit/lib/src/widgets/inputs/hvac_checkbox.dart`
   - Material 3 checkbox with label, hover states

2. Keep `AuthCheckboxSection` in app (domain-specific: "Remember me", "Terms")

**Effort**: 3 hours

---

##### Component: Password Strength Indicator
**Source**: `lib/presentation/widgets/auth/password_strength_indicator.dart`
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/inputs/password_strength_indicator.dart`
**Classes**: `PasswordStrengthIndicator`
**Dependencies**: Pure UI logic ✅

**Migration Steps:**
1. Move to UI Kit inputs directory (1 hour)
2. Update imports (0.5 hours)
3. Update 2 references (0.5 hours)
4. Delete source (0.5 hours)

**Files to Move**: 1 file
**Files to Update**: 2 files
**Effort**: 2.5 hours
**Priority**: MEDIUM

---

#### Missing Input Components to Create:

##### Component: Dropdown Menu
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/inputs/hvac_dropdown.dart`
**Description**: Material 3 dropdown with search, autocomplete

**Features**:
- Search filtering
- Autocomplete suggestions
- Multi-select support
- Custom item builder
- Loading state
- Error state

**Effort**: 5 hours
**Priority**: HIGH

---

##### Component: Slider
**Existing**: `adaptive_slider.dart` ✅ (already in UI Kit)
**Action**: Enhance with Material 3 design

**Enhancements**:
- Discrete slider with labels
- Range slider support
- Value indicator tooltip
- Track marks

**Effort**: 2 hours

---

##### Component: Switch
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/inputs/hvac_switch.dart`
**Description**: Material 3 switch with label and description

**Features**:
- Smooth toggle animation
- Optional label and description
- Disabled state
- Loading state
- Haptic feedback

**Effort**: 2 hours
**Priority**: HIGH (used in settings)

---

##### Component: Radio Button Group
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/inputs/hvac_radio_group.dart`
**Description**: Material 3 radio button group

**Features**:
- Vertical and horizontal layouts
- Custom tile builder
- Disabled options
- Descriptions for each option

**Effort**: 3 hours
**Priority**: MEDIUM

---

### 3.3 Badge & Chip Components

#### Existing in UI Kit ✅
- `AnimatedBadge` (after Phase 1 merge)
- `TemperatureBadge` (domain-specific, keep in UI Kit? Review.)

---

#### Component to Create: Chip
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/chips/hvac_chip.dart`
**Classes**: `HvacChip`, `HvacFilterChip`, `HvacInputChip`, `HvacChoiceChip`
**Description**: Material 3 chip variants

**Features**:
- Four variants: assist, filter, input, suggestion
- Optional avatar/icon
- Delete button for input chips
- Checkmark for selection
- Disabled state

**Effort**: 5 hours
**Priority**: HIGH

---

### 3.4 Icon Components

#### Component: Notification Badge
**Source**: `lib/presentation/widgets/home/notifications/notification_badge.dart`
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/badges/notification_badge.dart`
**Classes**: `NotificationBadge`
**Dependencies**: Pure UI ✅

**Migration Steps:**
1. Create `badges/` directory in UI Kit (0.5 hours)
2. Move notification_badge.dart (1 hour)
3. Update imports (0.5 hours)
4. Update 4 references (1 hour)
5. Delete source (0.5 hours)

**Files to Move**: 1 file
**Files to Update**: 4 files
**Effort**: 3.5 hours
**Priority**: MEDIUM

---

### Phase 3 Summary
**Files to Move**: 6 files
**Files to Create**: 10 new components
**Files to Update**: 22 files
**Total Effort**: 48.5 hours

---

## PHASE 4: COMPOSITE COMPONENTS
**Duration**: 36 hours | **Priority**: HIGH

Composite components are built from atomic components: cards, lists, tables.

### 4.1 Card Components

#### Existing in UI Kit ✅
- `HvacCard` (basic card)
- Glassmorphic cards (after Phase 2)
- Animated cards (after Phase 2)

---

#### Components to Migrate:

##### Component: Web Hover Card
**Source**: `lib/presentation/widgets/common/web_hover_card.dart` (294 lines)
**Status**: Refactored in Phase 1
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/cards/hover_card/`
**Files**: 4 files (after refactoring)

**Migration**: Already covered in Phase 1.2
**Effort**: Included in Phase 1

---

#### Missing Card Components to Create:

##### Component: Expansion Card
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/cards/hvac_expansion_card.dart`
**Description**: Card with expand/collapse functionality

**Features**:
- Smooth expand/collapse animation
- Optional header actions
- Custom expansion indicator
- Nested expansion support

**Effort**: 3 hours
**Priority**: MEDIUM

---

##### Component: Swipeable Card
**Existing**: `hvac_swipeable_card.dart` ✅ (already in UI Kit)
**Action**: Verify Material 3 compliance

**Effort**: 1 hour (audit only)

---

### 4.2 List Components

#### Missing List Components to Create:

##### Component: List Tile
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/lists/hvac_list_tile.dart`
**Classes**: `HvacListTile`, `HvacSwitchListTile`, `HvacCheckboxListTile`
**Description**: Material 3 list tile variants

**Features**:
- Leading/trailing widgets
- Subtitle support
- Three-line variant
- Switch/checkbox integration
- Divider options
- Hover states

**Effort**: 4 hours
**Priority**: HIGH

---

##### Component: Reorderable List
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/lists/hvac_reorderable_list.dart`
**Description**: Drag-and-drop reorderable list

**Features**:
- Smooth reorder animation
- Haptic feedback on drag
- Custom drag handle
- Disabled items

**Effort**: 4 hours
**Priority**: LOW

---

### 4.3 Data Display Components

#### Components to Migrate:

##### Component: Dashboard Chart Card
**Source**: `lib/presentation/widgets/dashboard/dashboard_chart_card.dart`
**Action**: **DO NOT MOVE** (domain-specific)

**Reason**: This wraps fl_chart with HVAC-specific data. Keep in app.

**Alternative**: Create generic `ChartCard` wrapper in UI Kit
- Destination: `packages/hvac_ui_kit/lib/src/widgets/cards/chart_card.dart`
- Accept `Widget child` for any chart library
- Standard card styling with title, subtitle, actions

**Effort**: 2 hours

---

##### Component: Simple Line/Pie Chart
**Source**:
- `lib/presentation/widgets/dashboard/simple_line_chart.dart`
- `lib/presentation/widgets/dashboard/simple_pie_chart.dart`

**Action**: **DO NOT MOVE** (fl_chart wrappers with HVAC data)

**Keep in app**: These are domain-specific chart configurations.

---

#### Missing Components to Create:

##### Component: Data Table
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/tables/hvac_data_table.dart`
**Description**: Material 3 data table with sorting, pagination

**Features**:
- Column sorting
- Row selection
- Pagination
- Sticky headers
- Responsive (horizontal scroll on mobile)
- Empty state
- Loading state

**Effort**: 8 hours
**Priority**: MEDIUM

---

##### Component: Timeline
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/display/hvac_timeline.dart`
**Description**: Vertical timeline component

**Features**:
- Custom connector styling
- Icon/image support
- Expandable items
- Alternating layout option

**Effort**: 4 hours
**Priority**: LOW

---

### 4.4 Navigation Components

These will be covered in Phase 6, but listing dependencies here.

**Dependencies for Composite Components:**
- App Bar
- Bottom Navigation
- Navigation Drawer
- Tabs

---

### Phase 4 Summary
**Files to Move**: 0 files (web_hover_card covered in Phase 1)
**Files to Create**: 7 new components
**Files to Update**: 0 files
**Total Effort**: 26 hours

---

## PHASE 5: FEEDBACK COMPONENTS
**Duration**: 18 hours | **Priority**: HIGH

Feedback components: snackbars, toasts, dialogs, alerts, banners.

### 5.1 Snackbar Components

#### Components to Migrate:

##### Component: Snackbar System
**Source**: `lib/presentation/widgets/common/snackbar/` (9 files)
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/feedback/snackbar/`
**Files**:
- `app_snackbar.dart` (main API)
- `base_snackbar.dart`
- `success_snackbar.dart`
- `error_snackbar.dart`
- `warning_snackbar.dart`
- `info_snackbar.dart`
- `loading_snackbar.dart`
- `toast_notification.dart`
- `toast_widget.dart`
- `snackbar_types.dart`

**Dependencies**:
- `hvac_ui_kit` theme ✅
- Pure UI logic ✅

**Migration Steps:**
1. Create `feedback/snackbar/` in UI Kit (0.5 hours)
2. Move all 10 files (2 hours)
3. Create barrel export `snackbar/snackbar.dart` (0.5 hours)
4. Update all imports to package imports (1 hour)
5. Export in main `hvac_ui_kit.dart` (0.5 hours)
   ```dart
   // Feedback Components
   export 'src/widgets/feedback/snackbar/snackbar.dart';
   ```
6. Update ~35 references across app (4 hours)
7. Delete source directory (0.5 hours)
8. Run integration tests (1 hour)

**Files to Move**: 10 files
**Files to Update**: ~35 files
**Effort**: 10 hours
**Priority**: CRITICAL (used everywhere)

---

### 5.2 Dialog Components

#### Components to Create:

##### Component: Dialog System
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/feedback/dialogs/`
**Classes**: `HvacDialog`, `HvacAlertDialog`, `HvacConfirmDialog`, `HvacFullscreenDialog`

**Features**:
- Material 3 dialog styling
- Smooth entrance/exit animations
- Barrier dismissible option
- Action buttons (cancel, confirm)
- Custom content builder
- Responsive sizing

**Effort**: 6 hours
**Priority**: HIGH

**Files to Reference (domain-specific, don't migrate):**
- `lib/presentation/widgets/device_management/device_add_dialog.dart`
- `lib/presentation/widgets/device_management/device_edit_dialog.dart`
- `lib/presentation/widgets/device_management/device_remove_dialog.dart`
- `lib/presentation/widgets/qr_scanner/device_details_dialog.dart`
- `lib/presentation/widgets/schedule/schedule_dialogs.dart`

**Migration Strategy**: Extract generic dialog wrapper, keep domain logic in app.

---

##### Component: Bottom Sheet
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/feedback/bottom_sheet/hvac_bottom_sheet.dart`
**Description**: Material 3 bottom sheet (modal and persistent)

**Features**:
- Drag handle
- Snap points
- Smooth drag physics
- Expand/collapse
- Full-screen mode

**Effort**: 5 hours
**Priority**: MEDIUM

---

##### Component: Banner
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/feedback/hvac_banner.dart`
**Description**: Material 3 banner for persistent messaging

**Features**:
- Info, warning, error variants
- Action buttons
- Dismiss button
- Entrance/exit animations

**Effort**: 2 hours
**Priority**: LOW

---

### Phase 5 Summary
**Files to Move**: 10 files
**Files to Create**: 4 new components
**Files to Update**: ~35 files
**Total Effort**: 23 hours

---

## PHASE 6: NAVIGATION COMPONENTS
**Duration**: 12 hours | **Priority**: MEDIUM

Navigation components: app bars, bottom navigation, tabs, drawers.

### 6.1 App Bar Components

#### Components to Create:

##### Component: App Bar
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/navigation/hvac_app_bar.dart`
**Classes**: `HvacAppBar`, `HvacSliverAppBar`
**Description**: Material 3 top app bar variants

**Features**:
- Small, medium, large variants
- Scroll behaviors
- Search integration
- Action buttons
- Leading icon (back, menu)

**Effort**: 4 hours
**Priority**: HIGH

**Reference Files (domain-specific, don't migrate):**
- `lib/presentation/widgets/analytics/analytics_app_bar.dart`
- `lib/presentation/widgets/schedule/schedule_app_bar.dart`
- `lib/presentation/widgets/home/home_app_bar.dart`

**Strategy**: Create generic app bar, keep customizations in app.

---

### 6.2 Bottom Navigation

#### Component to Create:

##### Component: Bottom Navigation Bar
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/navigation/hvac_bottom_nav.dart`
**Description**: Material 3 bottom navigation bar

**Features**:
- Icon + label variants
- Badge support
- Selected indicator
- Smooth transitions
- Haptic feedback

**Effort**: 3 hours
**Priority**: HIGH

---

### 6.3 Tabs

#### Component to Create:

##### Component: Tab Bar
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/navigation/hvac_tabs.dart`
**Classes**: `HvacTabBar`, `HvacTabBarView`
**Description**: Material 3 tabs

**Features**:
- Primary and secondary tabs
- Icon + label support
- Scrollable tabs
- Indicator animation
- Badge support

**Effort**: 3 hours
**Priority**: MEDIUM

**Reference**: Unit detail tabs, schedule tabs

---

### 6.4 Navigation Drawer

#### Component to Create:

##### Component: Navigation Drawer
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/navigation/hvac_drawer.dart`
**Description**: Material 3 navigation drawer

**Features**:
- Standard and modal variants
- Smooth slide animation
- Section headers
- Selected indicator
- Badge support

**Effort**: 3 hours
**Priority**: LOW

---

### Phase 6 Summary
**Files to Move**: 0 files
**Files to Create**: 5 new components
**Files to Update**: ~15 files (updating navigation code)
**Total Effort**: 13 hours

---

## PHASE 7: LAYOUT COMPONENTS
**Duration**: 8 hours | **Priority**: MEDIUM

Layout components: grids, spacers, dividers, responsive wrappers.

### 7.1 Responsive Layout

#### Components Already Migrated ✅
- `web_responsive_layout.dart` (Phase 1)
- `adaptive_layout.dart` (already in UI Kit)

---

### 7.2 Grid & Flex Components

#### Component to Create:

##### Component: Responsive Grid
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/layout/hvac_grid.dart`
**Description**: Responsive grid layout

**Features**:
- Column count by breakpoint
- Auto-fit and auto-fill
- Gap spacing
- Item aspect ratio
- Staggered grid option

**Effort**: 3 hours
**Priority**: MEDIUM

---

### 7.3 Divider Components

#### Component Already Migrated ✅
- `AnimatedDivider` (Phase 2)

**Action**: Verify compliance, no additional work.

---

### 7.4 Spacer Components

#### Component to Create:

##### Component: Responsive Spacer
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/layout/hvac_spacer.dart`
**Description**: Spacer with responsive sizing

**Features**:
- Vertical and horizontal variants
- Breakpoint-specific sizing
- Uses HvacSpacing constants

**Effort**: 1 hour
**Priority**: LOW

---

### Phase 7 Summary
**Files to Move**: 0 files (already migrated)
**Files to Create**: 2 new components
**Files to Update**: 0 files
**Total Effort**: 4 hours

---

## PHASE 8: NEW COMPONENTS (MATERIAL DESIGN 3 COMPLIANCE)
**Duration**: 8 hours | **Priority**: LOW

Components missing from current implementation but required by Material Design 3.

### 8.1 Material 3 Missing Components

#### Component: Badge
**Status**: Partially exists (`AnimatedBadge`, `NotificationBadge`)
**Action**: Create standard `HvacBadge` for Material 3 compliance

**Destination**: `packages/hvac_ui_kit/lib/src/widgets/badges/hvac_badge.dart`
**Features**:
- Small and large variants
- Number badge
- Dot badge
- Custom content

**Effort**: 2 hours

---

#### Component: Carousel
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/display/hvac_carousel.dart`
**Description**: Image/content carousel with indicators

**Features**:
- Auto-play option
- Swipe gestures
- Page indicators
- Smooth transitions

**Effort**: 4 hours

---

#### Component: Segmented Button
**Destination**: `packages/hvac_ui_kit/lib/src/widgets/buttons/hvac_segmented_button.dart`
**Description**: Material 3 segmented button (replaces toggle buttons)

**Features**:
- Single or multi-select
- Icon + label
- Density options

**Effort**: 2 hours

---

### Phase 8 Summary
**Files to Create**: 3 new components
**Total Effort**: 8 hours

---

## DEPENDENCY RESOLUTION ORDER

### Tier 1: Zero Dependencies (Move First)
1. Theme system ✅ (already in UI Kit)
2. Animation constants
3. Glassmorphic components
4. Visual polish components
5. Snackbar system
6. Tooltip system

### Tier 2: Depends on Tier 1
7. Animated card (depends on animation constants)
8. Shimmer/skeleton (depends on theme)
9. Error widgets (depends on theme)
10. Empty state widgets (depends on theme)
11. Loading widgets (depends on theme)

### Tier 3: Depends on Tier 1-2
12. Input components (depends on theme, tooltips)
13. Button components (depends on theme, tooltips, badges)
14. Card components (depends on glassmorphic, animated card)

### Tier 4: Composite (Depends on Tier 1-3)
15. List components (depends on cards, badges)
16. Dialog components (depends on buttons, inputs)
17. Navigation components (depends on badges, buttons)

---

## VALIDATION CHECKLIST

After each phase, verify:

### Code Quality
- [ ] All files <300 lines
- [ ] No hard-coded dimensions (use HvacSpacing, responsive utils)
- [ ] All strings externalized (no hard-coded text in UI Kit)
- [ ] No domain logic in UI Kit components
- [ ] const constructors used where possible
- [ ] Proper documentation comments

### Functionality
- [ ] Visual regression tests pass
- [ ] Animations run at 60fps
- [ ] Accessibility: tap targets ≥48x48dp
- [ ] Accessibility: WCAG AA color contrast
- [ ] Accessibility: Semantics widgets present
- [ ] No broken imports
- [ ] All tests passing

### Architecture
- [ ] No circular dependencies
- [ ] Proper barrel exports
- [ ] Package imports only (no relative imports in UI Kit)
- [ ] No Flutter app imports in UI Kit
- [ ] Dependencies declared in pubspec.yaml

---

## IMPLEMENTATION CHECKLIST

### Phase 1: Duplicates & Critical Fixes (39 hours)
- [ ] 1.1.1: Resolve AnimatedBadge duplicate (4.5h)
- [ ] 1.1.2: Consolidate shimmer system (8h)
- [ ] 1.1.3: Consolidate error widget system (9h)
- [ ] 1.1.4: Consolidate empty state system (8h)
- [ ] 1.2.1: Refactor web_keyboard_shortcuts.dart (3h)
- [ ] 1.2.2: Refactor web_hover_card.dart (2h)
- [ ] 1.2.3: Refactor web_responsive_layout.dart (2.5h)
- [ ] 1.2.4: Refactor loading_widget.dart (2h)

### Phase 2: Foundation Components (20 hours)
- [ ] 2.2.1: Migrate AnimatedCard (3h)
- [ ] 2.2.2: Migrate AnimatedDivider (1.5h)
- [ ] 2.3.1: Migrate TimePickerField (2h)
- [ ] 2.4.1: Migrate glassmorphic components (8h)
- [ ] 2.5.1: Migrate visual polish indicators (5.5h)

### Phase 3: Atomic Components (48.5 hours)
- [ ] 3.1.1: Create HvacIconButton (4h)
- [ ] 3.1.2: Create HvacFab (3h)
- [ ] 3.1.3: Create HvacToggleButtons (3h)
- [ ] 3.2.1: Migrate AuthInputField → HvacEnhancedTextField (7.5h)
- [ ] 3.2.2: Enhance HvacPasswordField (2h)
- [ ] 3.2.3: Create HvacCheckbox (3h)
- [ ] 3.2.4: Migrate PasswordStrengthIndicator (2.5h)
- [ ] 3.2.5: Create HvacDropdown (5h)
- [ ] 3.2.6: Enhance AdaptiveSlider (2h)
- [ ] 3.2.7: Create HvacSwitch (2h)
- [ ] 3.2.8: Create HvacRadioGroup (3h)
- [ ] 3.3.1: Create HvacChip variants (5h)
- [ ] 3.4.1: Migrate NotificationBadge (3.5h)

### Phase 4: Composite Components (26 hours)
- [ ] 4.1.1: Create HvacExpansionCard (3h)
- [ ] 4.1.2: Audit HvacSwipeableCard (1h)
- [ ] 4.2.1: Create HvacListTile variants (4h)
- [ ] 4.2.2: Create HvacReorderableList (4h)
- [ ] 4.3.1: Create ChartCard wrapper (2h)
- [ ] 4.3.2: Create HvacDataTable (8h)
- [ ] 4.3.3: Create HvacTimeline (4h)

### Phase 5: Feedback Components (23 hours)
- [ ] 5.1.1: Migrate snackbar system (10h)
- [ ] 5.2.1: Create dialog system (6h)
- [ ] 5.2.2: Create HvacBottomSheet (5h)
- [ ] 5.2.3: Create HvacBanner (2h)

### Phase 6: Navigation Components (13 hours)
- [ ] 6.1.1: Create HvacAppBar (4h)
- [ ] 6.2.1: Create HvacBottomNav (3h)
- [ ] 6.3.1: Create HvacTabs (3h)
- [ ] 6.4.1: Create HvacDrawer (3h)

### Phase 7: Layout Components (4 hours)
- [ ] 7.2.1: Create HvacGrid (3h)
- [ ] 7.4.1: Create HvacSpacer (1h)

### Phase 8: New Components (8 hours)
- [ ] 8.1.1: Create standard HvacBadge (2h)
- [ ] 8.1.2: Create HvacCarousel (4h)
- [ ] 8.1.3: Create HvacSegmentedButton (2h)

---

## TOTAL SUMMARY

**Files to Move**: 63 files
**Files to Create**: 42 new components
**Files to Delete**: 7 duplicates/obsolete files
**Files to Update**: ~150 files across main app
**Total Effort**: 181.5 hours (~4.5 weeks)

**Final State:**
- `lib/presentation/widgets/common/` → EMPTY (all moved to UI Kit)
- `packages/hvac_ui_kit/lib/src/widgets/` → 105+ components
- 100% Material Design 3 compliance
- Zero files >300 lines
- Zero duplicates
- Complete test coverage

---

## RISK MITIGATION

### Risk 1: Breaking Changes
**Mitigation**:
- Use feature flags for gradual rollout
- Maintain backward compatibility aliases during transition
- Run full regression test suite after each phase

### Risk 2: i18n Dependencies
**Issue**: Error/Empty state widgets contain hard-coded strings
**Mitigation**:
- Make all user-facing strings required parameters
- Document i18n integration pattern in UI Kit README
- Provide example integration code

### Risk 3: Domain Logic Leakage
**Issue**: Some widgets contain HVAC-specific logic
**Mitigation**:
- Audit each component before migration
- Extract generic parts to UI Kit
- Keep domain logic in app as wrapper components

### Risk 4: Import Chaos
**Issue**: Updating 150+ files is error-prone
**Mitigation**:
- Write automated migration script
- Use IDE refactoring tools
- Verify with `dart analyze` after each batch

---

## POST-MIGRATION TASKS

1. **Documentation** (8 hours)
   - Write comprehensive UI Kit README
   - Create Storybook/example app
   - Document all components with code examples
   - Create migration guide for future developers

2. **Testing** (16 hours)
   - Write widget tests for all components
   - Create golden tests for visual regression
   - Integration tests for complex components
   - Performance benchmarks

3. **CI/CD** (4 hours)
   - Set up automated testing for UI Kit package
   - Version control strategy
   - Publish to internal package repository

4. **Team Training** (4 hours)
   - Workshop on using UI Kit
   - Code review guidelines
   - Contribution guidelines

**Total Post-Migration**: 32 hours

---

## GRAND TOTAL: 213.5 HOURS (5.3 weeks)

---

## MATERIAL DESIGN 3 COMPONENT COVERAGE

### ✅ Covered (Existing or Planned)
- [x] App bars (top)
- [x] Badges
- [x] Bottom navigation
- [x] Bottom sheets
- [x] Buttons (filled, outlined, text, icon, FAB)
- [x] Cards
- [x] Checkboxes
- [x] Chips (assist, filter, input, suggestion)
- [x] Dialogs
- [x] Dividers
- [x] Lists
- [x] Progress indicators
- [x] Radio buttons
- [x] Segmented buttons
- [x] Sliders
- [x] Snackbars
- [x] Switches
- [x] Tabs
- [x] Text fields
- [x] Tooltips
- [x] Navigation drawer
- [x] Data tables
- [x] Carousel

### ❌ Not Applicable (HVAC-specific, keep in app)
- [ ] Date pickers (schedule-specific)
- [ ] Time pickers (schedule-specific)
- [ ] Search bars (can be added later if needed)
- [ ] Menus (dropdown menu covers this)

**Coverage**: 24/26 components = 92% Material Design 3 compliance

---

*End of Comprehensive Migration Plan*
