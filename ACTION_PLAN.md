# ACTION PLAN - UI Kit Migration & Enhancement

**Project:** BREEZ Home HVAC Application
**Goal:** Achieve 90%+ Big Tech design system compliance
**Timeline:** 12 weeks (3 months)
**Estimated Effort:** 200-250 hours

---

## EXECUTIVE SUMMARY

### Current State
- **UI Kit Components:** 35 files (15% coverage)
- **Components in Wrong Location:** 78 files in main app
- **Duplicates:** 5 components
- **Material Design 3 Compliance:** 26% ❌
- **Big Tech Standard Compliance:** 42% ❌

### Target State
- **UI Kit Components:** 150+ files (90% coverage)
- **Components in Wrong Location:** 0 files
- **Duplicates:** 0 components
- **Material Design 3 Compliance:** 90%+ ✅
- **Big Tech Standard Compliance:** 85%+ ✅

### Success Criteria
1. All reusable components in UI Kit (zero in main app)
2. Zero duplicate components
3. All Material Design 3 basic components present
4. WCAG AA accessibility compliance
5. Comprehensive documentation and examples

---

## PHASE 1: CRITICAL CLEANUP (Weeks 1-2)

**Goal:** Eliminate duplicates and move critical feedback/loading components
**Effort:** 60-70 hours
**Priority:** CRITICAL

### Week 1: Duplicates & Feedback Components

#### 1.1 Delete Duplicates (Day 1-2) - 4 hours

**Action Items:**
1. Delete `lib/presentation/widgets/common/visual_polish/animated_badge.dart`
   - Already exists in `packages/hvac_ui_kit/lib/src/widgets/animated_badge.dart`
   - Update imports in main app to use UI Kit version
   - Search for all usages: `Grep "AnimatedBadge" lib/`
   - Estimated: 30 files to update

2. Delete `lib/presentation/widgets/common/visual_polish/status_indicator.dart`
   - Already exists in `packages/hvac_ui_kit/lib/src/widgets/status_indicator.dart`
   - Update imports: `Grep "StatusIndicator" lib/`
   - Estimated: 20 files to update

3. Delete `lib/presentation/widgets/auth/responsive_utils.dart`
   - Use `packages/hvac_ui_kit/lib/src/utils/responsive_utils.dart`
   - Update auth widgets to use UI Kit responsive utils
   - Estimated: 8 files to update

4. Merge `lib/presentation/widgets/common/visual_polish/premium_progress_indicator.dart` into UI Kit
   - Review differences with `packages/hvac_ui_kit/lib/src/widgets/progress_indicator.dart`
   - Keep best features from both versions
   - Delete main app version

**Deliverables:**
- [ ] Zero duplicate components
- [ ] All imports updated
- [ ] Tests passing
- [ ] Commit: `chore: Remove duplicate components, use UI Kit versions`

---

#### 1.2 Move Snackbar System (Day 2-3) - 8 hours

**Source:** `lib/presentation/widgets/common/snackbar/` (10 files)
**Destination:** `packages/hvac_ui_kit/lib/src/widgets/feedback/snackbar/`

**Action Items:**
1. Create feedback category:
   ```bash
   mkdir -p packages/hvac_ui_kit/lib/src/widgets/feedback/snackbar
   ```

2. Move files:
   - `app_snackbar.dart` → `hvac_snackbar.dart` (rename for consistency)
   - `base_snackbar.dart`
   - `success_snackbar.dart`
   - `error_snackbar.dart`
   - `warning_snackbar.dart`
   - `info_snackbar.dart`
   - `loading_snackbar.dart`
   - `toast_notification.dart`
   - `toast_widget.dart`
   - `snackbar_types.dart`

3. Update imports:
   - Replace localization (AppLocalizations) with string parameters
   - Replace haptic service dependency with optional callback
   - Update all imports in main app

