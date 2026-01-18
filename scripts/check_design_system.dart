#!/usr/bin/env dart

/// Advanced Design System Checker
///
/// This script performs sophisticated pattern matching and analysis
/// to detect design system violations in the Flutter codebase.
///
/// Usage:
///   dart run scripts/check_design_system.dart

import 'dart:io';

// ANSI color codes
const String red = '\x1B[31m';
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';
const String blue = '\x1B[34m';
const String reset = '\x1B[0m';

/// Files that are excluded from design system checks
const List<String> excludedFiles = [
  'lib/core/theme/app_colors.dart',
  'lib/core/theme/spacing.dart',
  'lib/core/theme/app_radius.dart',
  'lib/core/theme/app_animations.dart',
  'lib/core/theme/app_font_sizes.dart',
  'lib/core/theme/app_icon_sizes.dart',
  'lib/core/theme/app_sizes.dart',
  'lib/core/theme/app_theme.dart',
  'lib/core/theme/breakpoints.dart',
  'lib/core/config/app_constants.dart',
  'lib/core/navigation/app_router.dart',
];

/// Violation types
enum ViolationType {
  hardcodedColor,
  hardcodedSpacing,
  hardcodedRadius,
  hardcodedDuration,
  hardcodedFontSize,
  materialButton,
  improperColorUsage,
  missingAppPrefix,
}

/// Represents a single violation
class Violation {
  final String file;
  final int line;
  final String content;
  final ViolationType type;
  final String suggestion;

  Violation({
    required this.file,
    required this.line,
    required this.content,
    required this.type,
    required this.suggestion,
  });

  @override
  String toString() {
    return '${red}❌ $file:$line$reset\n'
        '   ${content.trim()}\n'
        '   ${yellow}💡 Suggestion: $suggestion$reset';
  }
}

/// Main checker class
class DesignSystemChecker {
  final List<Violation> violations = [];
  int filesScanned = 0;

  /// Check if a file should be excluded
  bool shouldExclude(String filePath) {
    return excludedFiles.any((excluded) => filePath.contains(excluded));
  }

  /// Run all checks
  Future<void> runChecks() async {
    print('${blue}================================================$reset');
    print('${blue}   Advanced Design System Analysis$reset');
    print('${blue}================================================$reset\n');

    // Change to IOT_App directory if needed
    final currentDir = Directory.current.path;
    if (currentDir.endsWith('IOT') && Directory('IOT_App').existsSync()) {
      Directory.current = Directory('IOT_App');
    }

    final libDir = Directory('lib');
    if (!libDir.existsSync()) {
      print('${red}Error: lib directory not found$reset');
      exit(1);
    }

    await _scanDirectory(libDir);

    _printResults();
  }

  /// Scan a directory recursively
  Future<void> _scanDirectory(Directory dir) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        if (shouldExclude(entity.path)) continue;
        if (entity.path.contains('_test.dart')) continue;
        if (entity.path.contains('/test/')) continue;

