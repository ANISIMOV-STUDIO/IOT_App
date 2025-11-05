#!/usr/bin/env python3
"""
Batch fix .w, .h, .r, .sw extensions in Dart files
Removes responsive extensions that are no longer needed
"""

import os
import re
from pathlib import Path

def fix_file(filepath):
    """Fix a single Dart file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        original_content = content

        # Pattern 1: Remove .w extension (e.g., "100.w" -> "100.0")
        content = re.sub(r'(\d+)\.w\b', r'\1.0', content)

        # Pattern 2: Remove .h extension (e.g., "50.h" -> "50.0")
        content = re.sub(r'(\d+)\.h\b', r'\1.0', content)

        # Pattern 3: Remove .r extension (e.g., "12.r" -> "12.0")
        content = re.sub(r'(\d+)\.r\b', r'\1.0', content)

        # Pattern 4: Remove .sw extension (e.g., "0.5.sw" -> "0.5")
        content = re.sub(r'(\d+\.\d+)\.sw\b', r'\1', content)

        # Pattern 5: Remove enableBlur parameter
        content = re.sub(r',?\s*enableBlur:\s*(?:true|false)\s*,?\s*', ', ', content)
        content = re.sub(r'enableBlur:\s*(?:true|false)\s*,\s*', '', content)

        # Pattern 6: Fix HvacSpacing with extensions
        content = re.sub(r'HvacSpacing\.(\w+)\.w\b', r'HvacSpacing.\1', content)
        content = re.sub(r'HvacSpacing\.(\w+)\.h\b', r'HvacSpacing.\1', content)
        content = re.sub(r'HvacSpacing\.(\w+)\.r\b', r'HvacSpacing.\1', content)

        # Pattern 7: Fix HvacRadius with extensions
        content = re.sub(r'HvacRadius\.(\w+)\.r\b', r'HvacRadius.\1', content)

        # Clean up double commas
        content = re.sub(r',\s*,', ',', content)

        # Only write if changes were made
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True, filepath
        return False, None

    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return False, None

def main():
    """Main function to fix all Dart files"""
    lib_path = Path(r"C:\Projects\IOT_App\lib")

    if not lib_path.exists():
        print(f"Error: {lib_path} does not exist")
        return

    dart_files = list(lib_path.rglob("*.dart"))
    print(f"Found {len(dart_files)} Dart files")

    fixed_count = 0
    fixed_files = []

    for filepath in dart_files:
        changed, path = fix_file(filepath)
        if changed:
            fixed_count += 1
            fixed_files.append(path)
            print(f"Fixed: {filepath.relative_to(lib_path)}")

    print(f"\n=== Summary ===")
    print(f"Total files processed: {len(dart_files)}")
    print(f"Files fixed: {fixed_count}")
    print(f"Files unchanged: {len(dart_files) - fixed_count}")

    if fixed_files:
        print(f"\nFixed files:")
        for f in fixed_files[:20]:  # Show first 20
            print(f"  - {f.relative_to(lib_path)}")
        if len(fixed_files) > 20:
            print(f"  ... and {len(fixed_files) - 20} more")

if __name__ == "__main__":
    main()