4. Create export file:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/feedback/feedback.dart
   export 'snackbar/hvac_snackbar.dart';
   ```

5. Update main export:
   ```dart
   // packages/hvac_ui_kit/lib/hvac_ui_kit.dart
   export 'src/widgets/feedback/feedback.dart';
   ```

**Testing:**
- [ ] Test all snackbar variants (success, error, warning, info, loading)
- [ ] Test toast notifications
- [ ] Verify haptic feedback works with callback approach
- [ ] Test on mobile, tablet, desktop breakpoints

**Deliverables:**
- [ ] Snackbar system fully in UI Kit
- [ ] Zero dependencies on main app (except localization strings passed as params)
- [ ] All usages updated (~50 files)
- [ ] Tests passing
- [ ] Commit: `feat(ui-kit): Add comprehensive snackbar/toast system`

---

#### 1.3 Move Error Widget System (Day 3-4) - 8 hours

**Source:** `lib/presentation/widgets/common/error/` (10 files)
**Destination:** `packages/hvac_ui_kit/lib/src/widgets/states/error/`

**Action Items:**
1. Create error subdirectory:
   ```bash
   mkdir -p packages/hvac_ui_kit/lib/src/widgets/states/error
   ```

2. Consolidate error widgets (3 versions exist):
   - Review `error_widget_refactored.dart`, `error_widget_updated.dart`, `app_error_widget_refactored.dart`
   - Keep BEST version (error_widget_refactored.dart looks most complete)
   - Rename to `hvac_error_widget.dart`

3. Move supporting files:
   - `error_types.dart`
   - `error_icon.dart` (merge error_icon.dart + error_icon_widget.dart)
   - `error_actions.dart` (merge error_actions.dart + error_actions_widget.dart)
   - `error_details.dart`

4. Update factory methods to accept string params instead of localization:
   ```dart
   factory HvacErrorWidget.network({
     required String title,
     required String message,
     VoidCallback? onRetry,
   })
   ```

5. Update existing `hvac_error_state.dart` to use new comprehensive version

**Testing:**
- [ ] Test all error types (network, server, permission, not found, general)
- [ ] Test retry functionality
- [ ] Test technical details expansion
- [ ] Test error code display
- [ ] Test additional actions

**Deliverables:**
- [ ] Single, comprehensive error widget in UI Kit
- [ ] Delete 2 redundant error widget versions
- [ ] All usages updated (~30 files)
- [ ] Tests passing
- [ ] Commit: `feat(ui-kit): Add comprehensive error state system`

---

### Week 2: Empty States & Loading Components

#### 2.1 Move Empty State System (Day 5-6) - 6 hours

**Source:** `lib/presentation/widgets/common/empty_state/` + `empty_states/` (8 files)
**Destination:** `packages/hvac_ui_kit/lib/src/widgets/states/empty/`

**Action Items:**
1. Create empty subdirectory:
   ```bash
   mkdir -p packages/hvac_ui_kit/lib/src/widgets/states/empty
   ```

2. Consolidate and move:
   - `base_empty_state.dart` → core component
   - `empty_state_widget.dart` → merge with base
   - `compact_empty_state.dart` → variant
   - `empty_state_illustration.dart`
   - `empty_state_types.dart`
   - `animated_icons.dart` → move to animations/widgets/

3. Rename for consistency:
   - `base_empty_state.dart` → `hvac_empty_state.dart`

4. Update existing `hvac_empty_state.dart` or replace entirely

**Testing:**
- [ ] Test all empty state variants
- [ ] Test with different icon types
- [ ] Test action button functionality
- [ ] Test animations

**Deliverables:**
- [ ] Empty state system in UI Kit
- [ ] Animated icons in animations folder
- [ ] All usages updated (~25 files)
- [ ] Commit: `feat(ui-kit): Add comprehensive empty state system`

---

#### 2.2 Move Shimmer/Skeleton System (Day 6-7) - 8 hours

**Source:** `lib/presentation/widgets/common/shimmer/` (6 files)
**Destination:** `packages/hvac_ui_kit/lib/src/widgets/states/loading/`

**Action Items:**
1. Create loading subdirectory:
   ```bash
   mkdir -p packages/hvac_ui_kit/lib/src/widgets/states/loading
   ```

2. Move shimmer system:
   - `base_shimmer.dart` → `hvac_shimmer.dart`
   - `skeleton_primitives.dart` → keep (core components)
   - `skeleton_cards.dart` → review (may be domain-specific)
   - `skeleton_lists.dart` → keep
   - `skeleton_screens.dart` → review
   - `pulse_skeleton.dart` → keep

3. Consolidate with existing:
   - Merge with UI Kit `hvac_skeleton_loader.dart`
   - Keep best implementation

4. Move `loading_widget.dart` (266 lines):
   - Rename to `hvac_loading_widget.dart`
   - Place in loading subdirectory

5. Domain-specific skeletons:
   - `DeviceCardSkeleton`, `ChartSkeleton`, `AnalyticsCardSkeleton` → KEEP in main app
   - These should COMPOSE from UI Kit primitives

**Testing:**
- [ ] Test shimmer effect
- [ ] Test all skeleton primitives
- [ ] Test pulse animation
- [ ] Test loading widget variants (circular, linear, shimmer, dots, pulse)
- [ ] Test LoadingOverlay

**Deliverables:**
- [ ] Comprehensive loading/shimmer system in UI Kit
- [ ] Domain-specific skeletons remain in main app but use UI Kit primitives
- [ ] All usages updated (~40 files)
- [ ] Commit: `feat(ui-kit): Add comprehensive loading/shimmer system`

---

#### 2.3 Move Web Skeleton Loader (Day 7) - 2 hours

**Source:** `lib/presentation/widgets/common/web_skeleton_loader.dart`
**Destination:** Merge with UI Kit skeleton system

**Action Items:**
1. Review for platform-specific features
2. Merge web optimizations into main skeleton loader
3. Delete original file
4. Update imports

**Deliverables:**
- [ ] Web skeleton features integrated into UI Kit
- [ ] File deleted from main app
- [ ] Commit: `refactor: Merge web skeleton loader into UI Kit`

---

#### Phase 1 Checkpoint (End of Week 2)

**Deliverables:**
- [x] Zero duplicate components ✅
- [x] Snackbar/Toast system in UI Kit ✅
- [x] Error state system in UI Kit ✅
- [x] Empty state system in UI Kit ✅
- [x] Loading/Shimmer system in UI Kit ✅
- [x] ~150 files updated with new imports ✅
- [x] All tests passing ✅

**Metrics:**
- Components moved: ~40 files
- Duplicates eliminated: 5
- UI Kit size: 35 → 75 files (+114%)
- Main app common/ folder: 90 → 50 files (-44%)

---

## PHASE 2: WEB & GLASSMORPHIC COMPONENTS (Weeks 3-4)

**Goal:** Move web-specific and glassmorphic components
**Effort:** 50-60 hours
**Priority:** HIGH

### Week 3: Web Components

#### 3.1 Move Web Responsive Layout (Day 8-9) - 8 hours

**Source:** `lib/presentation/widgets/common/web_responsive_layout.dart` (242+ lines)
**Destination:** Split into multiple files in UI Kit

**Action Items:**
1. Extract WebBreakpoints utility:
   ```bash
   # Create file
   packages/hvac_ui_kit/lib/src/utils/web_breakpoints.dart
   ```
   - Move WebBreakpoints class
   - Update responsive_utils.dart to use web breakpoints

2. Create layout category:
   ```bash
   mkdir -p packages/hvac_ui_kit/lib/src/widgets/layout
   ```

3. Split components:
   - `WebResponsiveScaffold` → `hvac_responsive_scaffold.dart`
   - `WebResponsiveGrid` → `hvac_responsive_grid.dart`
   - `WebResponsiveContainer` → `hvac_responsive_container.dart`
   - `WebKeyboardNavigator` → move to navigation/ category

4. Typography handling:
   - `WebResponsiveText` → add to typography.dart in theme

5. Create exports:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/layout/layout.dart
   export 'hvac_responsive_scaffold.dart';
   export 'hvac_responsive_grid.dart';
   export 'hvac_responsive_container.dart';
   ```

**Testing:**
- [ ] Test responsive breakpoints (mobile, tablet, desktop, widescreen)
- [ ] Test scaffold with navigation rail
- [ ] Test grid layouts
- [ ] Test container max-width constraints

**Deliverables:**
- [ ] Web layout components in UI Kit
- [ ] WebBreakpoints in utils
- [ ] All usages updated
- [ ] Commit: `feat(ui-kit): Add web responsive layout components`

---

#### 3.2 Move Web Hover & Tooltip Components (Day 9-10) - 8 hours

**Source:**
- `lib/presentation/widgets/common/web_hover_card.dart` (179+ lines)
- `lib/presentation/widgets/common/tooltip/` (4 files)

**Destination:**
- Cards: `packages/hvac_ui_kit/lib/src/widgets/cards/`
- Overlays: `packages/hvac_ui_kit/lib/src/widgets/overlays/`

**Action Items:**
1. Move hover card:
   - `web_hover_card.dart` → `cards/hvac_hover_card.dart`
   - `WebHoverIconButton` → `buttons/hvac_hover_icon_button.dart`

2. Create overlays category:
   ```bash
   mkdir -p packages/hvac_ui_kit/lib/src/widgets/overlays
   ```

3. Move tooltip system:
   - `web_tooltip_refactored.dart` → `overlays/hvac_tooltip.dart`
   - `tooltip_overlay.dart` → `overlays/tooltip_overlay.dart`
   - `tooltip_controller.dart` → `overlays/tooltip_controller.dart`
   - `tooltip_types.dart` → `overlays/tooltip_types.dart`
   - `TooltipIconButton` → keep in same file
   - `RichTooltip` → keep in same file

4. Update for platform agnostic:
   - Remove "Web" prefix (works on all platforms)
   - Keep hover effects (gracefully degrade on mobile)

**Testing:**
- [ ] Test hover card on web (hover animations)
- [ ] Test hover card on mobile (no hover, direct tap)
- [ ] Test tooltip positioning
- [ ] Test rich tooltip with icons/actions
- [ ] Test tooltip keyboard shortcuts (Esc to close)

