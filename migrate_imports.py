#!/usr/bin/env python3
"""
Import Migration Script
Migrates all theme/animation/utils imports to hvac_ui_kit package
"""

import re
import os
from pathlib import Path

# Base directory
BASE_DIR = Path(r"C:\Projects\IOT_App")
LIB_DIR = BASE_DIR / "lib"

# Files to skip (theme files that will be deleted)
SKIP_FILES = {
    "lib/core/theme/app_theme.dart",
    "lib/core/theme/app_typography.dart",
    "lib/core/theme/spacing.dart",
    "lib/core/theme/app_radius.dart",
    "lib/core/theme/glassmorphism.dart",
    "lib/core/theme/ui_constants.dart",
    "lib/docs/design_system.md",
}

# Import patterns to replace
IMPORT_PATTERNS = [
    (r"import\s+['\"](\.\./)+core/theme/app_theme\.dart['\"];?\s*\n", ""),
    (r"import\s+['\"](\.\./)+core/theme/app_typography\.dart['\"];?\s*\n", ""),
    (r"import\s+['\"](\.\./)+core/theme/spacing\.dart['\"];?\s*\n", ""),
    (r"import\s+['\"](\.\./)+core/theme/app_radius\.dart['\"];?\s*\n", ""),
    (r"import\s+['\"](\.\./)+core/theme/glassmorphism\.dart['\"];?\s*\n", ""),
    (r"import\s+['\"](\.\./)+core/theme/ui_constants\.dart['\"];?\s*\n", ""),
    (r"import\s+['\"](\.\./)+core/animation/smooth_animations\.dart['\"];?\s*\n", ""),
    (r"import\s+['\"](\.\./)+core/utils/adaptive_layout\.dart['\"];?\s*\n", ""),
    (r"import\s+['\"](\.\./)+core/utils/performance_utils\.dart['\"];?\s*\n", ""),
]

# Class name replacements
CLASS_REPLACEMENTS = [
    (r'\bAppTheme\.', 'HvacColors.'),
    (r'\bAppTypography\.', 'HvacTypography.'),
    (r'\bAppSpacing\.', 'HvacSpacing.'),
    (r'\bAppRadius\.', 'HvacRadius.'),
]

# UIConstants mapping - these stay as UIConstants
UI_CONSTANTS_REFS = [
    'UIConstants.',
]

def should_skip_file(file_path):
    """Check if file should be skipped"""
    rel_path = str(file_path.relative_to(BASE_DIR)).replace('\\', '/')
    return rel_path in SKIP_FILES

def has_hvac_ui_kit_import(content):
    """Check if file already has hvac_ui_kit import"""
    return re.search(r"import\s+['\"]package:hvac_ui_kit/hvac_ui_kit\.dart['\"]", content) is not None

def needs_hvac_ui_kit_import(content):
    """Check if file needs hvac_ui_kit import"""
    # Check if any of the patterns exist
    for pattern, _ in IMPORT_PATTERNS:
        if re.search(pattern, content):
            return True
    return False

def add_hvac_ui_kit_import(content):
    """Add hvac_ui_kit import after other package imports"""
    lines = content.split('\n')
    insert_index = -1

    # Find the last package import
    for i, line in enumerate(lines):
        if line.strip().startswith("import 'package:"):
            insert_index = i + 1
        elif line.strip().startswith("import '") and insert_index == -1:
            # First relative import, insert before it
            insert_index = i
            break

    if insert_index == -1:
        # No imports found, insert after library declaration or at top
        for i, line in enumerate(lines):
            if line.strip().startswith('library'):
                insert_index = i + 1
                # Skip empty lines
                while insert_index < len(lines) and not lines[insert_index].strip():
                    insert_index += 1
                break

        if insert_index == -1:
            insert_index = 0

    lines.insert(insert_index, "import 'package:hvac_ui_kit/hvac_ui_kit.dart';")
    return '\n'.join(lines)

def remove_theme_imports(content):
    """Remove all theme-related imports"""
    for pattern, replacement in IMPORT_PATTERNS:
        content = re.sub(pattern, replacement, content, flags=re.MULTILINE)
    return content

def replace_class_names(content):
    """Replace class name references"""
    for pattern, replacement in CLASS_REPLACEMENTS:
        content = re.sub(pattern, replacement, content)
    return content

def migrate_file(file_path):
    """Migrate a single file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            original_content = f.read()

        content = original_content

        # Check if migration is needed
        if not needs_hvac_ui_kit_import(content):
            return False, "No migration needed"

        # Remove theme imports
        content = remove_theme_imports(content)

        # Add hvac_ui_kit import if not already present
        if not has_hvac_ui_kit_import(content):
            content = add_hvac_ui_kit_import(content)

        # Replace class names
        content = replace_class_names(content)

        # Only write if content changed
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True, "Migrated successfully"
        else:
            return False, "No changes needed"

    except Exception as e:
        return False, f"Error: {str(e)}"

def main():
    """Main migration function"""
    print("Starting import migration...")
    print(f"Base directory: {BASE_DIR}")
    print()

    # Find all Dart files
    dart_files = list(LIB_DIR.rglob("*.dart"))

    migrated_count = 0
    skipped_count = 0
    error_count = 0

    for file_path in dart_files:
        if should_skip_file(file_path):
            skipped_count += 1
            continue

        success, message = migrate_file(file_path)

        if success:
            migrated_count += 1
            rel_path = file_path.relative_to(BASE_DIR)
            print(f"[OK] {rel_path}")
        elif "Error" in message:
            error_count += 1
            rel_path = file_path.relative_to(BASE_DIR)
            print(f"[ERROR] {rel_path}: {message}")

    print()
    print("=" * 60)
    print(f"Migration complete!")
    print(f"  Files migrated: {migrated_count}")
    print(f"  Files skipped:  {skipped_count}")
    print(f"  Errors:         {error_count}")
    print("=" * 60)

if __name__ == "__main__":
    main()
