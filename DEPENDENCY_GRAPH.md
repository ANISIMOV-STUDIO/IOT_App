# DEPENDENCY GRAPH
**HVAC UI Kit Migration - Component Dependencies**

---

## DEPENDENCY VISUALIZATION

### Tier 0: External Dependencies (No Migration)
```
┌─────────────────────────────────────────┐
│  Flutter SDK                             │
│  - material.dart                         │
│  - widgets.dart                          │
│  - animation.dart                        │
└─────────────────────────────────────────┘
         │
         │
         ▼
┌─────────────────────────────────────────┐
│  External Packages                       │
│  - flutter_animate                       │
│  - fl_chart                              │
│  - shimmer (optional)                    │
└─────────────────────────────────────────┘
```

---

### Tier 1: Foundation (MOVE FIRST - No Dependencies)

```
┌──────────────────────────────────────────────────────────────────┐
│  THEME SYSTEM (Already in UI Kit ✅)                             │
│  ├── colors.dart                                                  │
│  ├── typography.dart                                              │
│  ├── spacing.dart                                                 │
│  ├── radius.dart                                                  │
│  ├── shadows.dart                                                 │
│  ├── decorations.dart                                             │
│  ├── theme.dart                                                   │
│  └── glassmorphism.dart                                           │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  ANIMATION CONSTANTS (MOVE: Phase 2)                             │
│  └── lib/core/constants/animation_constants.dart                 │
│      → packages/hvac_ui_kit/lib/src/animations/                  │
│      Used by: AnimatedCard, dialogs, transitions                 │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  RESPONSIVE UTILITIES (Already in UI Kit ✅)                     │
│  ├── responsive_utils.dart                                       │
│  ├── responsive_extensions.dart                                  │
│  ├── adaptive_layout.dart                                        │
│  └── performance_utils.dart                                      │
└──────────────────────────────────────────────────────────────────┘
```

**Dependencies**: None
**Dependents**: Everything else
**Migration Priority**: CRITICAL (blocking)

---

### Tier 2: Atomic UI (MOVE SECOND - Depends on Tier 1 Only)

```
┌──────────────────────────────────────────────────────────────────┐
│  GLASSMORPHIC COMPONENTS (MOVE: Phase 2)                         │
│  ├── base_glassmorphic_container.dart                            │
│  ├── glassmorphic_card.dart                                      │
│  ├── glow_card.dart                                              │
│  ├── gradient_card.dart                                          │
│  ├── neumorphic_card.dart                                        │
│  └── animated_gradient_background.dart                           │
│                                                                   │
│  Dependencies: HvacTheme, HvacColors, HvacSpacing               │
│  Dependents: Cards, overlays, dialogs                            │
└──────────────────────────────────────────────────────────────────┘
         │
         ├──────────────────────────────────────────────────────┐
         │                                                       │
         ▼                                                       ▼
┌─────────────────────────┐                  ┌──────────────────────────┐
│  BADGES & INDICATORS    │                  │  SHIMMER & SKELETON      │
│  (MOVE: Phase 3)        │                  │  (MOVE: Phase 1)         │
│  ├── animated_badge.dart│                  │  ├── base_shimmer.dart   │
│  ├── notification_badge │                  │  ├── pulse_skeleton.dart │
│  ├── status_indicator   │                  │  ├── skeleton_primitives │
│  └── temperature_badge  │                  │  ├── skeleton_cards.dart │
│                         │                  │  ├── skeleton_lists.dart │
│  Dependencies: Theme    │                  │  └── skeleton_screens    │
│  Dependents: Buttons,   │                  │                          │
│    Lists, Navigation    │                  │  Dependencies: Theme     │
└─────────────────────────┘                  │  Dependents: Loading     │
                                              │    states, empty states  │
                                              └──────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  TOOLTIPS (MOVE: Phase 2)                                        │
│  ├── web_tooltip_refactored.dart                                │
│  ├── tooltip_overlay.dart                                       │
│  ├── tooltip_controller.dart                                    │
│  ├── tooltip_types.dart                                         │
│  └── floating_tooltip.dart                                      │
│                                                                   │
│  Dependencies: Theme, animations                                 │
│  Dependents: Icon buttons, inputs, complex UI                   │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  DIVIDERS (MOVE: Phase 2)                                        │
│  ├── animated_divider.dart                                      │
│  └── animated_vertical_divider.dart                             │
│                                                                   │
│  Dependencies: Theme, animations                                 │
│  Dependents: Lists, layouts, sections                            │
└──────────────────────────────────────────────────────────────────┘
```

**Dependencies**: Tier 1 (Theme, Animation Constants)
**Dependents**: Tier 3 (Inputs, Buttons, Cards)
**Migration Priority**: HIGH