**Deliverables:**
- [ ] Hover card in cards/
- [ ] Tooltip system in overlays/
- [ ] All usages updated
- [ ] Commit: `feat(ui-kit): Add hover card and comprehensive tooltip system`

---

#### 3.3 Move Web Keyboard Shortcuts (Day 10-11) - 6 hours

**Source:** `lib/presentation/widgets/common/web_keyboard_shortcuts.dart` (279+ lines)
**Destination:** Split into utils and accessibility

**Action Items:**
1. Create accessibility category:
   ```bash
   mkdir -p packages/hvac_ui_kit/lib/src/widgets/accessibility
   ```

2. Split components:
   - `WebKeyboardShortcuts` → `accessibility/hvac_keyboard_shortcuts.dart`
   - `WebFocusableContainer` → `accessibility/hvac_focusable_container.dart`
   - `WebArrowKeyScrolling` → `accessibility/hvac_arrow_key_scrolling.dart`
   - `WebTabTraversalGroup` → `accessibility/hvac_tab_traversal.dart`

3. Create exports:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/accessibility/accessibility.dart
   export 'hvac_keyboard_shortcuts.dart';
   export 'hvac_focusable_container.dart';
   export 'hvac_arrow_key_scrolling.dart';
   export 'hvac_tab_traversal.dart';
   ```

**Testing:**
- [ ] Test keyboard shortcuts (Esc, Enter, Arrow keys, Tab)
- [ ] Test focus management
- [ ] Test arrow key scrolling
- [ ] Test tab traversal order
- [ ] Test with screen reader (NVDA/VoiceOver)

**Deliverables:**
- [ ] Keyboard navigation in accessibility/
- [ ] WCAG AA keyboard support
- [ ] All usages updated
- [ ] Commit: `feat(ui-kit): Add comprehensive keyboard navigation and accessibility`

---

### Week 4: Glassmorphic & Visual Polish

#### 4.1 Move Glassmorphic Card System (Day 12-13) - 10 hours

**Source:** `lib/presentation/widgets/common/glassmorphic/` (8 files)
**Destination:** `packages/hvac_ui_kit/lib/src/widgets/cards/`

**CRITICAL:** UI Kit already has glassmorphism.dart in theme! These cards should use it.

**Action Items:**
1. Review existing glassmorphism theme:
   - Check `packages/hvac_ui_kit/lib/src/theme/glassmorphism.dart`
   - Ensure it has all utilities needed

2. Move card variants to cards/:
   - `glassmorphic_card.dart` → `cards/glassmorphic_card.dart`
   - `glow_card.dart` → `cards/glow_card.dart`
   - `gradient_card.dart` → `cards/gradient_card.dart`
   - `neumorphic_card.dart` → `cards/neumorphic_card.dart`

3. Move base components:
   - `base_glassmorphic_container.dart` → review if needed (may be redundant with theme)

4. Move background component:
   - `animated_gradient_background.dart` → `widgets/misc/hvac_animated_gradient_background.dart`

5. Delete example:
   - `example_usage.dart` → delete (or move to examples/ folder)

6. Update cards.dart export:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/cards/cards.dart
   export 'hvac_card.dart';
   export 'glassmorphic_card.dart';
   export 'glow_card.dart';
   export 'gradient_card.dart';
   export 'neumorphic_card.dart';
   export 'hvac_hover_card.dart'; // from previous step
   export 'hvac_swipeable_card.dart'; // move existing
   ```

7. Consolidate glassmorphic:
   - Delete `lib/presentation/widgets/common/glassmorphic_card.dart` (redundant)

**Testing:**
- [ ] Test all card variants
- [ ] Test glassmorphic blur effects
- [ ] Test glow animations
- [ ] Test gradient backgrounds
- [ ] Test neumorphic shadows
- [ ] Test on mobile, tablet, desktop

**Deliverables:**
- [ ] All card variants in UI Kit cards/
- [ ] Zero glassmorphic files in main app
- [ ] All usages updated (~30 files)
- [ ] Commit: `feat(ui-kit): Add comprehensive card system with glassmorphic variants`

---

#### 4.2 Move Visual Polish Components (Day 13-14) - 6 hours

**Source:** `lib/presentation/widgets/common/visual_polish/` (6 files, minus duplicates)
**Destination:** Various UI Kit locations

**Action Items:**
1. Move divider:
   - `animated_divider.dart` → `widgets/layout/hvac_divider.dart`
   - `AnimatedVerticalDivider` → same file

2. Move tooltip:
   - `floating_tooltip.dart` → merge with tooltip system in overlays/

3. Delete example:
   - `example_usage.dart` → delete

4. Already moved:
   - ~~`animated_badge.dart`~~ (duplicate - deleted in Phase 1)
   - ~~`status_indicator.dart`~~ (duplicate - deleted in Phase 1)
   - ~~`premium_progress_indicator.dart`~~ (merged in Phase 1)

**Testing:**
- [ ] Test animated dividers (horizontal and vertical)
- [ ] Test divider with gradient
- [ ] Test floating tooltip

**Deliverables:**
- [ ] Visual polish components integrated into UI Kit
- [ ] visual_polish/ folder deleted from main app
- [ ] Commit: `refactor: Integrate visual polish components into UI Kit`

---

#### Phase 2 Checkpoint (End of Week 4)

**Deliverables:**
- [x] Web responsive layout in UI Kit ✅
- [x] Web hover & tooltip in UI Kit ✅
- [x] Web keyboard navigation in UI Kit ✅
- [x] Glassmorphic card system in UI Kit ✅
- [x] Visual polish components integrated ✅
- [x] ~80 files updated ✅

**Metrics:**
- Components moved: ~30 files
- UI Kit size: 75 → 105 files (+40%)
- Main app common/ folder: 50 → 20 files (-60%)
- Material Design 3 Compliance: 26% → 45%

---

## PHASE 3: FORMS & ANIMATIONS (Weeks 5-6)

**Goal:** Move form components and animated card
**Effort:** 40-50 hours
**Priority:** HIGH

### Week 5: Form Components

#### 5.1 Move Time Picker & Auth Inputs (Day 15-16) - 8 hours

