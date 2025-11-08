# MIGRATION EXECUTION CHECKLIST
**HVAC UI Kit Migration - Step-by-Step Implementation Guide**

---

## HOW TO USE THIS CHECKLIST

1. **Check off items** as you complete them
2. **Do NOT skip items** - they are ordered by dependency
3. **Run tests** after each major section
4. **Commit frequently** with descriptive messages
5. **Update this file** as you progress

**Status Legend:**
- [ ] Not started
- [x] Completed
- [!] Blocked (note blocker)
- [~] In progress

---

## PRE-MIGRATION SETUP

### Environment Preparation
- [ ] Create feature branch: `git checkout -b feature/ui-kit-migration`
- [ ] Backup current state: `git tag backup-before-ui-kit-migration`
- [ ] Install required dependencies in UI Kit pubspec.yaml:
  - [ ] `flutter_animate: ^4.5.0`
  - [ ] `flutter: sdk: flutter`
- [ ] Run `flutter pub get` in UI Kit package
- [ ] Run `flutter pub get` in main app
- [ ] Run full test suite to establish baseline: `flutter test`
- [ ] Run `dart analyze` to establish clean baseline
- [ ] Document current test coverage: `flutter test --coverage`

### Documentation Setup
- [ ] Read COMPREHENSIVE_MIGRATION_PLAN.md
- [ ] Read DEPENDENCY_GRAPH.md
- [ ] Review COMPONENT_INVENTORY.csv
- [ ] Create migration log file: `MIGRATION_LOG.md`

---

## PHASE 1: DUPLICATES & CRITICAL FIXES (39 hours)

### 1.1 Resolve Duplicate: AnimatedBadge (4.5 hours)

**Goal**: Merge two AnimatedBadge implementations into one authoritative version

- [ ] **Step 1.1.1**: Read both implementations (30 min)
  - [ ] Read `lib/presentation/widgets/common/visual_polish/animated_badge.dart`
  - [ ] Read `packages/hvac_ui_kit/lib/src/widgets/animated_badge.dart`
  - [ ] Create feature comparison matrix in notes

- [ ] **Step 1.1.2**: Identify all usages (30 min)
  ```bash
  grep -r "AnimatedBadge" lib/ --include="*.dart" > animated_badge_usages.txt
  ```
  - [ ] Document: ~12 files use this component
  - [ ] Note import paths (relative vs package)

- [ ] **Step 1.1.3**: Merge implementations (2 hours)
  - [ ] Open `packages/hvac_ui_kit/lib/src/widgets/animated_badge.dart` in editor
  - [ ] Add `isNew` property from common/visual_polish version
  - [ ] Add pulse animation for `isNew` state
  - [ ] Enhance haptic feedback integration
  - [ ] Add comprehensive documentation comments
  - [ ] Ensure all parameters have default values
  - [ ] Save and format: `dart format animated_badge.dart`

- [ ] **Step 1.1.4**: Update all references (1 hour)
  - [ ] Find/replace across project:
    - FROM: `import '../widgets/common/visual_polish/animated_badge.dart';`
    - TO: `import 'package:hvac_ui_kit/hvac_ui_kit.dart';`
  - [ ] Remove any `AnimatedBadge` prefix qualifiers if using prefixed imports
  - [ ] Run `dart analyze` after each file update

- [ ] **Step 1.1.5**: Test merged component (30 min)
  - [ ] Create widget test: `test/widgets/animated_badge_test.dart`
  - [ ] Test all variants: standard, with icon, with isNew
  - [ ] Test onTap callback
  - [ ] Test animations
  - [ ] Run: `flutter test test/widgets/animated_badge_test.dart`

- [ ] **Step 1.1.6**: Delete duplicate (30 min)
  - [ ] Delete `lib/presentation/widgets/common/visual_polish/animated_badge.dart`
  - [ ] Run full test suite: `flutter test`
  - [ ] Run `dart analyze` (should be zero issues)
  - [ ] Commit: `git commit -m "feat: merge AnimatedBadge implementations into UI Kit"`

**Checkpoint**: AnimatedBadge duplicate resolved, 1 authoritative version in UI Kit

---

### 1.2 Consolidate Shimmer System (8 hours)

**Goal**: Move entire shimmer system to UI Kit with single source of truth