        await _checkFile(entity);
        filesScanned++;
      }
    }
  }

  /// Check a single file for violations
  Future<void> _checkFile(File file) async {
    final lines = await file.readAsLines();
    final relativePath = file.path.replaceAll('\\', '/');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNumber = i + 1;

      // Skip comments
      if (line.trim().startsWith('//')) continue;

      _checkHardcodedColors(relativePath, lineNumber, line);
      _checkHardcodedSpacing(relativePath, lineNumber, line);
      _checkHardcodedRadius(relativePath, lineNumber, line);
      _checkHardcodedDuration(relativePath, lineNumber, line);
      _checkHardcodedFontSize(relativePath, lineNumber, line);
      _checkMaterialButtons(relativePath, lineNumber, line);
      _checkColorUsage(relativePath, lineNumber, line);
    }
  }

  /// Check for hardcoded Colors.white/black
  void _checkHardcodedColors(String file, int line, String content) {
    if (content.contains('Colors.white') && !content.contains('AppColors.white')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.hardcodedColor,
        suggestion: 'Use AppColors.white instead of Colors.white',
      ));
    }

    if (content.contains('Colors.black') && !content.contains('AppColors.black')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.hardcodedColor,
        suggestion: 'Use AppColors.black instead of Colors.black',
      ));
    }

    // Check for Color(0xFFXXXXXX) patterns
    final colorRegex = RegExp(r'Color\s*\(\s*0x[0-9A-Fa-f]{8}\s*\)');
    if (colorRegex.hasMatch(content) &&
        !content.contains('abstract') &&
        !content.contains('static const')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.hardcodedColor,
        suggestion: 'Define this color in AppColors or use existing color tokens',
      ));
    }
  }

  /// Check for hardcoded spacing values
  void _checkHardcodedSpacing(String file, int line, String content) {
    // Check EdgeInsets with numeric values
    final edgeInsetsRegex = RegExp(
      r'EdgeInsets\.(all|symmetric|only)\s*\([^)]*\d+',
    );

    if (edgeInsetsRegex.hasMatch(content) && !content.contains('AppSpacing.')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.hardcodedSpacing,
        suggestion: 'Use AppSpacing constants (e.g., AppSpacing.md, AppSpacing.sm)',
      ));
    }

    // Check SizedBox with numeric dimensions
    final sizedBoxRegex = RegExp(r'SizedBox\s*\([^)]*(?:height|width)\s*:\s*\d+');
    if (sizedBoxRegex.hasMatch(content) && !content.contains('AppSpacing.')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.hardcodedSpacing,
        suggestion: 'Use AppSpacing constants for SizedBox dimensions',
      ));
    }
  }

  /// Check for hardcoded border radius
  void _checkHardcodedRadius(String file, int line, String content) {
    final radiusRegex = RegExp(r'BorderRadius\.circular\s*\(\s*\d+');

    if (radiusRegex.hasMatch(content) && !content.contains('AppRadius.')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.hardcodedRadius,
        suggestion:
            'Use AppRadius constants (e.g., AppRadius.card, AppRadius.button)',
      ));
    }
  }

  /// Check for hardcoded durations
  void _checkHardcodedDuration(String file, int line, String content) {
    final durationRegex = RegExp(r'Duration\s*\(\s*milliseconds\s*:');

    if (durationRegex.hasMatch(content) &&
        !content.contains('AppDurations.') &&
        !content.contains('abstract class')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.hardcodedDuration,
        suggestion:
            'Use AppDurations constants (e.g., AppDurations.fast, AppDurations.normal)',
      ));
    }
  }

  /// Check for hardcoded font sizes
  void _checkHardcodedFontSize(String file, int line, String content) {
    final fontSizeRegex = RegExp(r'fontSize\s*:\s*\d+');

    if (fontSizeRegex.hasMatch(content) && !content.contains('AppFontSizes.')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.hardcodedFontSize,
        suggestion:
            'Use AppFontSizes constants (e.g., AppFontSizes.body, AppFontSizes.h3)',
      ));
    }
  }

  /// Check for Material button usage
  void _checkMaterialButtons(String file, int line, String content) {
    if (file.contains('breez_button.dart')) return;

    if (content.contains('ElevatedButton')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.materialButton,
        suggestion: 'Use BreezButton instead of ElevatedButton',
      ));
    }

    if (content.contains('TextButton')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.materialButton,
        suggestion: 'Use BreezButton instead of TextButton',
      ));
    }

    if (content.contains('OutlinedButton')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.materialButton,
        suggestion: 'Use BreezButton with variant parameter',
      ));
    }
  }

  /// Check for improper color usage patterns
  void _checkColorUsage(String file, int line, String content) {
    // Check for theme.colorScheme usage instead of BreezColors
    if (content.contains('Theme.of(context).colorScheme') &&
        !file.contains('breez_')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.improperColorUsage,
        suggestion: 'Use BreezColors.of(context) instead of Theme.of(context).colorScheme',
      ));
    }

    // Check for Theme.of(context).primaryColor
    if (content.contains('Theme.of(context).primaryColor')) {
      violations.add(Violation(
        file: file,
        line: line,
        content: content,
        type: ViolationType.improperColorUsage,
        suggestion: 'Use AppColors.accent instead of Theme.of(context).primaryColor',
      ));
    }
  }

  /// Print results
  void _printResults() {
    print('\n${blue}================================================$reset');
    print('${blue}   Analysis Results$reset');
    print('${blue}================================================$reset\n');

    print('${yellow}Files scanned: $filesScanned$reset');
    print('${yellow}Violations found: ${violations.length}$reset\n');

    if (violations.isEmpty) {
      print('${green}✅ All checks passed! No design system violations found.$reset\n');
      return;
    }

    // Group violations by type
    final groupedViolations = <ViolationType, List<Violation>>{};
    for (final violation in violations) {
      groupedViolations.putIfAbsent(violation.type, () => []).add(violation);
    }

    // Print violations by type
    for (final entry in groupedViolations.entries) {
      final type = entry.key;
      final typeViolations = entry.value;

      print('${yellow}${_getTypeDescription(type)} (${typeViolations.length})$reset');
      print('${'─' * 60}');

      for (final violation in typeViolations.take(5)) {
        print(violation);
        print('');
      }

      if (typeViolations.length > 5) {
        print('${yellow}... and ${typeViolations.length - 5} more$reset\n');
      }
    }

    print('${blue}================================================$reset');
    print('${red}❌ Found ${violations.length} design system violation(s)$reset\n');

    print('${yellow}Recommended Actions:$reset');
    print('1. Review DESIGN_SYSTEM_CI.md for guidelines');
    print('2. Use AppSpacing.* for all spacing and padding');
    print('3. Use AppRadius.* for all border radius values');
    print('4. Use AppDurations.* for all animation durations');
    print('5. Use AppFontSizes.* for all font sizes');
    print('6. Use AppColors.* for all colors');
    print('7. Use Breez* components instead of Material buttons\n');

    exit(1);
  }

  String _getTypeDescription(ViolationType type) {
    switch (type) {
      case ViolationType.hardcodedColor:
        return 'Hardcoded Colors';
      case ViolationType.hardcodedSpacing:
        return 'Hardcoded Spacing';
      case ViolationType.hardcodedRadius:
        return 'Hardcoded Border Radius';
      case ViolationType.hardcodedDuration:
        return 'Hardcoded Durations';
      case ViolationType.hardcodedFontSize:
        return 'Hardcoded Font Sizes';
      case ViolationType.materialButton:
        return 'Material Buttons';
      case ViolationType.improperColorUsage:
        return 'Improper Color Usage';
      case ViolationType.missingAppPrefix:
        return 'Missing App Prefix';
    }
  }
}

void main() async {
  final checker = DesignSystemChecker();
  await checker.runChecks();
}