**Source:**
- `lib/presentation/widgets/common/time_picker_field.dart` (100 lines)
- `lib/presentation/widgets/auth/auth_input_field.dart`
- `lib/presentation/widgets/auth/auth_checkbox_section.dart`

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/inputs/`

**Action Items:**
1. Move time picker:
   - `time_picker_field.dart` → `inputs/hvac_time_picker.dart`
   - Standardize with other input components

2. Check for duplicates:
   - Compare `auth_password_field.dart` with UI Kit `hvac_password_field.dart`
   - If duplicate, delete auth version
   - If different, merge features

3. Move auth inputs:
   - `auth_input_field.dart` → review if just styled wrapper of hvac_text_field
   - If unique features, rename to `hvac_labeled_text_field.dart`
   - `auth_checkbox_section.dart` → `inputs/hvac_checkbox_section.dart`

4. Update inputs.dart export

**Testing:**
- [ ] Test time picker (12h/24h formats)
- [ ] Test time picker theming
- [ ] Test auth input field styling
- [ ] Test checkbox section

**Deliverables:**
- [ ] Time picker in UI Kit
- [ ] Auth inputs consolidated/moved
- [ ] All usages updated (~15 files)
- [ ] Commit: `feat(ui-kit): Add time picker and checkbox section`

---

#### 5.2 Move Password Strength Indicator (Day 16-17) - 6 hours

**Source:** `lib/presentation/widgets/auth/password_strength_indicator.dart` (186 lines)
**Destination:** `packages/hvac_ui_kit/lib/src/widgets/inputs/`

**DEPENDENCY:** Uses `Validators.calculatePasswordStrength` from main app

**Action Items:**
1. Move validator to UI Kit:
   ```bash
   # Create validators utility
   packages/hvac_ui_kit/lib/src/utils/validators.dart
   ```
   - Extract password strength calculation
   - Add email validator
   - Add phone validator
   - Add URL validator
   - Add credit card validator (if needed)

2. Move password strength indicator:
   - `password_strength_indicator.dart` → `inputs/hvac_password_strength_indicator.dart`
   - Update to use UI Kit validators
   - Remove dependency on auth responsive_utils (use UI Kit responsive utils)

3. Integration with password field:
   - Consider adding optional strength indicator to hvac_password_field.dart
   - Or keep as separate widget (more flexible)

**Testing:**
- [ ] Test all password strength levels (weak, medium, strong, very strong)
- [ ] Test requirements display
- [ ] Test animations
- [ ] Test responsive sizing

**Deliverables:**
- [ ] Validators in UI Kit utils
- [ ] Password strength indicator in UI Kit
- [ ] All usages updated (~5 files)
- [ ] Commit: `feat(ui-kit): Add validators and password strength indicator`

---

#### 5.3 Add BASIC Input Components (Day 17-19) - 14 hours

**CRITICAL:** These are MISSING from UI Kit but are Material Design 3 CORE components

**Action Items:**
1. Add Checkbox (4 hours):
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/inputs/hvac_checkbox.dart
   class HvacCheckbox extends StatelessWidget {
     final bool value;
     final ValueChanged<bool> onChanged;
     final String? label;
     final bool tristate;
     // ... Material Design 3 checkbox
   }
   ```

2. Add Radio Button (3 hours):
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/inputs/hvac_radio.dart
   class HvacRadio<T> extends StatelessWidget {
     final T value;
     final T groupValue;
     final ValueChanged<T> onChanged;
     final String? label;
     // ... Material Design 3 radio
   }

   class HvacRadioGroup<T> extends StatelessWidget {
     final List<T> options;
     final T value;
     final ValueChanged<T> onChanged;
     // ... Radio group wrapper
   }
   ```

3. Add Switch (3 hours):
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/inputs/hvac_switch.dart
   class HvacSwitch extends StatelessWidget {
     final bool value;
     final ValueChanged<bool> onChanged;
     final String? label;
     final bool adaptive; // iOS style on iOS
     // ... Material Design 3 switch
   }
   ```

4. Add Dropdown (4 hours):
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/inputs/hvac_dropdown.dart
   class HvacDropdown<T> extends StatelessWidget {
     final T value;
     final List<DropdownMenuItem<T>> items;
     final ValueChanged<T?> onChanged;
     final String? label;
     final String? hint;
     // ... Material Design 3 dropdown
   }
   ```

**Testing:**
- [ ] Test checkbox (checked, unchecked, tristate, disabled)
- [ ] Test radio button (selected, unselected, disabled)
- [ ] Test radio group (single selection)
- [ ] Test switch (on, off, disabled, iOS adaptive)
- [ ] Test dropdown (open, select, close, search)
- [ ] Test all with keyboard navigation
- [ ] Test all with screen reader

**Deliverables:**
- [ ] 4 new input components
- [ ] Unit tests for each
- [ ] Example usage
- [ ] Commit: `feat(ui-kit): Add checkbox, radio, switch, and dropdown components`

---

### Week 6: Animations & Utilities

#### 6.1 Move Animated Card (Day 20) - 4 hours

**Source:** `lib/presentation/widgets/common/animated_card.dart` (91 lines)
**Destination:** `packages/hvac_ui_kit/lib/src/widgets/cards/`

**Action Items:**
1. Review AnimatedCard:
   - Generic animated card wrapper with fade + slide
   - Uses UI Kit theme (HvacTheme.roundedCard())
   - Move to cards/

2. Review AnimatedDeviceCard:
   - Uses HvacTheme.deviceCard(isSelected: isSelected)
   - This is generic (isSelected is common pattern)
   - Move to cards/ as well

3. Update animation constants dependency:
   - If uses main app AnimationConstants, move to UI Kit or parameterize

**Testing:**
- [ ] Test animated card entrance
- [ ] Test delay parameter
- [ ] Test tap functionality
- [ ] Test AnimatedDeviceCard selected state

**Deliverables:**
- [ ] AnimatedCard in UI Kit
- [ ] All usages updated (~20 files)
- [ ] Commit: `feat(ui-kit): Add animated card wrapper`

---

#### 6.2 Move Ripple Painter & Performance Monitor (Day 21) - 4 hours

**Source:**
- `lib/presentation/widgets/utils/performance_monitor.dart`
- `lib/presentation/widgets/utils/ripple_painter.dart`

**Destination:**
- Performance: `packages/hvac_ui_kit/lib/src/utils/`
- Ripple: `packages/hvac_ui_kit/lib/src/animations/widgets/`

**Action Items:**
1. Move performance monitor:
   - `performance_monitor.dart` → `utils/performance_monitor.dart`
   - Merge with existing performance_utils.dart or keep separate

2. Move ripple painter:
   - `ripple_painter.dart` → `animations/widgets/hvac_ripple_painter.dart`
   - This is a Material Design ripple effect (generic)

**Testing:**
- [ ] Test performance monitor overlay
- [ ] Test ripple painter animation

**Deliverables:**
- [ ] Performance monitor in UI Kit utils
- [ ] Ripple painter in UI Kit animations
- [ ] Commit: `feat(ui-kit): Add performance monitor and ripple painter`

---

#### 6.3 Cleanup Main App Common Folder (Day 22-23) - 8 hours

**Goal:** Delete empty folders and update all imports

**Action Items:**
1. Delete empty folders:
   ```bash
   # These should be empty now
   rm -rf lib/presentation/widgets/common/error
   rm -rf lib/presentation/widgets/common/empty_state
   rm -rf lib/presentation/widgets/common/empty_states
   rm -rf lib/presentation/widgets/common/shimmer
   rm -rf lib/presentation/widgets/common/snackbar
   rm -rf lib/presentation/widgets/common/tooltip
   rm -rf lib/presentation/widgets/common/visual_polish
   rm -rf lib/presentation/widgets/common/glassmorphic
   ```

2. Review remaining common/ files:
   - Should ONLY have app-specific common widgets
   - Check each file for potential UI Kit candidates

3. Update import analyzer:
   ```bash
   # Run to find any remaining old imports
   grep -r "presentation/widgets/common/error" lib/
   grep -r "presentation/widgets/common/snackbar" lib/
   # ... etc
   ```

4. Run tests:
   ```bash
   flutter test
   flutter analyze
   ```

**Deliverables:**
- [ ] common/ folder cleaned up (only app-specific widgets)
- [ ] Zero old imports
- [ ] All tests passing
- [ ] Commit: `refactor: Clean up common widgets folder after UI Kit migration`

---

#### Phase 3 Checkpoint (End of Week 6)

**Deliverables:**
- [x] Time picker and auth inputs in UI Kit ✅
- [x] Password strength indicator in UI Kit ✅
- [x] Validators utility in UI Kit ✅
- [x] Checkbox, Radio, Switch, Dropdown added ✅
- [x] Animated card in UI Kit ✅
- [x] Performance monitor in UI Kit ✅
- [x] Main app common/ folder cleaned ✅

**Metrics:**
- Components moved: ~20 files
- Components added: 4 new basic inputs
- UI Kit size: 105 → 130 files (+24%)
- Main app common/ folder: 20 → 5 files (-75%)
- Material Design 3 Compliance: 45% → 60%

---

## PHASE 4: NAVIGATION & OVERLAYS (Weeks 7-8)

**Goal:** Add missing Material Design 3 navigation and overlay components
**Effort:** 50-60 hours
**Priority:** HIGH

### Week 7: Navigation Components

#### 7.1 Add Bottom Navigation Bar (Day 24-25) - 8 hours

**NEW COMPONENT**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/navigation/`

