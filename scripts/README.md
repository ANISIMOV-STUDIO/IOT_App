# Scripts Directory

This directory contains utility scripts for the IOT_App project.

## Available Scripts

### Design System Checker

Two complementary scripts for enforcing design system standards:

#### 1. `check_design_system.sh` (Bash)

Fast grep-based checker for common violations.

**Usage:**
```bash
./scripts/check_design_system.sh
```

**Windows:**
```bash
bash scripts/check_design_system.sh
```

**Features:**
- Fast execution (~5 seconds)
- Checks for hardcoded colors, spacing, radius, durations
- Checks for Material button usage
- Checks for hardcoded font sizes
- Clear colored output

#### 2. `check_design_system.dart` (Dart)

Advanced checker with sophisticated pattern matching.

**Usage:**
```bash
dart run scripts/check_design_system.dart
```

**Features:**
- More sophisticated regex matching
- Detects complex patterns (Color(0xFFXXXXXX))
- Checks for improper Theme.of(context) usage
- Groups violations by type
- Provides detailed suggestions

### Other Scripts

#### `generate_proto.bat`

Generates Protocol Buffer files for gRPC communication.

**Usage:**
```cmd
scripts\generate_proto.bat
```

## Running Checks Locally

### Quick Check (Recommended)

```bash
# Bash script - fast
./scripts/check_design_system.sh
```

### Comprehensive Check

```bash
# Run both checks
./scripts/check_design_system.sh && \
dart run scripts/check_design_system.dart
```

### Full Quality Check

```bash
# Analyze + Basic + Advanced
flutter analyze && \
./scripts/check_design_system.sh && \
dart run scripts/check_design_system.dart
```

## CI Integration

These scripts run automatically in GitHub Actions on:
- Push to `main` or `develop`
- Pull requests to `main` or `develop`

See `.github/workflows/design-system-check.yml` for details.

## Adding New Checks

### To Bash Script

1. Open `check_design_system.sh`
2. Add new check section following existing pattern:
   ```bash
   echo -e "${YELLOW}[X/Y] Checking for YOUR_CHECK...${NC}"
   violation_count=0

   while IFS= read -r file; do
       if should_exclude "$file"; then
           continue
       fi

       matches=$(grep -n "YOUR_PATTERN" "$file" | grep -v "ALLOWED_PATTERN" || true)

       if [ -n "$matches" ]; then
           echo -e "${RED}  ❌ $file${NC}"
           echo "$matches" | while read -r line; do
               echo -e "     ${RED}Line $(echo $line | cut -d: -f1): YOUR_MESSAGE${NC}"
           done
           ((violation_count++))
       fi
   done < <(find lib -name "*.dart" -type f)

   if [ $violation_count -eq 0 ]; then
       echo -e "${GREEN}  ✅ No violations found${NC}"
   else
       ((total_violations+=violation_count))
   fi
   ```

### To Dart Script

1. Open `check_design_system.dart`
2. Add new violation type to `ViolationType` enum
3. Create check method:
   ```dart
   void _checkYourPattern(String file, int line, String content) {
       final yourRegex = RegExp(r'YOUR_PATTERN');

       if (yourRegex.hasMatch(content) && !content.contains('ALLOWED')) {
           violations.add(Violation(
               file: file,
               line: line,
               content: content,
               type: ViolationType.yourType,
               suggestion: 'YOUR_SUGGESTION',
           ));
       }
   }
   ```
4. Call check method from `_checkFile()`
5. Add type description to `_getTypeDescription()`

## Excluding Files

To exclude files from checks, add them to the `EXCLUDED_FILES` array in both scripts:

```bash
# check_design_system.sh
EXCLUDED_FILES=(
    "lib/core/theme/app_colors.dart"
    "your/new/file.dart"
)
```

```dart
// check_design_system.dart
const List<String> excludedFiles = [
  'lib/core/theme/app_colors.dart',
  'your/new/file.dart',
];
```

## Troubleshooting

### Permission Denied (Linux/Mac)

```bash
chmod +x scripts/check_design_system.sh
```

### Script Not Found

```bash
# Ensure you're in IOT_App root directory
cd IOT_App

# Check if script exists
ls scripts/
```

### Windows: Cannot Run Bash Script

**Option 1:** Use Git Bash (recommended)
```bash
bash scripts/check_design_system.sh
```

**Option 2:** Use WSL
```bash
wsl bash scripts/check_design_system.sh
```

**Option 3:** Use Dart script only
```bash
dart run scripts/check_design_system.dart
```

### False Positives

If you get false positives:

1. Check if the file should be excluded (theme definition files)
2. Verify you're using correct design tokens
3. Add special handling in the script if needed
4. Document exception with comment in code

## Documentation

For detailed documentation on design system checks, see:
- **DESIGN_SYSTEM_CI.md** - Comprehensive CI documentation
- **CLAUDE.local.md** - Development guidelines
- **.github/workflows/design-system-check.yml** - CI workflow

## Examples

### Example Output (Success)

```
================================================
   Design System Violations Checker
================================================

[1/8] Checking for hardcoded Colors.white and Colors.black...
  ✅ No violations found

[2/8] Checking for hardcoded EdgeInsets...
  ✅ No violations found

...

================================================
   Summary
================================================
✅ All checks passed! No design system violations found.
```

### Example Output (Violations Found)

```
================================================
   Design System Violations Checker
================================================

[1/8] Checking for hardcoded Colors.white and Colors.black...
  ❌ lib/presentation/screens/home_screen.dart
     Line 45: Use AppColors.white instead of Colors.white

[2/8] Checking for hardcoded EdgeInsets...
  ❌ lib/presentation/widgets/custom_card.dart
     Line 23: Use AppSpacing constants instead of hardcoded values

...

================================================
   Summary
================================================
❌ Found 5 file(s) with design system violations.

Please fix the violations above by:
  1. Using AppSpacing.* for all spacing and padding
  2. Using AppRadius.* for all border radius values
  3. Using AppDurations.* for all animation durations
  4. Using AppFontSizes.* for all font sizes
  5. Using AppColors.white/black instead of Colors.white/black
  6. Using Breez* components instead of Material buttons

See DESIGN_SYSTEM_CI.md for detailed guidelines.
```

---

*Last updated: 2026-01-18*
