# Refactoring Cycles 7-30: Detailed Implementation Plan

## Quick Reference
- **Completed**: Cycles 1-6 (3 major refactorings)
- **Remaining**: Cycles 7-30 (24 refactorings)
- **Estimated Effort**: 15-20 hours
- **Priority**: High (to reach production-ready state)

## Cycle-by-Cycle Breakdown

### PHASE 1: Large Files (Cycles 7-12)

#### Cycle 7: validators.dart (454 lines) ⚠️ OPTIONAL
**Status**: Well-organized, consider skipping
**Alternative**: Add more validation types if needed
- If refactoring: Split into form_validators.dart, security_validators.dart, network_validators.dart

#### Cycle 8: mock_hvac_repository.dart (440 lines) 🔴 HIGH PRIORITY
**Approach**: Extract mock data to separate files
```dart
lib/data/repositories/
  ├── mock_hvac_repository.dart (150 lines - logic only)
  └── mock_data/
      ├── mock_devices.dart (100 lines)
      ├── mock_rooms.dart (80 lines)
      └── mock_schedules.dart (110 lines)
```
**Benefit**: Easier to maintain test data, clear separation

#### Cycle 9: responsive_builder.dart (437 lines) 🔴 HIGH PRIORITY
**Approach**: Extract layout builders
```dart
lib/core/utils/responsive/
  ├── responsive_builder.dart (180 lines - main logic)
  ├── breakpoint_utils.dart (80 lines)
  ├── mobile_layout_builder.dart (90 lines)
  └── tablet_desktop_layout_builder.dart (87 lines)
```

#### Cycle 10: room_preview_card.dart (408 lines) 🔴 HIGH PRIORITY
**Approach**: Extract card sections as separate widgets
```dart
lib/presentation/widgets/room/
  ├── room_preview_card.dart (120 lines - composition)
  ├── room_card_header.dart (80 lines)
  ├── room_card_stats.dart (90 lines)
  └── room_card_controls.dart (118 lines)
```

#### Cycle 11: settings_screen.dart (407 lines) 🔴 HIGH PRIORITY
**Approach**: Extract settings sections
```dart
lib/presentation/pages/settings/
  ├── settings_screen.dart (100 lines - scaffold)
  ├── account_settings_section.dart (100 lines)
  ├── device_settings_section.dart (107 lines)
  └── app_settings_section.dart (100 lines)
```

#### Cycle 12: secure_storage_service.dart (403 lines) 🟡 MEDIUM PRIORITY
**Approach**: Split by functionality
```dart
lib/core/services/storage/
  ├── secure_storage_service.dart (120 lines - interface)
  ├── auth_storage.dart (90 lines - auth tokens)
  ├── user_data_storage.dart (90 lines - user prefs)
  └── device_storage.dart (103 lines - device configs)
```

### PHASE 2: Medium Files (Cycles 13-20)

#### Cycle 13: empty_state_widget.dart (402 lines) 🟡 MEDIUM PRIORITY
**Approach**: Extract factory methods to separate file
```dart
lib/presentation/widgets/common/
  ├── empty_state_widget.dart (180 lines - main widget)
  └── empty_state_presets.dart (222 lines - factory methods)
```

#### Cycle 14: ventilation_schedule_control.dart (396 lines)
Extract schedule UI components:
- schedule_control.dart (150 lines)
- schedule_time_picker.dart (120 lines)
- schedule_day_selector.dart (126 lines)

#### Cycle 15: glassmorphism consolidation (395/394 lines)
**Current**: Duplicate files in lib/core and packages/
**Action**: Delete duplicate, keep one source of truth

#### Cycle 16: room_card_compact.dart (380 lines)
Extract to: card layout, temperature display, status indicator

#### Cycle 17: hvac_unit_model.dart (365 lines)
Split data model logic:
- hvac_unit_model.dart (200 lines - core model)
- hvac_unit_extensions.dart (165 lines - helper methods)

#### Cycle 18: accessibility_utils.dart (364 lines)
Split by category:
- a11y_semantic_utils.dart
- a11y_navigation_utils.dart
- a11y_announcement_utils.dart