---

### Tier 3: Interactive Components (MOVE THIRD - Depends on Tier 1-2)

```
┌──────────────────────────────────────────────────────────────────┐
│  BUTTON COMPONENTS                                               │
│  ├── Already in UI Kit ✅                                        │
│  │   ├── hvac_primary_button.dart                               │
│  │   ├── hvac_outline_button.dart                               │
│  │   └── hvac_text_button.dart                                  │
│  │                                                                │
│  └── To Create (Phase 3):                                        │
│      ├── hvac_icon_button.dart                                  │
│      ├── hvac_fab.dart                                           │
│      ├── hvac_toggle_buttons.dart                               │
│      └── hvac_segmented_button.dart                             │
│                                                                   │
│  Dependencies: Theme, Tooltips (for icon button), Badges         │
│  Dependents: Dialogs, App Bars, Navigation                      │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  INPUT COMPONENTS                                                │
│  ├── Already in UI Kit ✅                                        │
│  │   ├── hvac_text_field.dart                                   │
│  │   └── hvac_password_field.dart                               │
│  │                                                                │
│  ├── To Migrate (Phase 3):                                       │
│  │   ├── auth_input_field.dart → hvac_enhanced_text_field.dart  │
│  │   ├── password_strength_indicator.dart                       │
│  │   └── time_picker_field.dart                                 │
│  │                                                                │
│  └── To Create (Phase 3):                                        │
│      ├── hvac_checkbox.dart                                     │
│      ├── hvac_radio_group.dart                                  │
│      ├── hvac_switch.dart                                       │
│      ├── hvac_dropdown.dart                                     │
│      └── enhanced adaptive_slider.dart                          │
│                                                                   │
│  Dependencies: Theme, Tooltips, Validation logic                 │
│  Dependents: Forms, Dialogs, Settings screens                   │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  CHIP COMPONENTS (Create: Phase 3)                               │
│  ├── hvac_chip.dart                                             │
│  ├── hvac_filter_chip.dart                                      │
│  ├── hvac_input_chip.dart                                       │
│  └── hvac_choice_chip.dart                                      │
│                                                                   │
│  Dependencies: Theme, Badges, Icons                              │
│  Dependents: Filters, Tags, Multi-select                         │
└──────────────────────────────────────────────────────────────────┘
```

**Dependencies**: Tier 1 (Theme), Tier 2 (Tooltips, Badges)
**Dependents**: Tier 4 (Dialogs, Forms, Navigation)
**Migration Priority**: HIGH

---

### Tier 4: Composite Components (MOVE FOURTH - Depends on Tier 1-3)

```
┌──────────────────────────────────────────────────────────────────┐
│  CARD COMPONENTS                                                 │
│  ├── Already in UI Kit ✅                                        │
│  │   └── hvac_card.dart                                         │
│  │                                                                │
│  ├── Migrated in Phase 2:                                        │
│  │   ├── animated_card.dart                                     │
│  │   └── glassmorphic/* (all variants)                          │
│  │                                                                │
│  ├── Refactored in Phase 1:                                      │
│  │   └── hover_card/* (web_hover_card split)                    │
│  │                                                                │
│  └── To Create (Phase 4):                                        │
│      ├── hvac_expansion_card.dart                               │
│      └── chart_card.dart (generic wrapper)                       │
│                                                                   │
│  Dependencies: Glassmorphic, Theme, Animations, Buttons          │
│  Dependents: Screens, Lists, Grids                               │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  LIST COMPONENTS (Create: Phase 4)                               │
│  ├── hvac_list_tile.dart                                        │
│  ├── hvac_switch_list_tile.dart                                 │
│  ├── hvac_checkbox_list_tile.dart                               │
│  └── hvac_reorderable_list.dart                                 │
│                                                                   │
│  Dependencies: Cards, Badges, Switches, Checkboxes, Dividers     │
│  Dependents: Screens, Navigation drawers                         │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  DATA DISPLAY COMPONENTS (Create: Phase 4)                       │
│  ├── hvac_data_table.dart                                       │
│  └── hvac_timeline.dart                                         │
│                                                                   │
│  Dependencies: Lists, Badges, Icons, Pagination                  │
│  Dependents: Analytics, Reports, History                         │
└──────────────────────────────────────────────────────────────────┘
```

**Dependencies**: Tier 1-3 (Theme, Buttons, Inputs, Badges)
**Dependents**: Tier 5 (Dialogs, Navigation)
**Migration Priority**: MEDIUM

---

### Tier 5: Feedback Components (MOVE FIFTH - Depends on Tier 1-4)

