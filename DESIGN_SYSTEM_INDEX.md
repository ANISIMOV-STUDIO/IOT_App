# Design System Documentation Index

Complete guide to the BREEZ design system and CI checks.

---

## Quick Links

| Document | Purpose | Read Time |
|----------|---------|-----------|
| [Quick Start Guide](DESIGN_SYSTEM_QUICKSTART.md) | Get started in 5 minutes | 5 min |
| [Full CI Documentation](DESIGN_SYSTEM_CI.md) | Complete reference | 15 min |
| [Implementation Summary](DESIGN_SYSTEM_CI_SUMMARY.md) | Technical overview | 10 min |
| [Development Guide](CLAUDE.local.md) | BREEZ design system rules | 30 min |
| [Scripts Documentation](scripts/README.md) | Script usage and customization | 5 min |

---

## For Different Roles

### New Developer

**Start here:**
1. Read [Quick Start Guide](DESIGN_SYSTEM_QUICKSTART.md) (5 min)
2. Run your first check: `./scripts/check_design_system.sh`
3. Reference [Development Guide](CLAUDE.local.md) for design tokens

**You'll learn:**
- How to check your code
- What design tokens to use
- How to fix common violations

### Experienced Developer

**Start here:**
1. Review [Full CI Documentation](DESIGN_SYSTEM_CI.md)
2. Read [Implementation Summary](DESIGN_SYSTEM_CI_SUMMARY.md)
3. Integrate checks into your workflow

**You'll learn:**
- Complete violation reference
- Advanced troubleshooting
- CI/CD integration

### Tech Lead / Architect

**Start here:**
1. Read [Implementation Summary](DESIGN_SYSTEM_CI_SUMMARY.md)
2. Review CI workflow: `.github/workflows/design-system-check.yml`
3. Study script implementation in `scripts/`

**You'll learn:**
- Technical architecture
- Performance characteristics
- Customization options
- Maintenance procedures

### Code Reviewer

**Start here:**
1. Reference [Full CI Documentation](DESIGN_SYSTEM_CI.md)
2. Check PR template: `.github/pull_request_template.md`
3. Review [Development Guide](CLAUDE.local.md)

**You'll learn:**
- What to look for in reviews
- Common violations
- Design system patterns

---

## By Task

### I Want To...

#### Run Checks Locally

```bash
# Quick check (5 seconds)
./scripts/check_design_system.sh

# Advanced check (10 seconds)
dart run scripts/check_design_system.dart
```

**Reference:** [Quick Start Guide](DESIGN_SYSTEM_QUICKSTART.md)

#### Fix a Violation

**Reference:** [Full CI Documentation](DESIGN_SYSTEM_CI.md) → "How to Fix Common Violations"

Quick cheat sheet:
- `Colors.white` → `AppColors.white`
- `EdgeInsets.all(16)` → `EdgeInsets.all(AppSpacing.md)`
- `BorderRadius.circular(12)` → `BorderRadius.circular(AppRadius.button)`
- `Duration(milliseconds: 200)` → `AppDurations.normal`

#### Understand Design Tokens

**Reference:** [Development Guide](CLAUDE.local.md) → "СИСТЕМА ДИЗАЙНА BREEZ"

Token categories:
- **Spacing:** `AppSpacing.*` (8px grid)
- **Radius:** `AppRadius.*` (card, button, etc.)
- **Durations:** `AppDurations.*` (fast, normal, medium)
- **Font Sizes:** `AppFontSizes.*` (h1, h2, body, etc.)
- **Colors:** `AppColors.*` and `BreezColors.of(context)`

#### Set Up CI

**Reference:** [Implementation Summary](DESIGN_SYSTEM_CI_SUMMARY.md) → "How to Use → CI/CD"

Already set up! Runs automatically on:
- Push to main/develop
- Pull requests to main/develop

#### Customize Checks

**Reference:** [Scripts Documentation](scripts/README.md) → "Adding New Checks"

Edit:
- `scripts/check_design_system.sh` (bash)
- `scripts/check_design_system.dart` (dart)

#### Exclude Files

**Reference:** [Full CI Documentation](DESIGN_SYSTEM_CI.md) → "Excluded Files"

Edit both:
- `scripts/check_design_system.sh` → `EXCLUDED_FILES` array
- `scripts/check_design_system.dart` → `excludedFiles` list

#### Troubleshoot Issues

**Reference:** [Full CI Documentation](DESIGN_SYSTEM_CI.md) → "Troubleshooting"

Common issues:
- Permission denied
- Script not found
- Windows compatibility
- False positives

---

## Documentation Structure

### Core Documentation

```
IOT_App/
├── DESIGN_SYSTEM_QUICKSTART.md      ← Start here (5 min)
├── DESIGN_SYSTEM_CI.md              ← Complete reference
├── DESIGN_SYSTEM_CI_SUMMARY.md      ← Technical overview
├── DESIGN_SYSTEM_INDEX.md           ← This file
└── CLAUDE.local.md                  ← Development guide
```

### Scripts

```
IOT_App/scripts/
├── check_design_system.sh           ← Fast bash checker
├── check_design_system.dart         ← Advanced dart checker
├── analysis_options.yaml            ← Script linter config
└── README.md                        ← Scripts documentation
```

### CI Configuration

```
IOT_App/.github/
├── workflows/
│   └── design-system-check.yml      ← GitHub Actions workflow
└── pull_request_template.md         ← PR template
```

### Design System Definition

```
IOT_App/lib/core/theme/
├── app_colors.dart                  ← Color tokens
├── spacing.dart                     ← Spacing tokens
├── app_radius.dart                  ← Radius tokens
├── app_animations.dart              ← Duration/curve tokens
├── app_font_sizes.dart              ← Font size tokens
└── app_theme.dart                   ← Theme implementation
```