**Action Items:**
1. Create navigation category:
   ```bash
   mkdir -p packages/hvac_ui_kit/lib/src/widgets/navigation
   ```

2. Implement bottom navigation:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/navigation/hvac_bottom_nav.dart
   class HvacBottomNavigation extends StatelessWidget {
     final int currentIndex;
     final ValueChanged<int> onTap;
     final List<HvacBottomNavItem> items;
     final bool showLabels;
     // ... Material Design 3 bottom nav
   }
   ```

3. Features:
   - Material Design 3 styling
   - Active/inactive states
   - Badge support (show unread count)
   - Adaptive icons
   - Smooth transitions
   - Haptic feedback

**Testing:**
- [ ] Test navigation between tabs
- [ ] Test active state styling
- [ ] Test badges
- [ ] Test with 3, 4, 5 items
- [ ] Test responsive sizing

**Deliverables:**
- [ ] Bottom navigation component
- [ ] Example usage
- [ ] Unit tests
- [ ] Commit: `feat(ui-kit): Add bottom navigation bar`

---

#### 7.2 Add App Bar (Day 25-26) - 8 hours

**NEW COMPONENT**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/navigation/`

**Action Items:**
1. Implement app bar:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/navigation/hvac_app_bar.dart
   class HvacAppBar extends StatelessWidget implements PreferredSizeWidget {
     final String title;
     final List<Widget>? actions;
     final Widget? leading;
     final bool centerTitle;
     final Color? backgroundColor;
     // ... Material Design 3 app bar
   }
   ```

2. Variants:
   - Standard app bar
   - Large app bar (with search)
   - Medium app bar
   - Small app bar

**Testing:**
- [ ] Test with title only
- [ ] Test with actions
- [ ] Test with leading widget
- [ ] Test center vs left title
- [ ] Test scroll behavior (collapse on scroll)

**Deliverables:**
- [ ] App bar component with variants
- [ ] Example usage
- [ ] Commit: `feat(ui-kit): Add app bar component`

---

#### 7.3 Add Tabs (Day 26-27) - 8 hours

**NEW COMPONENT**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/navigation/`

**Action Items:**
1. Implement tabs:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/navigation/hvac_tabs.dart
   class HvacTabBar extends StatelessWidget {
     final TabController controller;
     final List<Widget> tabs;
     final bool isScrollable;
     // ... Material Design 3 tabs
   }

   class HvacTabBarView extends StatelessWidget {
     final TabController controller;
     final List<Widget> children;
     // ... Tab view
   }
   ```

2. Features:
   - Fixed tabs (<=3 tabs)
   - Scrollable tabs (>3 tabs)
   - Primary/secondary variants
   - Icons + labels
   - Badge support

**Testing:**
- [ ] Test tab switching
- [ ] Test scrollable tabs
- [ ] Test with icons
- [ ] Test with badges
- [ ] Test swipe gesture

**Deliverables:**
- [ ] Tab components
- [ ] Example usage
- [ ] Commit: `feat(ui-kit): Add tab components`

---

#### 7.4 Add Navigation Drawer & Rail (Day 27-28) - 10 hours

**NEW COMPONENTS**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/navigation/`

**Action Items:**
1. Implement navigation drawer:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/navigation/hvac_drawer.dart
   class HvacDrawer extends StatelessWidget {
     final Widget? header;
     final List<HvacDrawerItem> items;
     final int selectedIndex;
     final ValueChanged<int> onItemTap;
     // ... Material Design 3 drawer
   }
   ```

2. Implement navigation rail (for tablet/desktop):
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/navigation/hvac_nav_rail.dart
   class HvacNavigationRail extends StatelessWidget {
     final int selectedIndex;
     final ValueChanged<int> onDestinationSelected;
     final List<NavigationRailDestination> destinations;
     final bool extended;
     // ... Material Design 3 navigation rail
   }
   ```

3. Features:
   - Drawer: collapsible, overlay, with header
   - Rail: compact, extended, with labels

**Testing:**
- [ ] Test drawer open/close
- [ ] Test drawer item selection
- [ ] Test rail compact mode
- [ ] Test rail extended mode
- [ ] Test rail on tablet/desktop breakpoints

**Deliverables:**
- [ ] Drawer component
- [ ] Navigation rail component
- [ ] Example usage
- [ ] Commit: `feat(ui-kit): Add navigation drawer and rail`

---

### Week 8: Overlay Components

#### 8.1 Add Dialog/Modal (Day 29-30) - 10 hours

**NEW COMPONENT** - CRITICAL for Material Design 3

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/overlays/`

**Action Items:**
1. Implement dialog:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/overlays/hvac_dialog.dart
   class HvacDialog extends StatelessWidget {
     final String? title;
     final Widget? content;
     final List<Widget>? actions;
     final bool dismissible;
     // ... Material Design 3 dialog
   }
   ```

2. Variants:
   - Alert dialog
   - Confirmation dialog
   - Full-screen dialog
   - Custom dialog

3. Helper methods:
   ```dart
   static Future<T?> show<T>(
     BuildContext context, {
     required Widget child,
   })

   static Future<bool?> showConfirmation(
     BuildContext context, {
     required String title,
     required String message,
   })
   ```

**Testing:**
- [ ] Test dialog show/dismiss
- [ ] Test dismissible vs non-dismissible
- [ ] Test dialog actions
- [ ] Test full-screen dialog
- [ ] Test with keyboard (Esc to close)

**Deliverables:**
- [ ] Dialog component with variants
- [ ] Helper methods
- [ ] Example usage
- [ ] Commit: `feat(ui-kit): Add dialog/modal component`

---

#### 8.2 Add Bottom Sheet (Day 30-31) - 8 hours