```
┌──────────────────────────────────────────────────────────────────┐
│  SNACKBAR SYSTEM (MOVE: Phase 5)                                │
│  ├── app_snackbar.dart (API facade)                             │
│  ├── base_snackbar.dart                                         │
│  ├── success_snackbar.dart                                      │
│  ├── error_snackbar.dart                                        │
│  ├── warning_snackbar.dart                                      │
│  ├── info_snackbar.dart                                         │
│  ├── loading_snackbar.dart                                      │
│  ├── toast_notification.dart                                    │
│  ├── toast_widget.dart                                          │
│  └── snackbar_types.dart                                        │
│                                                                   │
│  Dependencies: Theme, Icons, Animations                          │
│  Dependents: ALL screens (error handling, feedback)             │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  STATE COMPONENTS                                                │
│  ├── Already in UI Kit ✅                                        │
│  │   ├── hvac_loading_state.dart                                │
│  │   ├── hvac_error_state.dart                                  │
│  │   └── hvac_empty_state.dart                                  │
│  │                                                                │
│  ├── Enhanced in Phase 1:                                        │
│  │   ├── error/* (modular error system)                          │
│  │   ├── empty/* (modular empty state)                           │
│  │   └── loading/* (refactored loading_widget)                   │
│  │                                                                │
│  └── Dependencies: Theme, Shimmer, Icons, Buttons (retry)        │
│      Dependents: ALL async screens                               │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  DIALOG SYSTEM (Create: Phase 5)                                │
│  ├── hvac_dialog.dart                                           │
│  ├── hvac_alert_dialog.dart                                     │
│  ├── hvac_confirm_dialog.dart                                   │
│  ├── hvac_fullscreen_dialog.dart                                │
│  ├── hvac_bottom_sheet.dart                                     │
│  └── hvac_banner.dart                                           │
│                                                                   │
│  Dependencies: Theme, Buttons, Inputs, Cards, Animations         │
│  Dependents: Forms, Confirmations, Detail views                 │
└──────────────────────────────────────────────────────────────────┘
```

**Dependencies**: Tier 1-4 (Everything above)
**Dependents**: Application screens
**Migration Priority**: CRITICAL (error handling everywhere)

---

### Tier 6: Navigation Components (MOVE SIXTH - Depends on Tier 1-5)

```
┌──────────────────────────────────────────────────────────────────┐
│  APP BAR COMPONENTS (Create: Phase 6)                            │
│  ├── hvac_app_bar.dart                                          │
│  └── hvac_sliver_app_bar.dart                                   │
│                                                                   │
│  Dependencies: Theme, Buttons (actions), Badges, Search          │
│  Dependents: ALL screens                                         │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  BOTTOM NAVIGATION (Create: Phase 6)                             │
│  └── hvac_bottom_nav.dart                                       │
│                                                                   │
│  Dependencies: Theme, Badges, Icons, Animations                  │
│  Dependents: Main navigation scaffold                            │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  TAB BAR (Create: Phase 6)                                       │
│  ├── hvac_tab_bar.dart                                          │
│  └── hvac_tab_bar_view.dart                                     │
│                                                                   │
│  Dependencies: Theme, Badges, Indicators                         │
│  Dependents: Tabbed screens (Unit Detail, Schedule)             │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  NAVIGATION DRAWER (Create: Phase 6)                             │
│  └── hvac_drawer.dart                                           │
│                                                                   │
│  Dependencies: Theme, List Tiles, Badges, Dividers               │
│  Dependents: Main navigation                                     │
└──────────────────────────────────────────────────────────────────┘
```

**Dependencies**: Tier 1-5 (Everything except layout)
**Dependents**: Application scaffold
**Migration Priority**: MEDIUM

---

### Tier 7: Layout Components (MOVE SEVENTH - Can happen anytime)

```
┌──────────────────────────────────────────────────────────────────┐
│  RESPONSIVE LAYOUT (Phase 1 & 7)                                 │
│  ├── Already in UI Kit ✅                                        │
│  │   └── adaptive_layout.dart                                   │
│  │                                                                │
│  ├── Refactored in Phase 1:                                      │
│  │   └── responsive_layout/* (web_responsive_layout split)       │
│  │                                                                │
│  └── To Create (Phase 7):                                        │
│      ├── hvac_grid.dart                                         │
│      └── hvac_spacer.dart                                       │
│                                                                   │
│  Dependencies: Theme, ResponsiveUtils                            │
│  Dependents: Screens, Grids, Complex layouts                    │
└──────────────────────────────────────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  KEYBOARD SHORTCUTS (Refactored: Phase 1)                        │
│  └── keyboard/* (web_keyboard_shortcuts split)                   │
│      ├── keyboard_shortcuts.dart                                │
│      ├── shortcut_manager.dart                                  │
│      ├── shortcut_types.dart                                    │
│      └── platform_shortcuts.dart                                │
│                                                                   │
│  Dependencies: Theme only                                        │
│  Dependents: Web app, accessibility                              │
└──────────────────────────────────────────────────────────────────┘
```