- [ ] **Step 1.2.1**: Create shimmer directory in UI Kit (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/shimmer
  ```

- [ ] **Step 1.2.2**: Move shimmer files (1 hour)
  - [ ] Copy `lib/presentation/widgets/common/shimmer/base_shimmer.dart`
    - TO: `packages/hvac_ui_kit/lib/src/widgets/shimmer/base_shimmer.dart`
  - [ ] Copy `lib/presentation/widgets/common/shimmer/pulse_skeleton.dart`
  - [ ] Copy `lib/presentation/widgets/common/shimmer/skeleton_primitives.dart`
  - [ ] Copy `lib/presentation/widgets/common/shimmer/skeleton_cards.dart`
  - [ ] Copy `lib/presentation/widgets/common/shimmer/skeleton_lists.dart`
  - [ ] Copy `lib/presentation/widgets/common/shimmer/skeleton_screens.dart`

- [ ] **Step 1.2.3**: Update imports in shimmer files (1 hour)
  - [ ] Open each shimmer file
  - [ ] Replace relative imports with package imports:
    - FROM: `import '../../../core/theme/colors.dart';`
    - TO: `import 'package:hvac_ui_kit/hvac_ui_kit.dart';`
  - [ ] Replace cross-references within shimmer:
    - FROM: `import 'base_shimmer.dart';`
    - TO: `import 'package:hvac_ui_kit/hvac_ui_kit.dart';`
  - [ ] Run `dart analyze` on UI Kit package

- [ ] **Step 1.2.4**: Create barrel export (30 min)
  - [ ] Create `packages/hvac_ui_kit/lib/src/widgets/shimmer/shimmer.dart`
  - [ ] Export all shimmer components:
    ```dart
    export 'base_shimmer.dart';
    export 'pulse_skeleton.dart';
    export 'skeleton_primitives.dart';
    export 'skeleton_cards.dart';
    export 'skeleton_lists.dart';
    export 'skeleton_screens.dart';
    ```

- [ ] **Step 1.2.5**: Update main UI Kit barrel export (15 min)
  - [ ] Open `packages/hvac_ui_kit/lib/hvac_ui_kit.dart`
  - [ ] Add shimmer export:
    ```dart
    // Shimmer & Skeleton Components
    export 'src/widgets/shimmer/shimmer.dart';
    ```

- [ ] **Step 1.2.6**: Reconcile with animations/shimmer_effect.dart (2 hours)
  - [ ] Read `packages/hvac_ui_kit/lib/src/animations/widgets/shimmer_effect.dart`
  - [ ] Compare with `shimmer/base_shimmer.dart`
  - [ ] If animations version is better: use it as base, add shimmer/ features
  - [ ] If shimmer/ version is better: deprecate animations version
  - [ ] Merge best features from both
  - [ ] Update cross-references

- [ ] **Step 1.2.7**: Update all references in main app (2 hours)
  - [ ] Find all shimmer imports:
    ```bash
    grep -r "import.*shimmer" lib/ --include="*.dart" > shimmer_imports.txt
    ```
  - [ ] Update ~25 files:
    - FROM: `import '../../widgets/common/shimmer/base_shimmer.dart';`
    - TO: `import 'package:hvac_ui_kit/hvac_ui_kit.dart';`
  - [ ] Update any direct class references
  - [ ] Run `dart analyze` after batch update

- [ ] **Step 1.2.8**: Test shimmer system (1 hour)
  - [ ] Create widget tests for each shimmer component
  - [ ] Test skeleton primitives render correctly
  - [ ] Test skeleton cards have correct sizing
  - [ ] Test animation plays smoothly
  - [ ] Run: `flutter test --name=shimmer`

- [ ] **Step 1.2.9**: Delete source directory (30 min)
  - [ ] Delete `lib/presentation/widgets/common/shimmer/` directory
  - [ ] Delete `lib/presentation/widgets/common/enhanced_shimmer.dart` (redirect file)
  - [ ] Run full test suite
  - [ ] Run app and visually verify loading states
  - [ ] Commit: `git commit -m "feat: consolidate shimmer system into UI Kit"`

**Checkpoint**: Shimmer system migrated, all loading skeletons working

---

### 1.3 Consolidate Error Widget System (9 hours)

**Goal**: Unified error widget system with no i18n dependencies

- [ ] **Step 1.3.1**: Create error directory in UI Kit (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/states/error
  ```

- [ ] **Step 1.3.2**: Move error system files (1 hour)
  - [ ] Copy `lib/presentation/widgets/common/error/error_types.dart`
    - TO: `packages/hvac_ui_kit/lib/src/widgets/states/error/error_types.dart`
  - [ ] Copy `lib/presentation/widgets/common/error/error_icon.dart`
  - [ ] Copy `lib/presentation/widgets/common/error/error_icon_widget.dart`
  - [ ] Copy `lib/presentation/widgets/common/error/error_actions.dart`
  - [ ] Copy `lib/presentation/widgets/common/error/error_actions_widget.dart`
  - [ ] Copy `lib/presentation/widgets/common/error/error_details.dart`
  - [ ] Copy `lib/presentation/widgets/common/error/error_widget_refactored.dart`
    - RENAME TO: `app_error_widget.dart`

- [ ] **Step 1.3.3**: Merge duplicate icon/action widgets (1 hour)
  - [ ] Compare `error_icon.dart` vs `error_icon_widget.dart`
  - [ ] Merge into single `error_icon.dart` (keep best implementation)
  - [ ] Compare `error_actions.dart` vs `error_actions_widget.dart`
  - [ ] Merge into single `error_actions.dart`
  - [ ] Delete duplicate files

- [ ] **Step 1.3.4**: Remove i18n dependency (3 hours)
  - [ ] Open `app_error_widget.dart`
  - [ ] Find all `AppLocalizations.of(context)!` usages
  - [ ] Refactor factory methods to accept string parameters:
    ```dart
    // BEFORE:
    factory AppErrorWidget.network({
      required BuildContext context,
      VoidCallback? onRetry,
    }) {
      final l10n = AppLocalizations.of(context)!;
      return AppErrorWidget(
        title: l10n.connectionError,
        message: l10n.unableToConnect,
        ...
      );
    }

    // AFTER:
    factory AppErrorWidget.network({
      VoidCallback? onRetry,
      String? title,
      String? message,
    }) {
      return AppErrorWidget(
        title: title ?? 'Connection Error',
        message: message ?? 'Unable to connect to server',
        ...
      );
    }
    ```
  - [ ] Make all user-facing strings required parameters
  - [ ] Remove BuildContext from factory signatures where only used for i18n
  - [ ] Document i18n integration pattern in dartdoc

- [ ] **Step 1.3.5**: Update imports in error files (30 min)
  - [ ] Replace relative imports with package imports
  - [ ] Update cross-references within error system
  - [ ] Run `dart analyze` on UI Kit package

- [ ] **Step 1.3.6**: Create barrel export (15 min)
  - [ ] Create `packages/hvac_ui_kit/lib/src/widgets/states/error/error.dart`
  - [ ] Export all error components

- [ ] **Step 1.3.7**: Update states.dart barrel (15 min)
  - [ ] Open `packages/hvac_ui_kit/lib/src/widgets/states/states.dart`
  - [ ] Add: `export 'error/error.dart';`

- [ ] **Step 1.3.8**: Replace existing hvac_error_state.dart (30 min)
  - [ ] Rename `packages/hvac_ui_kit/lib/src/widgets/states/hvac_error_state.dart`
    - TO: `hvac_error_state_old.dart` (backup)
  - [ ] Update `states.dart` to export new error system
  - [ ] Add backward compatibility alias if needed

- [ ] **Step 1.3.9**: Update all references in main app (2 hours)
  - [ ] Find all error widget imports:
    ```bash
    grep -r "ErrorWidget\|error_widget" lib/ --include="*.dart" > error_imports.txt
    ```
  - [ ] Update ~30 files to use package imports
  - [ ] Update factory method calls to provide string parameters:
    ```dart
    // BEFORE:
    AppErrorWidget.network(
      context: context,
      onRetry: _retry,
    )

    // AFTER:
    AppErrorWidget.network(
      title: AppLocalizations.of(context)!.connectionError,
      message: AppLocalizations.of(context)!.unableToConnect,
      onRetry: _retry,
    )
    ```
  - [ ] Run `dart analyze` after batch update

- [ ] **Step 1.3.10**: Test error system (30 min)
  - [ ] Create widget tests for error components
  - [ ] Test all error types (network, server, permission, not found)
  - [ ] Test retry callback
  - [ ] Test error details expansion
  - [ ] Run: `flutter test --name=error`

- [ ] **Step 1.3.11**: Delete source files (30 min)
  - [ ] Delete `lib/presentation/widgets/common/error/` directory
  - [ ] Delete `lib/presentation/widgets/common/error_widget.dart` (redirect)
  - [ ] Delete `lib/presentation/widgets/common/error_widget_updated.dart` (obsolete)
  - [ ] Delete `hvac_error_state_old.dart` backup (if tests pass)
  - [ ] Run full test suite
  - [ ] Commit: `git commit -m "feat: consolidate error system into UI Kit, remove i18n dependency"`

**Checkpoint**: Error system migrated, working with i18n in app layer

---

### 1.4 Consolidate Empty State System (8 hours)

**Goal**: Unified empty state system with generic factories only

- [ ] **Step 1.4.1**: Create empty state directory (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/states/empty
  ```

- [ ] **Step 1.4.2**: Move empty state files (45 min)
  - [ ] Copy `lib/presentation/widgets/common/empty_state_widget.dart`
    - TO: `packages/hvac_ui_kit/lib/src/widgets/states/empty/empty_state_widget.dart`
  - [ ] Copy `lib/presentation/widgets/common/empty_state/empty_state_types.dart`
  - [ ] Copy `lib/presentation/widgets/common/empty_state/empty_state_illustration.dart`
  - [ ] Copy `lib/presentation/widgets/common/empty_state/compact_empty_state.dart`
  - [ ] Copy `lib/presentation/widgets/common/empty_states/animated_icons.dart`
  - [ ] Copy `lib/presentation/widgets/common/empty_states/base_empty_state.dart`

- [ ] **Step 1.4.3**: Merge duplicate base_empty_state (1 hour)
  - [ ] Compare `empty_state_widget.dart` vs `empty_states/base_empty_state.dart`
  - [ ] Identify unique features in each
  - [ ] Merge into single `empty_state_widget.dart`
  - [ ] Delete `base_empty_state.dart`

- [ ] **Step 1.4.4**: Remove domain-specific factories (1.5 hours)
  - [ ] Open `empty_state_widget.dart`
  - [ ] Identify domain-specific factories:
    - `EmptyStateWidget.noDevices()`
    - `EmptyStateWidget.noSchedules()`
  - [ ] **DO NOT DELETE** - instead, document as "app layer" examples
  - [ ] Add comment:
    ```dart
    /// Domain-specific factory - should be in app layer
    /// Example for reference only, not part of UI Kit API
    @Deprecated('Move to app layer as helper')
    factory EmptyStateWidget.noDevices({VoidCallback? onAddDevice}) {
      ...
    }
    ```
  - [ ] Create app helper file: `lib/core/ui/empty_state_helpers.dart`
  - [ ] Move domain factories to app helper

- [ ] **Step 1.4.5**: Update imports (1 hour)
  - [ ] Replace relative imports with package imports
  - [ ] Update cross-references
  - [ ] Run `dart analyze` on UI Kit

- [ ] **Step 1.4.6**: Create barrel export (15 min)
  - [ ] Create `packages/hvac_ui_kit/lib/src/widgets/states/empty/empty.dart`
  - [ ] Export all empty state components

- [ ] **Step 1.4.7**: Update states.dart barrel (15 min)
  - [ ] Add: `export 'empty/empty.dart';` to states.dart

- [ ] **Step 1.4.8**: Update all references (2 hours)
  - [ ] Find all empty state imports
  - [ ] Update ~18 files to use package imports
  - [ ] Update factory calls to use app helpers for domain-specific states
  - [ ] Run `dart analyze`

- [ ] **Step 1.4.9**: Test empty state system (45 min)
  - [ ] Create widget tests
  - [ ] Test all generic factories (noData, noSearchResults, noNotifications)
  - [ ] Test custom illustration
  - [ ] Test action button callback
  - [ ] Test animations
  - [ ] Run: `flutter test --name=empty`

- [ ] **Step 1.4.10**: Delete source files (30 min)
  - [ ] Delete `lib/presentation/widgets/common/empty_state/` directory
  - [ ] Delete `lib/presentation/widgets/common/empty_states/` directory
  - [ ] Delete `lib/presentation/widgets/common/empty_state_widget.dart`
  - [ ] Delete `packages/hvac_ui_kit/lib/src/widgets/states/hvac_empty_state.dart` (obsolete)
  - [ ] Run full test suite
  - [ ] Commit: `git commit -m "feat: consolidate empty state system, move domain logic to app"`

**Checkpoint**: Empty state system migrated with clean separation

---

### 1.5 Refactor: web_keyboard_shortcuts.dart (3 hours)

**Goal**: Split 298-line file into 4 files <100 lines each

- [ ] **Step 1.5.1**: Create keyboard directory (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/keyboard
  ```

- [ ] **Step 1.5.2**: Analyze current file (30 min)
  - [ ] Read `lib/presentation/widgets/common/web_keyboard_shortcuts.dart`
  - [ ] Identify logical sections:
    - Main widget class
    - Shortcut manager logic
    - Type definitions
    - Platform-specific code

- [ ] **Step 1.5.3**: Extract types (30 min)
  - [ ] Create `keyboard/shortcut_types.dart`
  - [ ] Move `CallbackIntent` class
  - [ ] Move any enums, typedefs, constants
  - [ ] Add dartdoc comments

- [ ] **Step 1.5.4**: Extract platform logic (30 min)
  - [ ] Create `keyboard/platform_shortcuts.dart`
  - [ ] Move platform detection code
  - [ ] Move platform-specific shortcut mappings
  - [ ] Use foundation.dart for platform detection

- [ ] **Step 1.5.5**: Extract shortcut manager (45 min)
  - [ ] Create `keyboard/shortcut_manager.dart`
  - [ ] Move shortcut registration/unregistration logic
  - [ ] Move focus management
  - [ ] Keep as separate class

- [ ] **Step 1.5.6**: Create main widget (30 min)
  - [ ] Create `keyboard/keyboard_shortcuts.dart`
  - [ ] Keep only widget rendering logic (~120 lines)
  - [ ] Import other keyboard modules
  - [ ] Verify widget works identically

- [ ] **Step 1.5.7**: Create barrel export (15 min)
  - [ ] Create `keyboard/keyboard.dart`
  - [ ] Export all keyboard components

- [ ] **Step 1.5.8**: Update references (15 min)
  - [ ] Find usages of WebKeyboardShortcuts
  - [ ] Update imports to package imports
  - [ ] Verify functionality

- [ ] **Step 1.5.9**: Delete source file (15 min)
  - [ ] Delete `lib/presentation/widgets/common/web_keyboard_shortcuts.dart`
  - [ ] Run tests
  - [ ] Commit: `git commit -m "refactor: split keyboard shortcuts into modular files"`

**Checkpoint**: Keyboard shortcuts refactored, all files <300 lines

---

### 1.6 Refactor: web_hover_card.dart (2 hours)

**Goal**: Split 294-line file into 4 files <100 lines each

- [ ] **Step 1.6.1**: Create hover card directory (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/cards/hover
  ```

- [ ] **Step 1.6.2**: Analyze file (20 min)
  - [ ] Read `lib/presentation/widgets/common/web_hover_card.dart`
  - [ ] Identify: WebHoverCard, WebHoverIconButton, hover effects, config

- [ ] **Step 1.6.3**: Extract config (20 min)
  - [ ] Create `hover/hover_config.dart`
  - [ ] Move configuration classes
  - [ ] Move constants

- [ ] **Step 1.6.4**: Extract hover effects (30 min)
  - [ ] Create `hover/hover_effects.dart`
  - [ ] Move animation logic
  - [ ] Move hover state management

- [ ] **Step 1.6.5**: Extract hover icon button (30 min)
  - [ ] Create `hover/hover_icon_button.dart`
  - [ ] Move WebHoverIconButton class (~80 lines)
  - [ ] Test separately

- [ ] **Step 1.6.6**: Create main hover card (20 min)
  - [ ] Create `hover/hover_card.dart`
  - [ ] Keep WebHoverCard class (~100 lines)
  - [ ] Import other hover modules

- [ ] **Step 1.6.7**: Update references & delete (20 min)
  - [ ] Update ~10 files to use package imports
  - [ ] Delete source file
  - [ ] Test hover interactions
  - [ ] Commit: `git commit -m "refactor: split hover card into modular files"`

**Checkpoint**: Hover card refactored

---

### 1.7 Refactor: web_responsive_layout.dart (2.5 hours)

**Goal**: Split 273-line file into 3 files

- [ ] **Step 1.7.1**: Create responsive layout directory (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/layout/responsive
  ```

- [ ] **Step 1.7.2**: Extract breakpoint builder (45 min)
  - [ ] Create `responsive/breakpoint_builder.dart`
  - [ ] Move breakpoint logic (~70 lines)

- [ ] **Step 1.7.3**: Extract adaptive scaffold (45 min)
  - [ ] Create `responsive/adaptive_scaffold.dart`
  - [ ] Move scaffold variants (~80 lines)

- [ ] **Step 1.7.4**: Create main responsive layout (45 min)
  - [ ] Create `responsive/responsive_layout.dart`
  - [ ] Keep main widget (~120 lines)

- [ ] **Step 1.7.5**: Update and delete (30 min)
  - [ ] Update references
  - [ ] Delete source
  - [ ] Test responsive behavior
  - [ ] Commit: `git commit -m "refactor: split responsive layout into modular files"`

**Checkpoint**: Responsive layout refactored

---

### 1.8 Refactor: loading_widget.dart (2 hours)

**Goal**: Split 265-line file into 4 files

- [ ] **Step 1.8.1**: Create loading directory (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/states/loading
  ```

- [ ] **Step 1.8.2**: Extract loading types (30 min)
  - [ ] Create `loading/loading_types.dart`
  - [ ] Move enums and types (~35 lines)

- [ ] **Step 1.8.3**: Extract loading spinner (30 min)
  - [ ] Create `loading/loading_spinner.dart`
  - [ ] Move spinner widget (~50 lines)

- [ ] **Step 1.8.4**: Extract loading overlay (45 min)
  - [ ] Create `loading/loading_overlay.dart`
  - [ ] Move LoadingOverlay class (~80 lines)

- [ ] **Step 1.8.5**: Create main loading widget (30 min)
  - [ ] Create `loading/loading_widget.dart`
  - [ ] Keep LoadingWidget class (~100 lines)

- [ ] **Step 1.8.6**: Update and delete (15 min)
  - [ ] Update references
  - [ ] Delete source
  - [ ] Test loading states
  - [ ] Commit: `git commit -m "refactor: split loading widget into modular files"`

**Checkpoint**: All Phase 1 refactoring complete

---

### Phase 1 Summary

- [ ] **Verification Checklist**:
  - [ ] All duplicates resolved (6 components)
  - [ ] All files <300 lines
  - [ ] Zero hard-coded i18n in UI Kit
  - [ ] All tests passing: `flutter test`
  - [ ] Zero analyzer warnings: `dart analyze`
  - [ ] Visual regression tests pass
  - [ ] App builds and runs: `flutter run`

- [ ] **Commit Phase 1**:
  ```bash
  git add .
  git commit -m "feat(ui-kit): Phase 1 complete - duplicates resolved, critical files refactored"
  git push origin feature/ui-kit-migration
  ```

**Estimated Time: 39 hours**
**Actual Time: _____ hours** (fill in)

---

## PHASE 2: FOUNDATION COMPONENTS (20 hours)

### 2.1 Migrate Animation Constants (1 hour)

- [ ] **Step 2.1.1**: Copy animation constants (15 min)
  - [ ] Copy `lib/core/constants/animation_constants.dart`
    - TO: `packages/hvac_ui_kit/lib/src/animations/animation_constants.dart`

- [ ] **Step 2.1.2**: Update imports in constants file (15 min)
  - [ ] Verify no app-specific imports

- [ ] **Step 2.1.3**: Export in animations barrel (15 min)
  - [ ] Open `packages/hvac_ui_kit/lib/src/animations/animations.dart`
  - [ ] Add: `export 'animation_constants.dart';`

- [ ] **Step 2.1.4**: Update references (15 min)
  - [ ] Find all imports of animation_constants
  - [ ] Update to package imports
  - [ ] Delete source file
  - [ ] Commit: `git commit -m "feat: migrate animation constants to UI Kit"`

---

### 2.2 Migrate AnimatedCard (3 hours)

- [ ] **Step 2.2.1**: Copy AnimatedCard (30 min)
  - [ ] Copy `lib/presentation/widgets/common/animated_card.dart`
    - TO: `packages/hvac_ui_kit/lib/src/widgets/cards/animated_card.dart`

- [ ] **Step 2.2.2**: Remove domain-specific variants (30 min)
  - [ ] Open animated_card.dart in UI Kit
  - [ ] Keep `AnimatedCard` class
  - [ ] **REMOVE** `AnimatedDeviceCard` class (domain-specific)
  - [ ] Update imports to use package imports

- [ ] **Step 2.2.3**: Export in cards barrel (15 min)
  - [ ] Open `packages/hvac_ui_kit/lib/src/widgets/cards/cards.dart`
  - [ ] Add: `export 'animated_card.dart';`

- [ ] **Step 2.2.4**: Update references (1 hour)
  - [ ] Update ~12 files to use package imports
  - [ ] For files using AnimatedDeviceCard:
    - [ ] Create in app: `lib/presentation/widgets/device/animated_device_card.dart`
    - [ ] Wrap AnimatedCard with device-specific decoration

- [ ] **Step 2.2.5**: Test and delete (45 min)
  - [ ] Test card animations
  - [ ] Delete source file
  - [ ] Commit: `git commit -m "feat: migrate AnimatedCard to UI Kit"`

---

### 2.3 Migrate AnimatedDivider (1.5 hours)

- [ ] **Step 2.3.1**: Create layout directory (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/layout
  ```

- [ ] **Step 2.3.2**: Copy animated divider (30 min)
  - [ ] Copy `lib/presentation/widgets/common/visual_polish/animated_divider.dart`
    - TO: `packages/hvac_ui_kit/lib/src/widgets/layout/animated_divider.dart`

- [ ] **Step 2.3.3**: Create layout barrel (15 min)
  - [ ] Create `packages/hvac_ui_kit/lib/src/widgets/layout/layout.dart`
  - [ ] Export: `export 'animated_divider.dart';`

- [ ] **Step 2.3.4**: Update main barrel (15 min)
  - [ ] Add to `hvac_ui_kit.dart`: `export 'src/widgets/layout/layout.dart';`

- [ ] **Step 2.3.5**: Update references and delete (15 min)
  - [ ] Update ~3 files
  - [ ] Delete source
  - [ ] Commit

---

### 2.4 Migrate TimePickerField (2 hours)

- [ ] **Step 2.4.1**: Copy to UI Kit (30 min)
  - [ ] Copy `lib/presentation/widgets/common/time_picker_field.dart`
    - TO: `packages/hvac_ui_kit/lib/src/widgets/inputs/time_picker_field.dart`

- [ ] **Step 2.4.2**: Export in inputs barrel (15 min)
  - [ ] Add to inputs/inputs.dart

- [ ] **Step 2.4.3**: Update references (1 hour)
  - [ ] Update ~6 files (scheduling screens)

- [ ] **Step 2.4.4**: Test and delete (15 min)
  - [ ] Test time picker functionality
  - [ ] Delete source
  - [ ] Commit

---

### 2.5 Migrate Glassmorphic Components (8 hours)

- [ ] **Step 2.5.1**: Create glassmorphic directory (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/glassmorphic
  ```

- [ ] **Step 2.5.2**: Move all glassmorphic files (2 hours)
  - [ ] Copy all 6 files from `lib/presentation/widgets/common/glassmorphic/`
  - [ ] Update imports to package imports in each file
  - [ ] Run `dart analyze` on each file

- [ ] **Step 2.5.3**: Create barrel export (30 min)
  - [ ] Create `glassmorphic/glassmorphic.dart`
  - [ ] Export all components

- [ ] **Step 2.5.4**: Update main barrel (15 min)
  - [ ] Add to `hvac_ui_kit.dart`

- [ ] **Step 2.5.5**: Update all references (2 hours)
  - [ ] Update ~14 files using glassmorphic components

- [ ] **Step 2.5.6**: Visual regression tests (1 hour)
  - [ ] Test all glassmorphic variants render correctly
  - [ ] Test blur effects
  - [ ] Test animations

- [ ] **Step 2.5.7**: Delete source directory (30 min)
  - [ ] Delete `lib/presentation/widgets/common/glassmorphic/`
  - [ ] Delete redirect file
  - [ ] Delete example_usage.dart
  - [ ] Commit

---

### 2.6 Migrate Visual Polish Components (5.5 hours)

- [ ] **Step 2.6.1**: Create indicators directory (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/indicators
  ```

- [ ] **Step 2.6.2**: Merge status_indicator duplicates (1 hour)
  - [ ] Compare common/visual_polish/status_indicator.dart
  - [ ] With packages/hvac_ui_kit/lib/src/widgets/status_indicator.dart
  - [ ] Merge best features into indicators/status_indicator.dart

- [ ] **Step 2.6.3**: Move progress indicator (1 hour)
  - [ ] Copy premium_progress_indicator.dart to indicators/
  - [ ] Update imports

- [ ] **Step 2.6.4**: Move floating tooltip (1 hour)
  - [ ] This should go to tooltips/, not indicators/
  - [ ] Will be handled with tooltip system

- [ ] **Step 2.6.5**: Create indicators barrel (15 min)

- [ ] **Step 2.6.6**: Update references (1.5 hours)
  - [ ] Update ~8 files

- [ ] **Step 2.6.7**: Test and delete (30 min)
  - [ ] Test indicators render
  - [ ] Delete source files
  - [ ] Commit

---

### 2.7 Migrate Tooltip System (4 hours)

- [ ] **Step 2.7.1**: Create tooltips directory (15 min)
  ```bash
  mkdir -p packages/hvac_ui_kit/lib/src/widgets/tooltips
  ```

- [ ] **Step 2.7.2**: Move all tooltip files (1 hour)
  - [ ] Copy lib/presentation/widgets/common/tooltip/* (4 files)
  - [ ] Copy lib/presentation/widgets/common/visual_polish/floating_tooltip.dart
  - [ ] Update imports

- [ ] **Step 2.7.3**: Create tooltip barrel (15 min)

- [ ] **Step 2.7.4**: Update references (2 hours)
  - [ ] Update ~8 files using tooltips

- [ ] **Step 2.7.5**: Test and delete (30 min)
  - [ ] Test tooltip positioning
  - [ ] Test hover behavior
  - [ ] Delete source files
  - [ ] Commit

---

### Phase 2 Complete

- [ ] **Verification**:
  - [ ] All foundation components in UI Kit
  - [ ] Zero dependencies on app code
  - [ ] All tests passing
  - [ ] `dart analyze` clean

- [ ] **Commit Phase 2**:
  ```bash
  git commit -m "feat(ui-kit): Phase 2 complete - foundation components migrated"
  ```

**Estimated: 20 hours**

---

## PHASE 3: ATOMIC COMPONENTS (48.5 hours)

[Continue with detailed steps for Phase 3...]

**Due to length constraints, I'll provide the structure. You should expand each phase with the same detail as Phase 1-2.**

### 3.1 Create Button Components (10 hours)
- [ ] HvacIconButton (4h)
- [ ] HvacFab (3h)
- [ ] HvacToggleButtons (3h)

### 3.2 Migrate Input Components (20 hours)
- [ ] Migrate AuthInputField → HvacEnhancedTextField (7.5h)
- [ ] Migrate PasswordStrengthIndicator (2.5h)
- [ ] Create HvacCheckbox (3h)
- [ ] Enhance HvacPasswordField (2h)
- [ ] Create HvacDropdown (5h)

### 3.3 Create Chip Components (5 hours)
- [ ] HvacChip variants (5h)

### 3.4 Migrate Badge Components (3.5 hours)
- [ ] NotificationBadge (3.5h)

---

## PHASE 4: COMPOSITE COMPONENTS (26 hours)
### 4.1 Card Components (4 hours)
### 4.2 List Components (8 hours)
### 4.3 Data Display (14 hours)

---

## PHASE 5: FEEDBACK COMPONENTS (23 hours)
### 5.1 Snackbar System (10 hours)
### 5.2 Dialog System (13 hours)

---

## PHASE 6: NAVIGATION COMPONENTS (13 hours)
### 6.1 App Bar (4 hours)
### 6.2 Bottom Nav (3 hours)
### 6.3 Tabs (3 hours)
### 6.4 Drawer (3 hours)

---

## PHASE 7: LAYOUT COMPONENTS (4 hours)
### 7.1 Grid (3 hours)
### 7.2 Spacer (1 hour)

---

## PHASE 8: NEW COMPONENTS (8 hours)
### 8.1 Standard Badge (2 hours)
### 8.2 Carousel (4 hours)
### 8.3 Segmented Button (2 hours)

---

## POST-MIGRATION

### Final Verification
- [ ] All files in lib/presentation/widgets/common/ deleted
- [ ] Zero analyzer warnings
- [ ] All tests passing
- [ ] Visual regression tests pass
- [ ] Performance benchmarks acceptable
- [ ] Documentation complete

### Cleanup
- [ ] Delete backup files
- [ ] Remove deprecated code
- [ ] Update CHANGELOG.md
- [ ] Create migration guide for team

---

**TOTAL: 181.5 hours**
