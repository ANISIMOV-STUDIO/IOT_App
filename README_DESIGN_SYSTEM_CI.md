# Design System CI - Complete Implementation

> **Automated enforcement of BREEZ design system standards**

[![Design System Check](https://github.com/your-org/IOT_App/actions/workflows/design-system-check.yml/badge.svg)](https://github.com/your-org/IOT_App/actions/workflows/design-system-check.yml)

---

## What Is This?

A comprehensive CI system that automatically checks your Flutter code for design system violations, ensuring:

✅ Consistent use of design tokens (spacing, colors, radius, durations)
✅ Proper usage of Breez components
✅ No hardcoded values
✅ Maintainable and themeable codebase

---

## Quick Start (2 Minutes)

```bash
# 1. Navigate to project
cd IOT_App

# 2. Run the check
./scripts/check_design_system.sh

# 3. Fix violations (if any)
# See output for suggestions

# 4. Commit and push
git add .
git commit -m "Fix design system violations"
git push
```

**That's it!** The CI will automatically run on your PR.

---

## What Gets Checked

### Design Tokens

| Instead of... | Use... |
|--------------|--------|
| `EdgeInsets.all(16)` | `EdgeInsets.all(AppSpacing.md)` |
| `BorderRadius.circular(12)` | `BorderRadius.circular(AppRadius.button)` |
| `Duration(milliseconds: 200)` | `AppDurations.normal` |
| `fontSize: 14` | `AppFontSizes.body` |
| `Colors.white` | `AppColors.white` |
| `Color(0xFF00D9C4)` | `AppColors.accent` |

### Components

| Instead of... | Use... |
|--------------|--------|
| `ElevatedButton()` | `BreezButton()` |
| `TextButton()` | `BreezButton()` |
| `Theme.of(context).colorScheme` | `BreezColors.of(context)` |

---

## Available Scripts

### Fast Check (5 seconds)
```bash
./scripts/check_design_system.sh
```

Bash script with grep-based pattern matching. Perfect for quick local checks.

### Advanced Check (10 seconds)
```bash
dart run scripts/check_design_system.dart
```

Dart script with sophisticated regex patterns. Catches more complex violations.

### Full Check (30 seconds)
```bash
flutter analyze && \
./scripts/check_design_system.sh && \
dart run scripts/check_design_system.dart
```

Complete quality check. Recommended before pushing.

---

## Documentation

| Document | Purpose | Time |
|----------|---------|------|
| 📚 [Index](DESIGN_SYSTEM_INDEX.md) | Navigation hub | 2 min |
| 🚀 [Quick Start](DESIGN_SYSTEM_QUICKSTART.md) | Get started fast | 5 min |
| 📖 [Full Docs](DESIGN_SYSTEM_CI.md) | Complete reference | 15 min |
| 📊 [Summary](DESIGN_SYSTEM_CI_SUMMARY.md) | Technical overview | 10 min |
| 🎯 [Dev Guide](CLAUDE.local.md) | Design system rules | 30 min |
| ⚙️ [Scripts](scripts/README.md) | Script documentation | 5 min |

---

## Design Token Reference

### Spacing (8px grid)

```dart
AppSpacing.xxs   // 4px  - Icon-text gap
AppSpacing.xs    // 8px  - Inner padding
AppSpacing.sm    // 12px - Widget spacing
AppSpacing.md    // 16px - Card padding
AppSpacing.lg    // 20px - Large sections
AppSpacing.xl    // 32px - Major blocks
AppSpacing.xxl   // 48px - Screen padding
```

### Border Radius

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
AppDurations.normal  // 200ms - Standard transitions
AppDurations.medium  // 300ms - Expand/collapse
```

### Font Sizes

```dart
AppFontSizes.h1      // 28px - Page titles
AppFontSizes.h2      // 24px - Section titles
AppFontSizes.h3      // 20px - Card titles
AppFontSizes.body    // 14px - Body text
AppFontSizes.caption // 12px - Captions, labels
```

### Colors

```dart
// Static colors (theme-independent)
AppColors.accent     // Primary teal
AppColors.success    // Green
AppColors.warning    // Amber
AppColors.critical   // Red
AppColors.white      // Pure white
AppColors.black      // Pure black

// Theme-aware colors (preferred)
final colors = BreezColors.of(context);
colors.text          // Primary text
colors.textMuted     // Secondary text
colors.card          // Card background
colors.background    // Screen background
colors.border        // Border color
```

---

## Examples

### Before (Violations) ❌

```dart
// Multiple design system violations
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    children: [
      Text(
        'Title',
        style: TextStyle(fontSize: 24),
      ),
      SizedBox(height: 8),
      ElevatedButton(
        onPressed: () {},
        child: Text('Click me'),
      ),
    ],
  ),
)
```

### After (Fixed) ✅

```dart
// Correct usage of design system
Container(
  padding: EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppRadius.button),
  ),
  child: Column(
    children: [
      Text(
        'Title',
        style: TextStyle(fontSize: AppFontSizes.h2),
      ),
      SizedBox(height: AppSpacing.xs),
      BreezButton(
        onPressed: () {},
        label: 'Click me',
      ),
    ],
  ),
)
```

---

## CI Integration

### Automatic Checks

The CI runs automatically on:
- ✅ Push to `main` or `develop`
- ✅ Pull requests to `main` or `develop`
- ✅ Only when `.dart` files change

### What Runs

1. **Flutter Analyze** (2 min) - Syntax and type checking
2. **Design System Check** (30 sec) - Bash grep patterns
3. **Advanced Analysis** (1 min) - Dart regex patterns
4. **Summary** - Overall pass/fail

**Total time:** ~4 minutes

### Pull Request Checks

All PRs must pass design system checks before merge. See the [PR template](.github/pull_request_template.md) for the checklist.

---

## Platform Support

| Platform | Bash Script | Dart Script |
|----------|-------------|-------------|
| **Linux** | ✅ | ✅ |
| **macOS** | ✅ | ✅ |
| **Windows (Git Bash)** | ✅ | ✅ |
| **Windows (WSL)** | ✅ | ✅ |
| **Windows (PowerShell)** | ❌ | ✅ |

**Windows users:** Use Git Bash (recommended) or run Dart script directly.

---

## Workflow Integration

### Pre-commit Hook (Optional)

Add to `.git/hooks/pre-commit`:

```bash
#!/bin/bash
echo "Running design system checks..."