**Dependencies**: Tier 1 (Theme)
**Dependents**: Application layout
**Migration Priority**: LOW (non-blocking)

---

## CIRCULAR DEPENDENCY ANALYSIS

### Potential Circular Dependencies (MUST RESOLVE)

#### Issue 1: Dialogs ↔ Inputs
**Problem**: Dialogs use inputs, but some inputs might show dialogs (e.g., date picker)

**Resolution**:
- Make dialog a dependency of inputs (not vice versa)
- Inputs should accept callbacks, not trigger dialogs directly
- App layer orchestrates input → dialog flow

#### Issue 2: Snackbars ↔ Error Widgets
**Problem**: Error widgets might show snackbars on retry

**Resolution**:
- Error widgets accept `onRetry` callback (no snackbar import)
- App layer calls snackbar after retry logic
- UI Kit components NEVER import other UI Kit feedback components

#### Issue 3: Loading States ↔ Shimmer
**Problem**: Both provide loading UI

**Resolution**:
- Shimmer is primitive (skeleton shapes)
- Loading states USE shimmer (one-way dependency)
- Shimmer never imports loading states

---

## DEPENDENCY MATRIX

| Component | Tier | Theme | Anim | Resp | Glass | Badge | Shimmer | Tooltip | Button | Input | Card | List | Dialog | Nav |
|-----------|------|-------|------|------|-------|-------|---------|---------|--------|-------|------|------|--------|-----|
| Theme     | 0    | -     | -    | -    | -     | -     | -       | -       | -      | -     | -    | -    | -      | -   |
| Animation | 1    | ✓     | -    | -    | -     | -     | -       | -       | -      | -     | -    | -    | -      | -   |
| Responsive| 1    | ✓     | -    | -    | -     | -     | -       | -       | -      | -     | -    | -    | -      | -   |
| Glass     | 2    | ✓     | ✓    | -    | -     | -     | -       | -       | -      | -     | -    | -    | -      | -   |
| Badge     | 2    | ✓     | ✓    | -    | -     | -     | -       | -       | -      | -     | -    | -    | -      | -   |
| Shimmer   | 2    | ✓     | ✓    | -    | -     | -     | -       | -       | -      | -     | -    | -    | -      | -   |
| Tooltip   | 2    | ✓     | ✓    | -    | -     | -     | -       | -       | -      | -     | -    | -    | -      | -   |
| Button    | 3    | ✓     | ✓    | ✓    | -     | ✓     | -       | ✓       | -      | -     | -    | -    | -      | -   |
| Input     | 3    | ✓     | ✓    | ✓    | -     | -     | -       | ✓       | -      | -     | -    | -    | -      | -   |
| Card      | 4    | ✓     | ✓    | ✓    | ✓     | -     | -       | -       | ✓      | -     | -    | -    | -      | -   |
| List      | 4    | ✓     | -    | ✓    | -     | ✓     | -       | -       | -      | ✓     | ✓    | -    | -      | -   |
| Dialog    | 5    | ✓     | ✓    | ✓    | -     | -     | -       | -       | ✓      | ✓     | ✓    | -    | -      | -   |
| Snackbar  | 5    | ✓     | ✓    | ✓    | -     | -     | -       | -       | -      | -     | -    | -    | -      | -   |
| Navigation| 6    | ✓     | ✓    | ✓    | -     | ✓     | -       | -       | ✓      | -     | -    | ✓    | -      | -   |

**Legend**:
- ✓ = Direct dependency
- - = No dependency

---

## MIGRATION ORDER (Dependency-Safe)

### Week 1: Foundation
1. Animation constants
2. Glassmorphic components
3. Shimmer system
4. Tooltips
5. Dividers

### Week 2: Atomic Components
6. Badges
7. Status indicators
8. Button enhancements
9. Input components
10. Chips

### Week 3: Composite & Feedback
11. Cards (remaining)
12. Lists
13. Snackbar system
14. State components (error, empty, loading)
15. Dialog system

### Week 4: Navigation & Layout
16. App bar
17. Bottom navigation
18. Tabs
19. Navigation drawer
20. Layout components

### Week 5: Polish & New Components
21. Data table
22. Timeline
23. Carousel
24. Bottom sheet
25. Testing & documentation

---

*End of Dependency Graph*
