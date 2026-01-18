# Design System CI - Quick Start Guide

Get started with design system checks in under 2 minutes.

## TL;DR

```bash
# Check your code before committing
./scripts/check_design_system.sh

# Or use the Dart version
dart run scripts/check_design_system.dart
```

## 5-Minute Setup

### 1. First Time Setup

```bash
# Navigate to project
cd IOT_App

# Make script executable (Linux/Mac)
chmod +x scripts/check_design_system.sh

# Install Flutter dependencies
flutter pub get
```

### 2. Run Checks

**Option A: Fast Bash Check (5 seconds)**
```bash
./scripts/check_design_system.sh
```

**Option B: Advanced Dart Check (10 seconds)**
```bash
dart run scripts/check_design_system.dart
```

**Option C: Full Check (30 seconds)**
```bash
flutter analyze && \
./scripts/check_design_system.sh && \
dart run scripts/check_design_system.dart
```

### 3. Fix Violations

Use this cheat sheet to fix common issues:

| Violation | Bad | Good |
|-----------|-----|------|
| Colors | `Colors.white` | `AppColors.white` |
| Spacing | `EdgeInsets.all(16)` | `EdgeInsets.all(AppSpacing.md)` |
| Radius | `BorderRadius.circular(12)` | `BorderRadius.circular(AppRadius.button)` |
| Duration | `Duration(milliseconds: 200)` | `AppDurations.normal` |
| Font Size | `fontSize: 14` | `AppFontSizes.body` |
| Button | `ElevatedButton()` | `BreezButton()` |

## Common Patterns

### Spacing

```dart
// ❌ Bad
Padding(padding: EdgeInsets.all(16))
SizedBox(height: 12)

// ✅ Good
Padding(padding: EdgeInsets.all(AppSpacing.md))
SizedBox(height: AppSpacing.sm)
```

### Colors

```dart
// ❌ Bad
Container(color: Colors.white)
final theme = Theme.of(context).colorScheme;

// ✅ Good
Container(color: AppColors.white)
final colors = BreezColors.of(context);
```

### Border Radius

```dart
// ❌ Bad
BorderRadius.circular(12)

// ✅ Good
BorderRadius.circular(AppRadius.button)
```

### Durations

```dart
// ❌ Bad
AnimatedContainer(
  duration: Duration(milliseconds: 200),
)

// ✅ Good
AnimatedContainer(
  duration: AppDurations.normal,
)
```

### Buttons

```dart
// ❌ Bad
ElevatedButton(
  onPressed: () {},
  child: Text('Click'),
)

// ✅ Good
BreezButton(
  onPressed: () {},
  label: 'Click',
)
```

## Design Token Reference

### Spacing (8px grid)

```dart
AppSpacing.xxs  // 4px  - Icon-text gap
AppSpacing.xs   // 8px  - Inner padding
AppSpacing.sm   // 12px - Widget spacing
AppSpacing.md   // 16px - Card padding
AppSpacing.lg   // 20px - Large sections
AppSpacing.xl   // 32px - Major blocks
AppSpacing.xxl  // 48px - Screen padding
```

### Radius

```dart
AppRadius.card       // 16px - Cards
AppRadius.button     // 12px - Buttons
AppRadius.nested     // 10px - Nested elements
AppRadius.chip       // 8px  - Chips, tags
AppRadius.indicator  // 4px  - Small indicators
```

### Durations

```dart
AppDurations.fast    // 150ms - Hover, focus
AppDurations.normal  // 200ms - Standard
AppDurations.medium  // 300ms - Expand/collapse
```

### Font Sizes

```dart
AppFontSizes.h1     // 28px - Page titles
AppFontSizes.h2     // 24px - Section titles
AppFontSizes.h3     // 20px - Card titles
AppFontSizes.body   // 14px - Body text
AppFontSizes.caption// 12px - Captions
```

### Colors

```dart
// Static colors (theme-independent)
AppColors.accent    // Primary teal
AppColors.success   // Green
AppColors.warning   // Amber
AppColors.critical  // Red
AppColors.white     // Pure white
AppColors.black     // Pure black

// Theme-aware colors (preferred)
final colors = BreezColors.of(context);
colors.text         // Primary text
colors.textMuted    // Secondary text
colors.card         // Card background
colors.background   // Screen background
colors.border       // Border color
```

## Windows Users

### Git Bash (Recommended)
```bash
bash scripts/check_design_system.sh
```

### PowerShell
```powershell
# Use Dart script
dart run scripts/check_design_system.dart
```

### WSL
```bash
wsl bash scripts/check_design_system.sh
```

## IDE Integration

### VS Code

Add to `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Design System Check",
      "type": "shell",
      "command": "./scripts/check_design_system.sh",
      "group": "test",
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    }
  ]
}
```

Run with: `Ctrl+Shift+P` → `Tasks: Run Task` → `Design System Check`

### IntelliJ/Android Studio

1. Go to `Run` → `Edit Configurations`
2. Click `+` → `Shell Script`
3. Name: `Design System Check`
4. Script path: `scripts/check_design_system.sh`
5. Click `OK`

Run with: `Shift+F10` or click the run button

## Pre-commit Hook (Optional)

Add to `.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "Running design system checks..."

if ! ./scripts/check_design_system.sh; then
    echo ""
    echo "❌ Design system checks failed!"
    echo "Fix violations or use 'git commit --no-verify' to skip."
    exit 1
fi

echo "✅ Design system checks passed!"
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## CI/CD

Checks run automatically on:
- Push to `main` or `develop`
- Pull requests to `main` or `develop`

See `.github/workflows/design-system-check.yml`

## Need Help?

- **Full Documentation**: `DESIGN_SYSTEM_CI.md`
- **Development Guide**: `CLAUDE.local.md`
- **Scripts Documentation**: `scripts/README.md`
- **Breez Components**: `lib/presentation/widgets/breez/`

## Quick Checklist

Before committing:

- [ ] Run `./scripts/check_design_system.sh`
- [ ] Fix all violations
- [ ] Run `flutter analyze`
- [ ] Test your changes
- [ ] Commit and push

---

**Pro Tip:** Add an alias to your shell:

```bash
# Add to ~/.bashrc or ~/.zshrc
alias ds-check='./scripts/check_design_system.sh'

# Usage
ds-check
```

---

*Last updated: 2026-01-18*
