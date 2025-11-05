#!/usr/bin/env python3
"""
Batch fix remaining .w, .h, .r extensions in Dart files
This handles edge cases like variable.w, property.h, etc.
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

        # Pattern: Fix .h that's not FontWeight
        # Match: something.h but NOT FontWeight.w
        content = re.sub(r'(?<!FontWeight)\.w(?=\s*[,\)\]\};\s])', '.0', content)
        content = re.sub(r'(?<!HvacTypography)\.h(?=\s*[,\)\]\};\s])', '.0', content)

        # Fix properties like height.h, width.w, spacing.h
        content = re.sub(r'\bheight\s*\?\s*\.h\b', 'height', content)
        content = re.sub(r'\bwidth\s*\?\s*\.w\b', 'width', content)
        content = re.sub(r'\bspacing\.h\b', 'spacing', content)
        content = re.sub(r'\bspacing\.w\b', 'spacing', content)
        content = re.sub(r'\belevation\.h\b', 'elevation', content)
        content = re.sub(r'\belevation\.w\b', 'elevation', content)
        content = re.sub(r'\bheight\.h\b', 'height', content)
        content = re.sub(r'\bwidth\.w\b', 'width', content)

        # Fix minTouchTarget.h, minHeight.h, minWidth.w
        content = re.sub(r'\bminTouchTarget\.h\b', 'minTouchTarget', content)
        content = re.sub(r'\bminHeight\.h\b', 'minHeight', content)
        content = re.sub(r'\bminWidth\.w\b', 'minWidth', content)

        # Fix widget.height.h patterns
        content = re.sub(r'widget\.height\.h\b', 'widget.height', content)
        content = re.sub(r'widget\.width\.w\b', 'widget.width', content)

        # Remove remaining enableBlur
        content = re.sub(r',?\s*enableBlur:\s*(?:true|false)\s*,?\s*', ', ', content)

        # Clean up
        content = re.sub(r',\s*,', ',', content)
        content = re.sub(r',\s*\)', ')', content)

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

    # Target specific files that still have errors
    target_files = [
        "core/widgets/responsive_grid.dart",
        "presentation/widgets/common/buttons/accessible_icon_button.dart",
        "presentation/widgets/common/buttons/base_accessible_button.dart",
        "presentation/widgets/common/empty_states/base_empty_state.dart",
        "presentation/widgets/common/glassmorphic/base_glassmorphic_container.dart",
        "presentation/widgets/common/glassmorphic/glassmorphic_card.dart",
        "presentation/widgets/common/glassmorphic/glow_card.dart",
        "presentation/widgets/common/glassmorphic/gradient_card.dart",
        "presentation/widgets/common/glassmorphic/neumorphic_card.dart",
        "presentation/widgets/common/shimmer/skeleton_primitives.dart",
        "presentation/widgets/common/visual_polish/animated_divider.dart",
        "presentation/widgets/common/visual_polish/premium_progress_indicator.dart",
        "presentation/widgets/dashboard/simple_line_chart.dart",
    ]

    fixed_count = 0
    fixed_files = []

    for target in target_files:
        filepath = lib_path / target
        if filepath.exists():
            changed, path = fix_file(filepath)
            if changed:
                fixed_count += 1
                fixed_files.append(path)
                print(f"Fixed: {filepath.relative_to(lib_path)}")

    print(f"\n=== Summary ===")
    print(f"Files fixed: {fixed_count}")

if __name__ == "__main__":
    main()
