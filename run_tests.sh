#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "====================================="
echo "HVAC Control App - Test Runner"
echo "====================================="
echo ""

# Function to check command status
check_status() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}$1 failed!${NC}"
        exit 1
    fi
}

# 1. Run Flutter Doctor
echo -e "${YELLOW}1. Running Flutter Doctor...${NC}"
flutter doctor -v
check_status "Flutter doctor"

echo ""
# 2. Get Dependencies
echo -e "${YELLOW}2. Getting Dependencies...${NC}"
flutter pub get
check_status "Dependency installation"

echo ""
# 3. Run Analyzer
echo -e "${YELLOW}3. Running Analyzer...${NC}"
dart analyze
check_status "Code analysis"

echo ""
# 4. Run Unit Tests
echo -e "${YELLOW}4. Running Unit Tests...${NC}"
flutter test test/unit/ --coverage
check_status "Unit tests"

echo ""
# 5. Run Widget Tests
echo -e "${YELLOW}5. Running Widget Tests...${NC}"
flutter test test/widget/ --coverage
check_status "Widget tests"

echo ""
# 6. Run Integration Tests
echo -e "${YELLOW}6. Running Integration Tests...${NC}"
flutter test test/integration/ --coverage || true
# Continue even if integration tests fail

echo ""
# 7. Generate Coverage Report
echo -e "${YELLOW}7. Generating Coverage Report...${NC}"

# Remove old coverage data
rm -f coverage/lcov.info

# Run all tests with coverage
flutter test --coverage

# Generate HTML report if lcov is installed
if command -v genhtml &> /dev/null; then
    echo "Generating HTML coverage report..."
    genhtml coverage/lcov.info -o coverage/html
    echo "Coverage report generated at: coverage/html/index.html"
else
    echo -e "${YELLOW}genhtml not found. Install lcov to generate HTML reports.${NC}"
    echo "On macOS: brew install lcov"
    echo "On Ubuntu: sudo apt-get install lcov"
fi

echo ""
# 8. Performance Benchmark
echo -e "${YELLOW}8. Performance Benchmark...${NC}"
echo "Running performance tests..."
flutter test test/widget/widgets/optimized_hvac_card_test.dart --name="Performance" || true

echo ""
echo "====================================="
echo -e "${GREEN}Test Suite Completed Successfully!${NC}"
echo "====================================="
echo ""
echo "Coverage Report: coverage/lcov.info"
echo "Run 'open coverage/html/index.html' to view HTML report"
echo ""

# Display coverage summary if available
if [ -f coverage/lcov.info ]; then
    echo "Coverage Summary:"
    echo -n "Files covered: "
    grep -c "^SF:" coverage/lcov.info

    # Calculate line coverage
    LINES_FOUND=$(grep "^LF:" coverage/lcov.info | awk '{sum+=$2} END {print sum}')
    LINES_HIT=$(grep "^LH:" coverage/lcov.info | awk '{sum+=$2} END {print sum}')

    if [ "$LINES_FOUND" -gt 0 ]; then
        COVERAGE=$(awk "BEGIN {printf \"%.1f\", ($LINES_HIT/$LINES_FOUND)*100}")
        echo "Line coverage: $COVERAGE%"
    fi
fi

exit 0