#### Cycle 19: web_skeleton_loader.dart (363 lines)
Extract skeleton patterns:
- skeleton_loader.dart (main)
- skeleton_patterns.dart (pre-built patterns)

#### Cycle 20: app_typography.dart (362 lines)
Split by text style category:
- typography.dart (base)
- heading_styles.dart
- body_styles.dart
- button_styles.dart

### PHASE 3: Final Cleanups (Cycles 21-25)

#### Cycle 21-22: home_screen & settings_screen_refactored
Further optimize "refactored" screens:
- Ensure <250 lines each
- Extract any remaining complex widgets
- Add performance optimizations

#### Cycle 23: ventilation_temperature_control_improved (344 lines)
Extract slider, temperature display, mode selector

#### Cycle 24: hvac_error_state.dart (342 lines)
Extract error types and retry logic

#### Cycle 25: decorations.dart (337 lines)
Already refactored in Cycle 6, verify no issues

### PHASE 4: Performance & Quality (Cycles 26-30)

#### Cycle 26: Performance Audit
- Add RepaintBoundary to expensive widgets
- Implement const constructors
- Optimize image loading with caching

#### Cycle 27: Accessibility Audit
- Add Semantics to all interactive elements
- Verify tap targets ≥48x48dp
- Test with screen readers

#### Cycle 28: Responsive Design Verification
- Test all screens at 320w, 768w, 1440w
- Verify no hard-coded dimensions remain
- Test orientation changes

#### Cycle 29: Testing Coverage
- Add widget tests for extracted components
- BLoC tests for business logic
- Integration tests for critical flows

#### Cycle 30: Final Review
- Run dart analyze (0 issues)
- Check TODOs and FIXMEs
- Update documentation
- Performance profiling with DevTools

## Implementation Commands

### For Each Cycle:
```bash
# 1. Analyze file structure
code <file_to_refactor>.dart

# 2. Create new module files
# (Use Write tool or touch command)

# 3. Extract code sections

# 4. Update imports in dependent files

# 5. Verify no errors
dart analyze

# 6. Commit
git add -A
git commit -m "Refactor: Cycle N - <description>"
```

### Testing After Each Cycle:
```bash
# Quick test
flutter test test/specific_test.dart

# Full test suite
flutter test

# Build verification
flutter build apk --debug
```

## Success Metrics

After completing all 30 cycles:
- ✅ Zero files >300 lines (except generated)
- ✅ Code health score >8.5/10
- ✅ Zero analyzer warnings/errors
- ✅ Widget test coverage >70%
- ✅ All screens responsive (mobile/tablet/desktop)
- ✅ WCAG AA accessibility compliance
- ✅ 60 FPS on mid-range devices

## Time Estimates

| Phase | Cycles | Est. Time | Priority |
|-------|--------|-----------|----------|
| Phase 1 | 7-12 | 6-8 hours | 🔴 High |
| Phase 2 | 13-20 | 4-6 hours | 🟡 Medium |
| Phase 3 | 21-25 | 2-3 hours | 🟢 Low |
| Phase 4 | 26-30 | 3-4 hours | 🔴 High |
| **Total** | **24** | **15-21 hours** | |

## Notes for Implementation

1. **Prioritize user-facing components** (Phase 1) over utilities
2. **Maintain backward compatibility** with @deprecated annotations
3. **Test after each refactoring** - don't batch commits
4. **Use feature flags** for UI changes if needed
5. **Document breaking changes** in commit messages
6. **Keep PR sizes reasonable** - max 5 cycles per PR

## Quick Wins (Can be done in parallel)

- Cycle 15: Glassmorphism deduplication (15 min)
- Cycle 25: Decorations verification (already done)
- Delete unused/commented code throughout project
- Run dart fix --apply for auto-fixes

**Created**: 2025-11-08
**Status**: Ready for implementation
**Next Action**: Begin Cycle 7 (or skip to Cycle 8 if validators acceptable)