if ! ./scripts/check_design_system.sh; then
    echo "❌ Design system checks failed!"
    echo "Fix violations or use 'git commit --no-verify' to skip."
    exit 1
fi

echo "✅ Design system checks passed!"
```

Make executable: `chmod +x .git/hooks/pre-commit`

### VS Code Tasks

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

### Shell Alias

Add to `~/.bashrc` or `~/.zshrc`:

```bash
alias ds-check='./scripts/check_design_system.sh'
alias ds-check-full='flutter analyze && ./scripts/check_design_system.sh && dart run scripts/check_design_system.dart'
```

Usage: `ds-check` or `ds-check-full`

---

## Troubleshooting

### Permission Denied (Linux/Mac)

```bash
chmod +x scripts/check_design_system.sh
```

### Windows: Cannot Run Bash Script

**Option 1:** Git Bash (recommended)
```bash
bash scripts/check_design_system.sh
```

**Option 2:** WSL
```bash
wsl bash scripts/check_design_system.sh
```

**Option 3:** Dart script only
```bash
dart run scripts/check_design_system.dart
```

### Script Not Found

```bash
# Ensure you're in IOT_App directory
cd IOT_App

# Check if scripts exist
ls scripts/
```

### Too Many False Positives

1. Check if file should be excluded (theme definitions)
2. Verify correct token usage
3. Add file to exclusions if necessary
4. Document exceptions with comments

---

## File Structure

```
IOT_App/
├── .github/
│   ├── workflows/
│   │   └── design-system-check.yml       ← CI workflow
│   └── pull_request_template.md          ← PR checklist
│
├── scripts/
│   ├── check_design_system.sh            ← Bash checker
│   ├── check_design_system.dart          ← Dart checker
│   ├── analysis_options.yaml             ← Linter config
│   ├── test_example_violations.dart      ← Test examples
│   └── README.md                         ← Scripts docs
│
├── lib/core/theme/
│   ├── app_colors.dart                   ← Color tokens
│   ├── spacing.dart                      ← Spacing tokens
│   ├── app_radius.dart                   ← Radius tokens
│   ├── app_animations.dart               ← Duration tokens
│   └── app_font_sizes.dart               ← Font tokens
│
├── DESIGN_SYSTEM_INDEX.md                ← Navigation hub
├── DESIGN_SYSTEM_QUICKSTART.md           ← Quick start
├── DESIGN_SYSTEM_CI.md                   ← Full docs
├── DESIGN_SYSTEM_CI_SUMMARY.md           ← Summary
└── README_DESIGN_SYSTEM_CI.md            ← This file
```

---

## Statistics

| Metric | Value |
|--------|-------|
| **Files created** | 9 documents + 2 scripts |
| **Total size** | ~50 KB documentation |
| **Files scanned** | 310+ Dart files |
| **Check time (local)** | 5-15 seconds |
| **Check time (CI)** | ~4 minutes |
| **Violation types** | 8 categories |
| **Design tokens** | 40+ constants |
| **Platform support** | Linux, macOS, Windows |

---

## Benefits

### For Developers
- ✅ Instant feedback on violations
- ✅ Clear fix suggestions
- ✅ Learn design system through usage
- ✅ No manual review needed

### For the Project
- ✅ Consistent design implementation
- ✅ Easy theme changes
- ✅ Reduced technical debt
- ✅ Better maintainability

### For the Team
- ✅ Shared standards
- ✅ Automated enforcement
- ✅ Quality gate before merge
- ✅ Onboarding tool

---

## Next Steps

1. **Read the Quick Start** - [DESIGN_SYSTEM_QUICKSTART.md](DESIGN_SYSTEM_QUICKSTART.md)
2. **Run your first check** - `./scripts/check_design_system.sh`
3. **Fix any violations** - Use the suggestions in the output
4. **Review full docs** - [DESIGN_SYSTEM_CI.md](DESIGN_SYSTEM_CI.md)
5. **Integrate into workflow** - Add pre-commit hook or IDE task

---

## Support

### Getting Help

1. Check [Documentation Index](DESIGN_SYSTEM_INDEX.md)
2. Read relevant guides
3. Review Breez components for examples
4. Ask in team chat

### Reporting Issues

Create an issue with:
- What you tried to do
- What went wrong
- Error messages
- Platform (Windows/Mac/Linux)

---

## Contributing

### Adding New Checks

See [Scripts Documentation](scripts/README.md) → "Adding New Checks"

### Excluding Files

See [Full Docs](DESIGN_SYSTEM_CI.md) → "Excluded Files"

### Updating Documentation

When design system changes:
1. Update token definitions
2. Update check scripts
3. Update documentation
4. Update examples

---

## License

This CI system is part of the IOT_App project.

---

## Acknowledgments

Built with:
- Flutter & Dart
- Bash scripting
- GitHub Actions
- BREEZ Design System

---

**Ready to start?** Run: `./scripts/check_design_system.sh`

**Need help?** Read: [DESIGN_SYSTEM_QUICKSTART.md](DESIGN_SYSTEM_QUICKSTART.md)

**Want details?** See: [DESIGN_SYSTEM_CI.md](DESIGN_SYSTEM_CI.md)

---

*Implemented: 2026-01-18*
*Version: 1.0.0*