**NEW COMPONENT** - CRITICAL for mobile UX

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/overlays/`

**Action Items:**
1. Implement bottom sheet:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/overlays/hvac_bottom_sheet.dart
   class HvacBottomSheet extends StatelessWidget {
     final Widget child;
     final bool isScrollControlled;
     final bool isDismissible;
     // ... Material Design 3 bottom sheet
   }
   ```

2. Helper methods:
   ```dart
   static Future<T?> show<T>(
     BuildContext context, {
     required Widget child,
   })

   static Future<T?> showModal<T>(
     BuildContext context, {
     required Widget child,
   })
   ```

**Testing:**
- [ ] Test bottom sheet show/dismiss
- [ ] Test drag to dismiss
- [ ] Test scrollable content
- [ ] Test modal vs persistent

**Deliverables:**
- [ ] Bottom sheet component
- [ ] Helper methods
- [ ] Commit: `feat(ui-kit): Add bottom sheet component`

---

#### 8.3 Add Menu Components (Day 31-32) - 8 hours

**NEW COMPONENTS**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/overlays/`

**Action Items:**
1. Implement dropdown menu:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/overlays/hvac_menu.dart
   class HvacMenu extends StatelessWidget {
     final List<HvacMenuItem> items;
     final Widget child;
     // ... Material Design 3 menu
   }
   ```

2. Implement context menu:
   ```dart
   class HvacContextMenu extends StatelessWidget {
     final List<HvacMenuItem> items;
     final Widget child;
     // ... Right-click menu
   }
   ```

3. Features:
   - Dropdown menu (triggered by button)
   - Context menu (right-click or long-press)
   - Nested menus (submenus)
   - Dividers, icons, shortcuts

**Testing:**
- [ ] Test menu open/close
- [ ] Test menu item selection
- [ ] Test nested menus
- [ ] Test keyboard navigation (arrow keys)
- [ ] Test context menu (right-click)

**Deliverables:**
- [ ] Menu components
- [ ] Example usage
- [ ] Commit: `feat(ui-kit): Add menu and context menu components`

---

#### Phase 4 Checkpoint (End of Week 8)

**Deliverables:**
- [x] Bottom navigation bar ✅
- [x] App bar ✅
- [x] Tabs ✅
- [x] Navigation drawer & rail ✅
- [x] Dialog/Modal ✅
- [x] Bottom sheet ✅
- [x] Menu components ✅

**Metrics:**
- Components added: 10 new navigation/overlay components
- UI Kit size: 130 → 150 files (+15%)
- Material Design 3 Compliance: 60% → 80%

---

## PHASE 5: SELECTION & POLISH (Weeks 9-10)

**Goal:** Add selection components and polish existing components
**Effort:** 40-50 hours
**Priority:** MEDIUM

### Week 9: Selection Components

#### 9.1 Add Chips (Day 33-35) - 12 hours

**NEW COMPONENTS** - Material Design 3 core

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/selection/`

**Action Items:**
1. Create selection category:
   ```bash
   mkdir -p packages/hvac_ui_kit/lib/src/widgets/selection
   ```

2. Implement chip variants:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/selection/hvac_chip.dart
   class HvacChip extends StatelessWidget {
     final String label;
     final Widget? avatar;
     final VoidCallback? onDeleted;
     final bool selected;
     // ... Base chip
   }

   // Filter chip (with checkmark)
   class HvacFilterChip extends StatelessWidget { }

   // Choice chip (radio button style)
   class HvacChoiceChip extends StatelessWidget { }

   // Input chip (for tags)
   class HvacInputChip extends StatelessWidget { }

   // Assist chip (for suggestions)
   class HvacAssistChip extends StatelessWidget { }
   ```

3. Features:
   - Filter chips (multi-select)
   - Choice chips (single-select)
   - Input chips (with delete button)
   - Assist chips (suggestions)
   - Avatar/icon support
   - Selected state

**Testing:**
- [ ] Test all chip variants
- [ ] Test selection states
- [ ] Test delete functionality
- [ ] Test with avatars/icons
- [ ] Test chip groups

**Deliverables:**
- [ ] 5 chip variants
- [ ] Example usage
- [ ] Commit: `feat(ui-kit): Add chip components`

---

#### 9.2 Add Segmented Button (Day 35-36) - 6 hours

**NEW COMPONENT**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/selection/`

**Action Items:**
1. Implement segmented button:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/selection/hvac_segmented_button.dart
   class HvacSegmentedButton<T> extends StatelessWidget {
     final List<HvacButtonSegment<T>> segments;
     final Set<T> selected;
     final ValueChanged<Set<T>> onSelectionChanged;
     final bool multiSelectionEnabled;
     // ... Material Design 3 segmented button
   }
   ```

2. Features:
   - Single selection (radio group)
   - Multi selection (checkbox group)
   - Icons + labels
   - Disabled segments

**Testing:**
- [ ] Test single selection
- [ ] Test multi selection
- [ ] Test with icons
- [ ] Test disabled segments

**Deliverables:**
- [ ] Segmented button component
- [ ] Example usage
- [ ] Commit: `feat(ui-kit): Add segmented button component`

---

#### 9.3 Add FAB (Floating Action Button) (Day 36-37) - 6 hours

**NEW COMPONENT** - CRITICAL for mobile UX

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/buttons/`

**Action Items:**
1. Implement FAB:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/buttons/hvac_fab.dart
   class HvacFAB extends StatelessWidget {
     final Widget icon;
     final VoidCallback onPressed;
     final String? label;
     final bool mini;
     final bool extended;
     // ... Material Design 3 FAB
   }
   ```

2. Variants:
   - Regular FAB
   - Mini FAB
   - Extended FAB (with label)
   - Large FAB

**Testing:**
- [ ] Test FAB tap
- [ ] Test mini FAB
- [ ] Test extended FAB
- [ ] Test with different positions (bottom-right, center, etc.)

**Deliverables:**
- [ ] FAB component with variants
- [ ] Example usage
- [ ] Commit: `feat(ui-kit): Add FAB component`

---

### Week 10: Component Polish & Documentation

#### 10.1 Add Missing Pickers (Day 37-38) - 8 hours

**NEW COMPONENTS**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/inputs/`

**Action Items:**
1. Add date picker:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/inputs/hvac_date_picker.dart
   class HvacDatePicker extends StatelessWidget {
     final DateTime? selectedDate;
     final ValueChanged<DateTime> onDateChanged;
     final DateTime? firstDate;
     final DateTime? lastDate;
     // ... Material Design 3 date picker
   }
   ```

2. Add date range picker:
   ```dart
   class HvacDateRangePicker extends StatelessWidget {
     final DateTimeRange? selectedRange;
     final ValueChanged<DateTimeRange> onRangeChanged;
     // ... Date range picker
   }
   ```

**Testing:**
- [ ] Test date picker
- [ ] Test date range picker
- [ ] Test min/max date constraints
- [ ] Test different locales

**Deliverables:**
- [ ] Date picker components
- [ ] Example usage
- [ ] Commit: `feat(ui-kit): Add date picker components`

---

#### 10.2 Add Layout Components (Day 38-39) - 8 hours

