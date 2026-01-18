## Description

<!-- Provide a brief description of your changes -->

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Code refactoring
- [ ] Performance improvement
- [ ] Style/UI update

## Related Issue

<!-- Link to the issue this PR addresses -->
Closes #

## Changes Made

<!-- List the key changes made in this PR -->

-
-
-

## Screenshots (if applicable)

<!-- Add screenshots to show UI changes -->

## Design System Compliance

- [ ] I have run `./scripts/check_design_system.sh` locally
- [ ] All design system checks pass
- [ ] I have used design tokens (AppSpacing, AppColors, AppRadius, AppDurations)
- [ ] I have used Breez components instead of Material widgets
- [ ] No hardcoded values (colors, spacing, sizes, durations)

**If violations exist, explain why:**

<!--
If you have any design system violations, explain:
- Why they are necessary
- Why they cannot use design tokens
- What exceptions have been approved
-->

## Testing

- [ ] I have tested these changes locally
- [ ] I have added/updated unit tests
- [ ] I have added/updated widget tests
- [ ] I have tested on multiple devices/screen sizes (if UI changes)

**Tested on:**
- [ ] Web
- [ ] Android
- [ ] iOS (if applicable)

## Code Quality

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have updated documentation (if needed)
- [ ] My changes generate no new warnings
- [ ] `flutter analyze` passes with no issues

## BREEZ Design System

<!-- Reference: CLAUDE.local.md, DESIGN_SYSTEM_CI.md -->

- [ ] Used AppSpacing.* for all spacing and padding
- [ ] Used AppRadius.* for all border radius values
- [ ] Used AppDurations.* for all animation durations
- [ ] Used AppFontSizes.* for all font sizes
- [ ] Used BreezColors.of(context) for theme-aware colors
- [ ] Used AppColors.* for static colors
- [ ] Used Breez* components (BreezButton, BreezCard, etc.)
- [ ] Added Semantics for accessibility (if UI changes)

## Additional Context

<!-- Add any other context about the PR here -->

## Checklist Before Merge

- [ ] All CI checks pass (including design system checks)
- [ ] Code has been reviewed
- [ ] All conversations resolved
- [ ] Branch is up to date with base branch
- [ ] No merge conflicts

---

**For Reviewers:**

Please verify:
1. Design system compliance (CI checks should pass)
2. Code follows BREEZ design patterns
3. Proper use of design tokens
4. Accessibility considerations
5. Performance implications

**Documentation:**
- Quick Start: `DESIGN_SYSTEM_QUICKSTART.md`
- Full Docs: `DESIGN_SYSTEM_CI.md`
- Dev Guide: `CLAUDE.local.md`
