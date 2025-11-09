#!/usr/bin/env python3
"""
Color Replacement Script for HVAC UI Kit Migration

Replaces hardcoded Flutter color values with HvacColors from the UI Kit.
"""

import re
import sys
import os
import io
from pathlib import Path
from typing import Dict, List, Tuple

# Fix Windows console encoding for emoji/unicode
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Color mappings from standard Flutter Colors to HvacColors
COLOR_MAPPINGS = {
    # Note: Colors.white, .black, .transparent are NOT replaced
    # because HvacColors uses different names and transparent doesn't exist
    r'Colors\.grey(?!\w)': 'HvacColors.textSecondary',
    r'Colors\.red(?!\w)': 'HvacColors.error',
    r'Colors\.green(?!\w)': 'HvacColors.success',
    r'Colors\.blue(?!\w)': 'HvacColors.info',
    r'Colors\.orange(?!\w)': 'HvacColors.primaryOrange',
}

# Common hex color patterns to HvacColors
HEX_COLOR_MAPPINGS = {
    # Primary colors
    r'Color\(0xFFFF6B35\)': 'HvacColors.primaryOrange',
    r'Color\(0xFF6C63FF\)': 'HvacColors.primary',

    # Background colors
    r'Color\(0xFF1A1D2E\)': 'HvacColors.backgroundDark',
    r'Color\(0xFF16213E\)': 'HvacColors.backgroundDark',
    r'Color\(0xFF0D1B2A\)': 'HvacColors.backgroundDark',

    # Text colors
    r'Color\(0xFFFFFFFF\)': 'HvacColors.white',
    r'Color\(0xFF000000\)': 'HvacColors.black',

    # Transparent
    r'Color\(0x00000000\)': 'HvacColors.transparent',
}

def should_process_file(file_path: Path) -> bool:
    """Check if file should be processed."""
    # Skip generated files
    if 'generated' in file_path.parts:
        return False

    # Skip build directory
    if 'build' in file_path.parts:
        return False

    # Only process Dart files
    if file_path.suffix != '.dart':
        return False

    return True

def add_hvac_ui_kit_import(content: str) -> Tuple[str, bool]:
    """Add hvac_ui_kit import if not present and HvacColors is used."""
    if 'HvacColors' not in content:
        return content, False

    if "import 'package:hvac_ui_kit/hvac_ui_kit.dart';" in content:
        return content, False

    # Find the position to insert the import
    # Insert after other package imports but before relative imports
    lines = content.split('\n')
    insert_pos = 0

    for i, line in enumerate(lines):
        if line.startswith('import '):
            insert_pos = i + 1
            if "'package:flutter/" in line or "'package:hvac_ui_kit/" in line:
                continue
            elif "'package:" in line:
                # Insert before other package imports (after flutter)
                insert_pos = i
                break

    # Insert the import
    lines.insert(insert_pos, "import 'package:hvac_ui_kit/hvac_ui_kit.dart';")

    return '\n'.join(lines), True

def replace_colors_in_file(file_path: Path, dry_run: bool = False) -> Tuple[int, List[str]]:
    """
    Replace hardcoded colors in a single file.

    Returns:
        Tuple of (number of replacements, list of changes made)
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return 0, []

    original_content = content
    changes = []
    replacement_count = 0

    # Replace hex colors first
    for pattern, replacement in HEX_COLOR_MAPPINGS.items():
        matches = list(re.finditer(pattern, content))
        if matches:
            content = re.sub(pattern, replacement, content)
            replacement_count += len(matches)
            changes.append(f"  {pattern} → {replacement} ({len(matches)} times)")

    # Replace Colors.* patterns
    for pattern, replacement in COLOR_MAPPINGS.items():
        matches = list(re.finditer(pattern, content))
        if matches:
            content = re.sub(pattern, replacement, content)
            replacement_count += len(matches)
            changes.append(f"  {pattern} → {replacement} ({len(matches)} times)")

    # Add import if needed
    if replacement_count > 0:
        content, import_added = add_hvac_ui_kit_import(content)
        if import_added:
            changes.insert(0, "  Added hvac_ui_kit import")

    # Write changes if not dry run
    if not dry_run and content != original_content:
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
        except Exception as e:
            print(f"Error writing {file_path}: {e}")
            return 0, []

    return replacement_count, changes

def process_directory(directory: Path, dry_run: bool = False) -> Dict[str, List[str]]:
    """
    Process all Dart files in directory recursively.

    Returns:
        Dictionary mapping file paths to list of changes
    """
    results = {}
    total_files = 0
    total_replacements = 0

    print(f"{'[DRY RUN] ' if dry_run else ''}Processing directory: {directory}")
    print("=" * 80)

    # Find all Dart files
    dart_files = []
    for file_path in directory.rglob('*.dart'):
        if should_process_file(file_path):
            dart_files.append(file_path)

    print(f"Found {len(dart_files)} Dart files to process\n")

    # Process each file
    for file_path in dart_files:
        count, changes = replace_colors_in_file(file_path, dry_run)

        if count > 0:
            total_files += 1
            total_replacements += count
            relative_path = file_path.relative_to(directory)
            results[str(relative_path)] = changes

            print(f"✓ {relative_path}")
            for change in changes:
                print(change)
            print()

    # Print summary
    print("=" * 80)
    print(f"Summary:")
    print(f"  Files modified: {total_files}")
    print(f"  Total replacements: {total_replacements}")

    if dry_run:
        print("\n⚠️  This was a DRY RUN - no files were actually modified")
        print("   Run without --dry-run to apply changes")

    return results

def main():
    """Main entry point."""
    # Check for dry-run flag
    dry_run = '--dry-run' in sys.argv

    # Get project root (assuming script is in scripts/)
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    lib_dir = project_root / 'lib' / 'presentation'

    if not lib_dir.exists():
        print(f"Error: Directory not found: {lib_dir}")
        sys.exit(1)

    # Process the directory
    results = process_directory(lib_dir, dry_run)

    # Exit code based on results
    sys.exit(0 if results else 1)

if __name__ == '__main__':
    main()