**NEW COMPONENTS**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/layout/`

**Action Items:**
1. Add spacer:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/layout/hvac_spacer.dart
   class HvacSpacer extends StatelessWidget {
     final double? width;
     final double? height;
     // ... Smart spacer using HvacSpacing
   }
   ```

2. Add aspect ratio box:
   ```dart
   class HvacAspectRatio extends StatelessWidget {
     final double aspectRatio;
     final Widget child;
     // ... Maintain aspect ratio
   }
   ```

3. Update divider (already moved):
   - Ensure animated_divider is properly in layout/

**Deliverables:**
- [ ] Spacer component
- [ ] Aspect ratio component
- [ ] Layout components complete
- [ ] Commit: `feat(ui-kit): Add layout utility components`

---

#### 10.3 Documentation & Examples (Day 39-40) - 8 hours

**Goal:** Create comprehensive documentation

**Action Items:**
1. Update README.md in hvac_ui_kit:
   - Component inventory
   - Installation instructions
   - Basic usage examples
   - Theming guide
   - Responsive design guide

2. Create COMPONENTS.md:
   - Complete component list with categories
   - Screenshots/GIFs of each component
   - Code examples for each
   - Props documentation

3. Create MIGRATION_GUIDE.md:
   - How to migrate from main app widgets to UI Kit
   - Breaking changes (if any)
   - Import path changes

4. Update example app:
   - Create comprehensive example app showing all components
   - Organize by category (buttons, inputs, cards, etc.)
   - Interactive playground

**Deliverables:**
- [ ] Updated README.md
- [ ] COMPONENTS.md documentation
- [ ] MIGRATION_GUIDE.md
- [ ] Enhanced example app
- [ ] Commit: `docs: Add comprehensive UI Kit documentation`

---

#### Phase 5 Checkpoint (End of Week 10)

**Deliverables:**
- [x] Chip components (5 variants) ✅
- [x] Segmented button ✅
- [x] FAB ✅
- [x] Date pickers ✅
- [x] Layout components ✅
- [x] Comprehensive documentation ✅

**Metrics:**
- Components added: 15 new components
- UI Kit size: 150 → 170 files (+13%)
- Material Design 3 Compliance: 80% → 90%
- Documentation: Complete ✅

---

## PHASE 6: ADVANCED & ACCESSIBILITY (Weeks 11-12)

**Goal:** Add advanced components and ensure WCAG AA compliance
**Effort:** 40-50 hours
**Priority:** NICE-TO-HAVE

### Week 11: Advanced Components

#### 11.1 Add Search Field (Day 41-42) - 6 hours

**NEW COMPONENT**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/inputs/`

**Action Items:**
1. Implement search field:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/inputs/hvac_search_field.dart
   class HvacSearchField extends StatelessWidget {
     final String? value;
     final ValueChanged<String> onChanged;
     final VoidCallback? onClear;
     final bool showClearButton;
     // ... Search input with debounce
   }
   ```

2. Features:
   - Search icon
   - Clear button
   - Debounced input (use debounce utility)
   - Recent searches
   - Suggestions dropdown

**Deliverables:**
- [ ] Search field component
- [ ] Commit: `feat(ui-kit): Add search field component`

---

#### 11.2 Add Data Display Components (Day 42-44) - 10 hours