---

## Learning Path

### Level 1: Basic Usage (30 minutes)

1. ✅ Read [Quick Start Guide](DESIGN_SYSTEM_QUICKSTART.md)
2. ✅ Run `./scripts/check_design_system.sh`
3. ✅ Fix a simple violation
4. ✅ Reference design tokens in [CLAUDE.local.md](CLAUDE.local.md)

**You can now:** Check code and fix basic violations

### Level 2: Advanced Usage (1 hour)

1. ✅ Read [Full CI Documentation](DESIGN_SYSTEM_CI.md)
2. ✅ Run `dart run scripts/check_design_system.dart`
3. ✅ Understand all violation types
4. ✅ Set up IDE integration

**You can now:** Handle complex violations and integrate checks into workflow

### Level 3: Maintenance (2 hours)

1. ✅ Read [Implementation Summary](DESIGN_SYSTEM_CI_SUMMARY.md)
2. ✅ Study script implementation
3. ✅ Review CI workflow
4. ✅ Practice adding custom checks

**You can now:** Customize and maintain the CI system

---

## Design Token Quick Reference

### Spacing (8px grid)

| Token | Value | Use Case |
|-------|-------|----------|
| `AppSpacing.xxs` | 4px | Icon-text gap |
| `AppSpacing.xs` | 8px | Inner padding |
| `AppSpacing.sm` | 12px | Widget spacing |
| `AppSpacing.md` | 16px | Card padding |
| `AppSpacing.lg` | 20px | Large sections |
| `AppSpacing.xl` | 32px | Major blocks |
| `AppSpacing.xxl` | 48px | Screen padding |

### Radius

| Token | Value | Use Case |
|-------|-------|----------|
| `AppRadius.card` | 16px | Cards |
| `AppRadius.button` | 12px | Buttons |
| `AppRadius.nested` | 10px | Nested elements |
| `AppRadius.chip` | 8px | Chips, tags |
| `AppRadius.indicator` | 4px | Indicators |

### Durations

| Token | Value | Use Case |
|-------|-------|----------|
| `AppDurations.fast` | 150ms | Hover, focus |
| `AppDurations.normal` | 200ms | Standard |
| `AppDurations.medium` | 300ms | Expand/collapse |

### Font Sizes

| Token | Value | Use Case |
|-------|-------|----------|
| `AppFontSizes.h1` | 28px | Page titles |
| `AppFontSizes.h2` | 24px | Section titles |
| `AppFontSizes.h3` | 20px | Card titles |
| `AppFontSizes.body` | 14px | Body text |
| `AppFontSizes.caption` | 12px | Captions |

### Colors

```dart
// Static colors
AppColors.accent      // Primary teal
AppColors.success     // Green
AppColors.warning     // Amber
AppColors.critical    // Red
AppColors.white       // Pure white
AppColors.black       // Pure black

// Theme-aware colors
final colors = BreezColors.of(context);
colors.text           // Primary text
colors.textMuted      // Secondary text
colors.card           // Card background
colors.background     // Screen background
colors.border         // Border color
```

---

## FAQ

### Why do we need this?

**Problem:** Inconsistent design implementation leads to:
- Hard-to-maintain code
- Difficult theme changes
- Design drift over time
- Manual code review overhead

**Solution:** Automated checks enforce standards consistently

### How long does it take?

- **Local check:** 5-15 seconds
- **CI check:** 4 minutes
- **Learning curve:** 30 minutes to 2 hours (depending on depth)

### What if I need hardcoded values?

1. **First:** Try to use existing tokens
2. **Second:** Add new token if it's reusable
3. **Last resort:** Add file to exclusions with justification

### Can I bypass checks?

**Locally:** Yes (but don't)
**CI:** No, checks must pass to merge

**Emergency bypass:**
```bash
git commit --no-verify  # Not recommended
```

### How do I add new checks?

See [Scripts Documentation](scripts/README.md) → "Adding New Checks"

### Performance concerns?

Checks are optimized:
- Bash script: ~5 seconds
- Dart script: ~10 seconds
- CI total: ~4 minutes
- Parallelized in CI
- Cached dependencies

---

## Support

### Getting Help

1. **Check this index** for relevant documentation
2. **Read the specific guide** for your task
3. **Review examples** in Breez components
4. **Ask in team chat** if still stuck

### Reporting Issues

If you find issues with the CI system:

1. Check [Full CI Documentation](DESIGN_SYSTEM_CI.md) → "Troubleshooting"
2. Review [Implementation Summary](DESIGN_SYSTEM_CI_SUMMARY.md)
3. Create issue with:
   - What you tried to do
   - What went wrong
   - Error messages
   - Platform (Windows/Mac/Linux)

---

## Updates

### Version History

| Date | Version | Changes |
|------|---------|---------|
| 2026-01-18 | 1.0.0 | Initial implementation |

### Maintenance

Documentation is maintained alongside code. When design system changes:

1. Update token definitions in `lib/core/theme/`
2. Update checks in `scripts/`
3. Update documentation in markdown files
4. Update examples in `CLAUDE.local.md`

---

## Related Resources

- **Breez Components:** `lib/presentation/widgets/breez/`
- **Theme Definition:** `lib/core/theme/`
- **CI Workflows:** `.github/workflows/`
- **Development Guide:** `CLAUDE.local.md`
- **Audit Report:** `AUDIT_REPORT.md`

---

**Questions?** Start with [Quick Start Guide](DESIGN_SYSTEM_QUICKSTART.md)

**Need details?** Read [Full CI Documentation](DESIGN_SYSTEM_CI.md)

**Want to customize?** See [Scripts Documentation](scripts/README.md)

---

*Last updated: 2026-01-18*
