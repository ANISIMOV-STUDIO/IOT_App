#!/bin/bash

# Design System Violation Checker
# Checks for hardcoded values and improper usage of design system tokens

set -e

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
total_violations=0

# Files to exclude from checks
EXCLUDED_FILES=(
    "lib/core/theme/app_colors.dart"
    "lib/core/theme/spacing.dart"
    "lib/core/theme/app_radius.dart"
    "lib/core/theme/app_animations.dart"
    "lib/core/theme/app_font_sizes.dart"
    "lib/core/theme/app_icon_sizes.dart"
    "lib/core/theme/app_sizes.dart"
    "lib/core/theme/app_theme.dart"
    "lib/core/theme/breakpoints.dart"
    "lib/core/config/app_constants.dart"
    "lib/core/navigation/app_router.dart"
    # Infrastructure code with computed durations (not UI animations)
    "lib/core/services/retry_service.dart"
)

# Function to check if file should be excluded
should_exclude() {
    local file="$1"
    for excluded in "${EXCLUDED_FILES[@]}"; do
        if [[ "$file" == *"$excluded"* ]]; then
            return 0
        fi
    done
    return 1
}

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   Design System Violations Checker${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Change to IOT_App directory if we're in the root
if [ -d "IOT_App" ]; then
    cd IOT_App
fi

# Check 1: Hardcoded Colors.white and Colors.black (except in allowed files)
echo -e "${YELLOW}[1/8] Checking for hardcoded Colors.white and Colors.black...${NC}"
violation_count=0

while IFS= read -r file; do
    if should_exclude "$file"; then
        continue
    fi

    # Check for Colors.white (but allow Colors.white in comments and AppColors.white)
    matches=$(grep -n "Colors\.white" "$file" | grep -v "//.*Colors\.white" | grep -v "AppColors\.white" || true)
    if [ -n "$matches" ]; then
        echo -e "${RED}  ❌ $file${NC}"
        echo "$matches" | while read -r line; do
            echo -e "     ${RED}Line $(echo $line | cut -d: -f1): Use AppColors.white instead of Colors.white${NC}"
        done
        ((violation_count++))
    fi

    # Check for Colors.black (but allow Colors.black in comments and AppColors.black)
    matches=$(grep -n "Colors\.black" "$file" | grep -v "//.*Colors\.black" | grep -v "AppColors\.black" || true)
    if [ -n "$matches" ]; then
        echo -e "${RED}  ❌ $file${NC}"
        echo "$matches" | while read -r line; do
            echo -e "     ${RED}Line $(echo $line | cut -d: -f1): Use AppColors.black instead of Colors.black${NC}"
        done
        ((violation_count++))
    fi
done < <(find lib -name "*.dart" -type f)

if [ $violation_count -eq 0 ]; then
    echo -e "${GREEN}  ✅ No violations found${NC}"
else
    ((total_violations+=violation_count))
fi
echo ""

# Check 2: Hardcoded EdgeInsets with numeric values
echo -e "${YELLOW}[2/8] Checking for hardcoded EdgeInsets...${NC}"
violation_count=0

while IFS= read -r file; do
    if should_exclude "$file"; then
        continue
    fi

    # Check for EdgeInsets with hardcoded numbers
    # Pattern: EdgeInsets.all(16) or EdgeInsets.only(left: 8, right: 16)
    matches=$(grep -n "EdgeInsets\." "$file" | \
              grep -E "EdgeInsets\.(all|fromLTRB)\s*\(\s*[0-9]" | \
              grep -v "//" || true)

    if [ -n "$matches" ]; then
        echo -e "${RED}  ❌ $file${NC}"
        echo "$matches" | while read -r line; do
            echo -e "     ${RED}Line $(echo $line | cut -d: -f1): Use AppSpacing constants instead of hardcoded values${NC}"
        done
        ((violation_count++))
    fi
done < <(find lib -name "*.dart" -type f)

if [ $violation_count -eq 0 ]; then
    echo -e "${GREEN}  ✅ No violations found${NC}"
else
    ((total_violations+=violation_count))
fi
echo ""

# Check 3: Hardcoded BorderRadius.circular
echo -e "${YELLOW}[3/8] Checking for hardcoded BorderRadius.circular...${NC}"
violation_count=0

while IFS= read -r file; do
    if should_exclude "$file"; then
        continue
    fi

    # Check for BorderRadius.circular with numbers (not AppRadius)
    matches=$(grep -n "BorderRadius\.circular" "$file" | \
              grep -v "AppRadius\." | \
              grep -E "BorderRadius\.circular\s*\(\s*[0-9]+" | \
              grep -v "//.*BorderRadius" || true)

    if [ -n "$matches" ]; then
        echo -e "${RED}  ❌ $file${NC}"
        echo "$matches" | while read -r line; do
            echo -e "     ${RED}Line $(echo $line | cut -d: -f1): Use AppRadius constants instead of hardcoded values${NC}"
        done
        ((violation_count++))
    fi
done < <(find lib -name "*.dart" -type f)

if [ $violation_count -eq 0 ]; then
    echo -e "${GREEN}  ✅ No violations found${NC}"
else
    ((total_violations+=violation_count))
fi
echo ""

# Check 4: Hardcoded Duration(milliseconds:)
echo -e "${YELLOW}[4/8] Checking for hardcoded Duration(milliseconds:)...${NC}"
violation_count=0

while IFS= read -r file; do
    if should_exclude "$file"; then
        continue
    fi

    # Check for Duration(milliseconds:) without AppDurations
    # Exclude const Duration definitions (centralized constants)
    matches=$(grep -n "Duration\s*(\s*milliseconds\s*:" "$file" | \
              grep -v "AppDurations\." | \
              grep -v "static const Duration" | \
              grep -v "const Duration" | \
              grep -v "//.*Duration" || true)

    if [ -n "$matches" ]; then
        echo -e "${RED}  ❌ $file${NC}"
        echo "$matches" | while read -r line; do
            echo -e "     ${RED}Line $(echo $line | cut -d: -f1): Use AppDurations constants instead of hardcoded Duration${NC}"
        done
        ((violation_count++))
    fi
done < <(find lib -name "*.dart" -type f)

if [ $violation_count -eq 0 ]; then
    echo -e "${GREEN}  ✅ No violations found${NC}"
else
    ((total_violations+=violation_count))
fi
echo ""

# Check 5: Material ElevatedButton usage
echo -e "${YELLOW}[5/8] Checking for Material ElevatedButton usage...${NC}"
violation_count=0

while IFS= read -r file; do
    if should_exclude "$file"; then
        continue
    fi

    # Skip test files
    if [[ "$file" == *"_test.dart"* ]] || [[ "$file" == *"/test/"* ]]; then
        continue
    fi

    # Check for ElevatedButton (should use BreezButton)
    # Exclude BreezElevatedButton and other Breez components
    matches=$(grep -n "ElevatedButton" "$file" | \
              grep -v "//.*ElevatedButton" | \
              grep -v "Breez" | \
              grep -v "breez_button.dart" || true)

    if [ -n "$matches" ]; then
        echo -e "${RED}  ❌ $file${NC}"
        echo "$matches" | while read -r line; do
            echo -e "     ${RED}Line $(echo $line | cut -d: -f1): Use BreezButton instead of ElevatedButton${NC}"
        done
        ((violation_count++))
    fi
done < <(find lib -name "*.dart" -type f)

if [ $violation_count -eq 0 ]; then
    echo -e "${GREEN}  ✅ No violations found${NC}"
else
    ((total_violations+=violation_count))
fi
echo ""

# Check 6: Material TextButton usage
echo -e "${YELLOW}[6/8] Checking for Material TextButton usage...${NC}"
violation_count=0

while IFS= read -r file; do
    if should_exclude "$file"; then
        continue
    fi

    # Skip test files
    if [[ "$file" == *"_test.dart"* ]] || [[ "$file" == *"/test/"* ]]; then
        continue
    fi

    # Check for TextButton (should use BreezButton)
    # Exclude BreezTextButton and other Breez components
    matches=$(grep -n "TextButton" "$file" | \
              grep -v "//.*TextButton" | \
              grep -v "Breez" | \
              grep -v "breez_button.dart" || true)

    if [ -n "$matches" ]; then
        echo -e "${RED}  ❌ $file${NC}"
        echo "$matches" | while read -r line; do
            echo -e "     ${RED}Line $(echo $line | cut -d: -f1): Use BreezButton instead of TextButton${NC}"
        done
        ((violation_count++))
    fi
done < <(find lib -name "*.dart" -type f)

if [ $violation_count -eq 0 ]; then
    echo -e "${GREEN}  ✅ No violations found${NC}"
else
    ((total_violations+=violation_count))
fi
echo ""

# Check 7: Hardcoded SizedBox heights/widths
echo -e "${YELLOW}[7/8] Checking for hardcoded SizedBox dimensions...${NC}"
violation_count=0

while IFS= read -r file; do
    if should_exclude "$file"; then
        continue
    fi

    # Check for SizedBox(height: NUMBER) or SizedBox(width: NUMBER)
    matches=$(grep -n "SizedBox\s*(" "$file" | \
              grep -E "(height|width)\s*:\s*[0-9]+" | \
              grep -v "AppSpacing\." | \
              grep -v "//.*SizedBox" || true)

    if [ -n "$matches" ]; then
        echo -e "${RED}  ❌ $file${NC}"
        echo "$matches" | while read -r line; do
            echo -e "     ${RED}Line $(echo $line | cut -d: -f1): Use AppSpacing constants for SizedBox dimensions${NC}"
        done
        ((violation_count++))
    fi
done < <(find lib -name "*.dart" -type f)

if [ $violation_count -eq 0 ]; then
    echo -e "${GREEN}  ✅ No violations found${NC}"
else
    ((total_violations+=violation_count))
fi
echo ""

# Check 8: Hardcoded font sizes
echo -e "${YELLOW}[8/8] Checking for hardcoded font sizes...${NC}"
violation_count=0

while IFS= read -r file; do
    if should_exclude "$file"; then
        continue
    fi

    # Check for fontSize: NUMBER
    # Exclude fontSize: 0 (used for hiding text intentionally)
    matches=$(grep -n "fontSize\s*:\s*[0-9]" "$file" | \
              grep -v "AppFontSizes\." | \
              grep -v "fontSize\s*:\s*0" | \
              grep -v "//.*fontSize" || true)

    if [ -n "$matches" ]; then
        echo -e "${RED}  ❌ $file${NC}"
        echo "$matches" | while read -r line; do
            echo -e "     ${RED}Line $(echo $line | cut -d: -f1): Use AppFontSizes constants instead of hardcoded font sizes${NC}"
        done
        ((violation_count++))
    fi
done < <(find lib -name "*.dart" -type f)

if [ $violation_count -eq 0 ]; then
    echo -e "${GREEN}  ✅ No violations found${NC}"
else
    ((total_violations+=violation_count))
fi
echo ""

# Summary
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   Summary${NC}"
echo -e "${BLUE}================================================${NC}"

if [ $total_violations -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! No design system violations found.${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Found $total_violations file(s) with design system violations.${NC}"
    echo ""
    echo -e "${YELLOW}Please fix the violations above by:${NC}"
    echo "  1. Using AppSpacing.* for all spacing and padding"
    echo "  2. Using AppRadius.* for all border radius values"
    echo "  3. Using AppDurations.* for all animation durations"
    echo "  4. Using AppFontSizes.* for all font sizes"
    echo "  5. Using AppColors.white/black instead of Colors.white/black"
    echo "  6. Using Breez* components instead of Material buttons"
    echo ""
    echo "See DESIGN_SYSTEM_CI.md for detailed guidelines."
    echo ""
    exit 1
fi