**NEW COMPONENTS**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/data_display/`

**Action Items:**
1. Create data_display category:
   ```bash
   mkdir -p packages/hvac_ui_kit/lib/src/widgets/data_display
   ```

2. Add list tile:
   ```dart
   class HvacListTile extends StatelessWidget {
     final Widget? leading;
     final Widget title;
     final Widget? subtitle;
     final Widget? trailing;
     final VoidCallback? onTap;
     // ... Material Design 3 list tile
   }
   ```

3. Add expansion tile:
   ```dart
   class HvacExpansionTile extends StatefulWidget {
     final Widget title;
     final List<Widget> children;
     final bool initiallyExpanded;
     // ... Expandable list tile
   }
   ```

4. Add avatar:
   ```dart
   class HvacAvatar extends StatelessWidget {
     final String? imageUrl;
     final String? initials;
     final double size;
     // ... Circular avatar
   }
   ```

**Deliverables:**
- [ ] List tile, expansion tile, avatar
- [ ] Commit: `feat(ui-kit): Add data display components`

---

#### 11.3 Add Advanced Inputs (Day 44-45) - 6 hours

**NEW COMPONENTS**

**Destination:** `packages/hvac_ui_kit/lib/src/widgets/inputs/`

**Action Items:**
1. Add OTP input:
   ```dart
   class HvacOTPInput extends StatefulWidget {
     final int length;
     final ValueChanged<String> onCompleted;
     // ... OTP input (6-digit codes)
   }
   ```

2. Add chip input:
   ```dart
   class HvacChipInput extends StatefulWidget {
     final List<String> chips;
     final ValueChanged<List<String>> onChanged;
     // ... Tag/chip input field
   }
   ```

**Deliverables:**
- [ ] OTP input component
- [ ] Chip input component
- [ ] Commit: `feat(ui-kit): Add advanced input components`

---

### Week 12: Accessibility & Quality

#### 12.1 Accessibility Enhancements (Day 46-48) - 12 hours

**Goal:** Ensure WCAG AA compliance for all components

**Action Items:**
1. Add semantic labels to all components:
   - Wrap interactive elements in Semantics widgets
   - Add proper labels, hints, and values
   - Ensure screen reader friendly

2. Add skip links:
   ```dart
   // packages/hvac_ui_kit/lib/src/widgets/accessibility/hvac_skip_link.dart
   class HvacSkipLink extends StatelessWidget {
     final String label;
     final GlobalKey targetKey;
     // ... Skip to content link
   }
   ```

3. Add focus trap:
   ```dart
   class HvacFocusTrap extends StatefulWidget {
     final Widget child;
     // ... Trap focus in dialog/modal
   }
   ```

4. Accessibility audit:
   - Test all components with TalkBack (Android)
   - Test all components with VoiceOver (iOS)
   - Test keyboard navigation (Tab, Enter, Esc, Arrows)
   - Test color contrast (WCAG AA: 4.5:1 for text)

**Deliverables:**
- [ ] All components have semantic labels
- [ ] Skip links component
- [ ] Focus trap component
- [ ] Accessibility audit passed
- [ ] Commit: `feat(ui-kit): Enhance accessibility (WCAG AA compliance)`

---

#### 12.2 Testing & Quality (Day 48-50) - 10 hours

**Goal:** Comprehensive testing coverage

**Action Items:**
1. Write widget tests:
   - Test all interactive components
   - Test state changes
   - Test callbacks
   - Target: 80%+ coverage for UI Kit

2. Write golden tests:
   - Visual regression tests for all components
   - Test light/dark themes
   - Test different breakpoints

3. Performance testing:
   - Test list performance (ListView with 1000 items)
   - Test animation performance (60fps)
   - Test rebuild counts (use performance monitor)

4. Run analysis:
   ```bash
   flutter analyze packages/hvac_ui_kit
   flutter test packages/hvac_ui_kit
   dart format packages/hvac_ui_kit
   ```

**Deliverables:**
- [ ] 80%+ widget test coverage
- [ ] Golden tests for all components
- [ ] Performance benchmarks
- [ ] Zero analyzer warnings
- [ ] Commit: `test: Add comprehensive test coverage for UI Kit`

---

#### 12.3 Final Polish & Release (Day 50) - 4 hours

**Action Items:**
1. Version bump:
   - Update pubspec.yaml to 1.0.0
   - Update CHANGELOG.md with all changes

2. Final documentation review:
   - Ensure all components documented
   - Ensure all examples work
   - Update README with final component count

3. Create release checklist:
   - [ ] All components tested
   - [ ] All components documented
   - [ ] Zero analyzer warnings
   - [ ] 80%+ test coverage
   - [ ] WCAG AA compliant
   - [ ] Example app complete

4. Tag release:
   ```bash
   git tag -a v1.0.0 -m "UI Kit 1.0.0 - Production ready"
   git push origin v1.0.0
   ```

**Deliverables:**
- [ ] Version 1.0.0 released
- [ ] CHANGELOG.md updated
- [ ] Release tagged
- [ ] Commit: `chore: Release UI Kit v1.0.0`

---

#### Phase 6 Checkpoint (End of Week 12)

**Deliverables:**
- [x] Search field ✅
- [x] Data display components ✅
- [x] Advanced inputs ✅
- [x] WCAG AA accessibility ✅
- [x] Comprehensive testing ✅
- [x] UI Kit v1.0.0 released ✅

**Final Metrics:**
- Components added: 10 new components
- UI Kit size: 170+ files
- Material Design 3 Compliance: 90%+ ✅
- Big Tech Standard Compliance: 85%+ ✅
- Test Coverage: 80%+ ✅
- Accessibility: WCAG AA compliant ✅
- Documentation: Complete ✅

---

## SUMMARY & TIMELINE

### Total Effort Breakdown

| Phase | Description | Weeks | Hours | Priority |
|-------|-------------|-------|-------|----------|
| 1 | Critical Cleanup | 2 | 60-70 | CRITICAL |
| 2 | Web & Glassmorphic | 2 | 50-60 | HIGH |
| 3 | Forms & Animations | 2 | 40-50 | HIGH |
| 4 | Navigation & Overlays | 2 | 50-60 | HIGH |
| 5 | Selection & Polish | 2 | 40-50 | MEDIUM |
| 6 | Advanced & Accessibility | 2 | 40-50 | NICE-TO-HAVE |
| **TOTAL** | **Full UI Kit** | **12** | **280-340** | |

### Prioritized Timeline

#### Minimum Viable (Phases 1-3): 6 weeks, 150-180 hours
- All duplicates removed
- All feedback/loading/error/empty components in UI Kit
- All web components in UI Kit
- All glassmorphic components in UI Kit
- All form components in UI Kit
- Basic inputs (checkbox, radio, switch, dropdown) added

**Result:** 60% Material Design 3 compliance, production-ready for HVAC app

#### Recommended (Phases 1-4): 8 weeks, 200-240 hours
- Everything in Minimum Viable
- All navigation components added
- All overlay components added
- Main app common/ folder 100% clean

**Result:** 80% Material Design 3 compliance, excellent UX consistency

#### Full Compliance (Phases 1-6): 12 weeks, 280-340 hours
- Everything in Recommended
- All selection components added
- Advanced inputs added
- WCAG AA accessibility compliance
- Comprehensive testing
- Complete documentation

**Result:** 90%+ Material Design 3 compliance, Big Tech standard

---

## RISK MITIGATION

### Technical Risks

1. **Breaking Changes**
   - Mitigation: Create migration guide, use deprecation warnings
   - Timeline: Add 1 week buffer for migration issues

2. **Dependency Conflicts**
   - Mitigation: Use loose version constraints, test thoroughly
   - Timeline: No impact if dependencies are stable

3. **Performance Regression**
   - Mitigation: Performance testing in Phase 6
   - Timeline: Add 2-3 days for optimization if needed

### Process Risks

1. **Scope Creep**
   - Mitigation: Stick to Material Design 3 standard components only
   - Timeline: No custom components unless critical

2. **Testing Delays**
   - Mitigation: Write tests alongside component development
   - Timeline: Already included in estimates

3. **Documentation Debt**
   - Mitigation: Document as you build, not at the end
   - Timeline: Documentation time included in each phase

---

## SUCCESS METRICS

### Week-by-Week Goals

| Week | Component Count | MD3 Compliance | Test Coverage |
|------|----------------|----------------|---------------|
| 0 (Start) | 35 | 26% | 40% |
| 2 | 75 | 45% | 50% |
| 4 | 105 | 60% | 60% |
| 6 | 130 | 70% | 65% |
| 8 | 150 | 80% | 70% |
| 10 | 170 | 90% | 75% |
| 12 (Target) | 180+ | 90%+ | 80%+ |

### Final Success Criteria

- [ ] **Component Coverage:** 180+ components in UI Kit
- [ ] **Zero Components in Main App:** common/ folder only has app-specific widgets
- [ ] **Zero Duplicates:** No duplicate components
- [ ] **Material Design 3:** 90%+ compliance (28/31 components)
- [ ] **Big Tech Standard:** 85%+ compliance vs Airbnb/Google/Meta
- [ ] **Accessibility:** WCAG AA compliant (100%)
- [ ] **Testing:** 80%+ widget test coverage
- [ ] **Documentation:** Complete docs for all components
- [ ] **Performance:** All components run at 60fps
- [ ] **Production Ready:** Can ship UI Kit as standalone package

---

## GETTING STARTED

### Immediate Next Steps (This Week)

1. **Review this plan** with team and stakeholders
2. **Set up project board** (Jira/GitHub Projects) with all tasks
3. **Create feature branch**: `feature/ui-kit-migration`
4. **Start Phase 1, Week 1**: Delete duplicates (Day 1-2)
5. **Daily standups**: Track progress, blockers
6. **Weekly demos**: Show migrated components

### Resources Needed

- **Developer:** 1 senior Flutter developer (full-time for 12 weeks)
- **Designer:** Design review for new components (5-10 hours total)
- **QA:** Accessibility testing support (10-15 hours total)
- **Tools:**
  - Flutter DevTools (performance)
  - TalkBack/VoiceOver (accessibility)
  - Golden Toolkit (visual regression)
  - Figma (design tokens)

---

## CONCLUSION

This migration plan will transform the BREEZ Home HVAC app from a 15% compliant design system to a 90%+ production-ready UI Kit that meets Big Tech standards.

**Key Benefits:**
- 40-60% faster feature development
- 100% UI consistency
- 50% reduction in UI bugs
- Scalable to multiple IoT apps
- Faster onboarding for new developers

**Investment:** 12 weeks (can be reduced to 6-8 weeks for core components)
**ROI:** 10x over 2 years through faster development and reduced maintenance

**Recommendation:** Proceed with Phases 1-4 (8 weeks) as minimum viable, then evaluate Phases 5-6 based on project priorities and timeline.
