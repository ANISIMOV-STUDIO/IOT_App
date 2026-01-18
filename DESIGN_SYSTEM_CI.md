# Design System CI Documentation

This document describes the automated CI checks that enforce the BREEZ design system standards in the IOT_App project.

## Table of Contents

- [Overview](#overview)
- [CI Workflow](#ci-workflow)
- [Running Checks Locally](#running-checks-locally)
- [Violation Types](#violation-types)
- [How to Fix Common Violations](#how-to-fix-common-violations)
- [Excluded Files](#excluded-files)
- [Troubleshooting](#troubleshooting)

---

## Overview

The Design System CI ensures that all code follows the BREEZ design system guidelines by automatically checking for:

1. **Hardcoded values** - Colors, spacing, sizes, durations
2. **Improper component usage** - Material widgets instead of Breez components
3. **Design token violations** - Not using AppSpacing, AppColors, etc.
4. **Best practices** - Consistent patterns across the codebase

### Benefits

- **Consistency** - Ensures all UI follows the same design patterns
- **Maintainability** - Centralized design tokens make theme changes easy
- **Quality** - Catches violations before code review
- **Speed** - Fast automated checks in under 5 minutes

---

## CI Workflow

The CI runs automatically on:

- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Only when Dart files are modified

### Jobs

#### 1. Flutter Analyze (10 min timeout)
- Runs `flutter analyze` to catch syntax and type errors
- Fails on errors, warnings are non-fatal

#### 2. Design System Check (5 min timeout)
- Bash script that checks for hardcoded values
- Fast grep-based pattern matching
- Checks:
  - Colors.white/black usage
  - Hardcoded EdgeInsets
  - Hardcoded BorderRadius
  - Hardcoded Duration
  - Material button usage (ElevatedButton, TextButton)
  - Hardcoded SizedBox dimensions
  - Hardcoded font sizes

#### 3. Advanced Design System Analysis (10 min timeout)
- Dart script with sophisticated pattern matching
- Additional checks:
  - Color(0xFFXXXXXX) patterns
  - Theme.of(context) usage instead of BreezColors
  - Complex regex patterns
  - Groups violations by type

#### 4. Check Summary
- Summarizes all job results
- Provides clear pass/fail status
- Links to this documentation

---

## Running Checks Locally

### Prerequisites

```bash
# Ensure you're in the IOT_App directory
cd IOT_App

# Install Flutter dependencies
flutter pub get
```

### Quick Check (Bash Script)

```bash
# Make script executable (first time only)
chmod +x scripts/check_design_system.sh

# Run the check
./scripts/check_design_system.sh
```

**Windows (Git Bash):**
```bash
bash scripts/check_design_system.sh
```

**Windows (PowerShell):**
```powershell
# Install Git Bash or WSL, then run the bash script
# Alternatively, run the Dart script below
```

### Advanced Check (Dart Script)

```bash
dart run scripts/check_design_system.dart
```

### Run All Checks

```bash
# Analyze + Basic + Advanced
flutter analyze && \
./scripts/check_design_system.sh && \
dart run scripts/check_design_system.dart
```

---

## Violation Types

### 1. Hardcoded Colors

❌ **Bad:**
```dart
Container(color: Colors.white)
Text('Hello', style: TextStyle(color: Colors.black))
Container(color: Color(0xFF00D9C4))
```

✅ **Good:**
```dart
Container(color: AppColors.white)
Text('Hello', style: TextStyle(color: BreezColors.of(context).text))
Container(color: AppColors.accent)
```

### 2. Hardcoded Spacing

❌ **Bad:**
```dart
Padding(padding: EdgeInsets.all(16))
SizedBox(height: 12)
EdgeInsets.symmetric(horizontal: 8, vertical: 4)
```

✅ **Good:**
```dart
Padding(padding: EdgeInsets.all(AppSpacing.md))
SizedBox(height: AppSpacing.sm)
EdgeInsets.symmetric(
  horizontal: AppSpacing.xs,
  vertical: AppSpacing.xxs,
)
```

### 3. Hardcoded Border Radius

❌ **Bad:**
```dart
BorderRadius.circular(12)
BorderRadius.circular(8)
```

✅ **Good:**
```dart
BorderRadius.circular(AppRadius.button)
BorderRadius.circular(AppRadius.chip)
```

### 4. Hardcoded Durations

❌ **Bad:**
```dart
AnimatedContainer(
  duration: Duration(milliseconds: 200),
)
```

✅ **Good:**
```dart
AnimatedContainer(
  duration: AppDurations.normal,
)
```

### 5. Material Buttons

❌ **Bad:**
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Click'),
)
```

✅ **Good:**
```dart
BreezButton(
  onPressed: () {},
  label: 'Click',
)
```

### 6. Hardcoded Font Sizes

❌ **Bad:**
```dart
Text(
  'Title',
  style: TextStyle(fontSize: 24),
)
```

✅ **Good:**
```dart
Text(
  'Title',
  style: TextStyle(fontSize: AppFontSizes.h2),
)
```

### 7. Improper Color Usage

❌ **Bad:**
```dart
final color = Theme.of(context).primaryColor;
final bg = Theme.of(context).colorScheme.surface;
```

✅ **Good:**
```dart
final color = AppColors.accent;
final bg = BreezColors.of(context).card;
```

---

## How to Fix Common Violations

### Spacing Reference

| Constant | Value | Use Case |
|----------|-------|----------|
| `AppSpacing.xxs` | 4px | Micro-spacing (icon-text gap) |
| `AppSpacing.xs` | 8px | Small elements, inner padding |
| `AppSpacing.sm` | 12px | Standard spacing between widgets |
| `AppSpacing.md` | 16px | Card padding, main spacing |
| `AppSpacing.lg` | 20px | Large sections |
| `AppSpacing.lgx` | 24px | Dialog spacing |
| `AppSpacing.xl` | 32px | Between major blocks |
| `AppSpacing.xxl` | 48px | Screen padding |

### Radius Reference

| Constant | Value | Use Case |
|----------|-------|----------|
| `AppRadius.card` | 16px | Cards, major containers |
| `AppRadius.cardSmall` | 12px | Small cards |
| `AppRadius.button` | 12px | Buttons |
| `AppRadius.nested` | 10px | Nested elements inside cards |
| `AppRadius.chip` | 8px | Chips, tags |
| `AppRadius.indicator` | 4px | Small indicators |

### Duration Reference

| Constant | Value | Use Case |
|----------|-------|----------|
| `AppDurations.instant` | 50ms | Micro-interactions |
| `AppDurations.fast` | 150ms | Hover, focus |
| `AppDurations.normal` | 200ms | Standard transitions |
| `AppDurations.medium` | 300ms | Expand/collapse |
| `AppDurations.slow` | 400ms | Complex transitions |

### Font Size Reference

| Constant | Value | Use Case |
|----------|-------|----------|
| `AppFontSizes.h1` | 28px | Page titles |
| `AppFontSizes.h2` | 24px | Section titles |
| `AppFontSizes.h3` | 20px | Card titles |
| `AppFontSizes.h4` | 16px | Subtitles |
| `AppFontSizes.body` | 14px | Body text |
| `AppFontSizes.bodySmall` | 13px | Small body text |
| `AppFontSizes.caption` | 12px | Captions, labels |
| `AppFontSizes.captionSmall` | 11px | Tiny labels |

### Color Reference

```dart
// Static colors (use sparingly, only when theme-independent)
AppColors.accent      // #00D9C4 - Primary teal
AppColors.success     // Green - success states
AppColors.warning     // Amber - warnings
AppColors.critical    // Red - errors
AppColors.white       // Pure white (overlays, etc.)
AppColors.black       // Pure black (overlays, etc.)

// Theme-aware colors (preferred)
final colors = BreezColors.of(context);
colors.text           // Primary text color
colors.textMuted      // Secondary text
colors.card           // Card background
colors.background     // Screen background
colors.border         // Border color
colors.buttonBg       // Button background
```

---

## Excluded Files

The following files are excluded from design system checks (they define the design system):

- `lib/core/theme/app_colors.dart`
- `lib/core/theme/spacing.dart`
- `lib/core/theme/app_radius.dart`
- `lib/core/theme/app_animations.dart`
- `lib/core/theme/app_font_sizes.dart`
- `lib/core/theme/app_icon_sizes.dart`
- `lib/core/theme/app_sizes.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/theme/breakpoints.dart`

Test files (`*_test.dart`, `test/` directory) are also excluded.

---

## Troubleshooting

### Check Fails on CI but Passes Locally

**Cause:** Different line endings (Windows CRLF vs Unix LF)

**Solution:**
```bash
# Configure Git to use LF line endings
git config core.autocrlf input

# Re-checkout files
git rm --cached -r .
git reset --hard
```

### Too Many False Positives

**Cause:** Legitimate use of hardcoded values

**Solutions:**

1. **Add to excluded files** (if it's a theme file)
   - Edit `scripts/check_design_system.sh` and `scripts/check_design_system.dart`
   - Add the file path to the `EXCLUDED_FILES` array

2. **Refactor to use design tokens**
   - Extract the value to appropriate design token file
   - Use the token in your code

3. **Document exception** (rare cases)
   - Add a comment explaining why hardcoded value is needed
   - Example: `// CI: Hardcoded for platform-specific requirement`

### Script Permission Denied (Linux/Mac)

```bash
chmod +x scripts/check_design_system.sh
```

### Dart Script Not Found

```bash
# Ensure you're in IOT_App directory
cd IOT_App

# Ensure dependencies are installed
flutter pub get

# Run with full path
dart run ./scripts/check_design_system.dart
```

### Windows: Bash Script Won't Run

**Option 1: Use Git Bash**
```bash
bash scripts/check_design_system.sh
```

**Option 2: Use WSL (Windows Subsystem for Linux)**
```bash
wsl bash scripts/check_design_system.sh
```

**Option 3: Use Dart Script Only**
```powershell
dart run scripts/check_design_system.dart
```

---

## Best Practices

### Before Committing

1. Run checks locally:
   ```bash
   ./scripts/check_design_system.sh
   ```

2. Fix all violations

3. Run Flutter analyze:
   ```bash
   flutter analyze
   ```

4. Commit and push

### During Development

- Reference `CLAUDE.local.md` for design system guidelines
- Use IDE snippets for common patterns
- Check existing Breez components before creating new ones

### When Adding New Design Tokens

1. Add to appropriate file (`app_colors.dart`, `spacing.dart`, etc.)
2. Document the use case
3. Update this documentation
4. Create examples in the component library

---

## Additional Resources

- **CLAUDE.local.md** - Complete development guide
- **AUDIT_REPORT.md** - Current design system compliance status
- **Breez Components** - `lib/presentation/widgets/breez/`

---

## Support

If you encounter issues with the CI checks:

1. Check this documentation
2. Review `CLAUDE.local.md`
3. Look at existing Breez components for examples
4. Ask in team chat for guidance

---

*Last updated: 2026-01-18*
