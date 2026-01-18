#!/bin/bash

# Design System CI - Installation Verification
# Checks that all required files are present and functional

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Design System CI - Verification${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Track status
all_checks_passed=true

# Check 1: Scripts exist
echo -e "${YELLOW}[1/7] Checking scripts...${NC}"
if [ -f "scripts/check_design_system.sh" ]; then
    echo -e "${GREEN}  ✅ check_design_system.sh exists${NC}"
else
    echo -e "${RED}  ❌ check_design_system.sh not found${NC}"
    all_checks_passed=false
fi

if [ -f "scripts/check_design_system.dart" ]; then
    echo -e "${GREEN}  ✅ check_design_system.dart exists${NC}"
else
    echo -e "${RED}  ❌ check_design_system.dart not found${NC}"
    all_checks_passed=false
fi

# Check 2: Scripts are executable
echo ""
echo -e "${YELLOW}[2/7] Checking permissions...${NC}"
if [ -x "scripts/check_design_system.sh" ]; then
    echo -e "${GREEN}  ✅ check_design_system.sh is executable${NC}"
else
    echo -e "${RED}  ❌ check_design_system.sh is not executable${NC}"
    echo -e "     Run: chmod +x scripts/check_design_system.sh"
    all_checks_passed=false
fi

# Check 3: GitHub Actions workflow exists
echo ""
echo -e "${YELLOW}[3/7] Checking GitHub Actions...${NC}"
if [ -f ".github/workflows/design-system-check.yml" ]; then
    echo -e "${GREEN}  ✅ GitHub Actions workflow exists${NC}"
else
    echo -e "${RED}  ❌ GitHub Actions workflow not found${NC}"
    all_checks_passed=false
fi

# Check 4: Documentation exists
echo ""
echo -e "${YELLOW}[4/7] Checking documentation...${NC}"
docs=(
    "DESIGN_SYSTEM_CI.md"
    "DESIGN_SYSTEM_QUICKSTART.md"
    "DESIGN_SYSTEM_CI_SUMMARY.md"
    "DESIGN_SYSTEM_INDEX.md"
    "README_DESIGN_SYSTEM_CI.md"
)

for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        echo -e "${GREEN}  ✅ $doc exists${NC}"
    else
        echo -e "${RED}  ❌ $doc not found${NC}"
        all_checks_passed=false
    fi
done

# Check 5: Theme files exist
echo ""
echo -e "${YELLOW}[5/7] Checking theme files...${NC}"
theme_files=(
    "lib/core/theme/spacing.dart"
    "lib/core/theme/app_radius.dart"
    "lib/core/theme/app_animations.dart"
    "lib/core/theme/app_colors.dart"
)

for file in "${theme_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}  ✅ $file exists${NC}"
    else
        echo -e "${RED}  ❌ $file not found${NC}"
        all_checks_passed=false
    fi
done

# Check 6: Flutter is installed
echo ""
echo -e "${YELLOW}[6/7] Checking Flutter installation...${NC}"
if command -v flutter &> /dev/null; then
    flutter_version=$(flutter --version | head -1)
    echo -e "${GREEN}  ✅ Flutter is installed: $flutter_version${NC}"
else
    echo -e "${RED}  ❌ Flutter not found${NC}"
    echo -e "     Install from: https://flutter.dev/docs/get-started/install"
    all_checks_passed=false
fi

# Check 7: Dart is installed
echo ""
echo -e "${YELLOW}[7/7] Checking Dart installation...${NC}"
if command -v dart &> /dev/null; then
    dart_version=$(dart --version 2>&1 | head -1)
    echo -e "${GREEN}  ✅ Dart is installed: $dart_version${NC}"
else
    echo -e "${RED}  ❌ Dart not found${NC}"
    echo -e "     Should be installed with Flutter"
    all_checks_passed=false
fi

# Summary
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}========================================${NC}"

if [ "$all_checks_passed" = true ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Run: ./scripts/check_design_system.sh"
    echo "2. Read: DESIGN_SYSTEM_QUICKSTART.md"
    echo "3. Start using design tokens in your code"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Some checks failed!${NC}"
    echo ""
    echo "Please fix the issues above and run this script again."
    echo ""
    exit 1
fi
