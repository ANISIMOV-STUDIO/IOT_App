#!/usr/bin/env python3
"""
Final pass to fix remaining .w, .h, .r, .sw extensions
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

        # Fix expressions like (size * 0.8).r -> (size * 0.8)
        content = re.sub(r'\(([^)]+)\)\.r\b', r'(\1)', content)

        # Fix widget.borderRadius.r -> widget.borderRadius
        content = re.sub(r'\.borderRadius\.r\b', '.borderRadius', content)

        # Fix borderRadius.r -> borderRadius
        content = re.sub(r'\bborderRadius\.r\b', 'borderRadius', content)

        # Fix widget.size.r -> widget.size
        content = re.sub(r'\.size\.r\b', '.size', content)

        # Fix size.r -> size
        content = re.sub(r'\bsize\.r\b', 'size', content)

        # Fix .sw (screenWidth multiplier) -> nothing
        content = re.sub(r'(\d+\.\d+)\.sw\b', r'\1', content)

        # Don't touch color.r (RGB component)
        # This is already protected by word boundary

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
    """Main function"""
    lib_path = Path(r"C:\Projects\IOT_App\lib")

    target_files = [
        "presentation/widgets/common/buttons/accessible_icon_button.dart",
        "presentation/widgets/common/buttons/button_factories.dart",
        "presentation/widgets/common/glassmorphic/glow_card.dart",
        "presentation/widgets/common/glassmorphic/gradient_card.dart",
        "presentation/widgets/common/glassmorphic/neumorphic_card.dart",
        "presentation/widgets/common/shimmer/skeleton_primitives.dart",
        "presentation/widgets/common/shimmer_loading.dart",
        "presentation/widgets/common/visual_polish/status_indicator.dart",
    ]

    fixed_count = 0

    for target in target_files:
        filepath = lib_path / target
        if filepath.exists():
            changed, path = fix_file(filepath)
            if changed:
                fixed_count += 1
                print(f"Fixed: {filepath.relative_to(lib_path)}")

    print(f"\n=== Summary ===")
    print(f"Files fixed: {fixed_count}")

if __name__ == "__main__":
    main()
