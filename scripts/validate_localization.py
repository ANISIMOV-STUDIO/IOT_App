#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Validation script for localization files
Ensures ARB files are synchronized and properly formatted
"""

import json
import sys
import io
from pathlib import Path
from typing import Dict, Set, List, Tuple

# Set UTF-8 encoding for Windows console
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

def load_arb(file_path: Path) -> Dict:
    """Load ARB file and return as dictionary"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def get_translation_keys(arb_data: Dict) -> Set[str]:
    """Extract translation keys (excluding metadata keys starting with @)"""
    return {k for k in arb_data.keys() if not k.startswith('@')}

def check_synchronization(ru_arb: Dict, en_arb: Dict) -> Tuple[bool, List[str]]:
    """Check if Russian and English ARB files are synchronized"""
    ru_keys = get_translation_keys(ru_arb)
    en_keys = get_translation_keys(en_arb)

    errors = []

    # Check for missing keys
    missing_in_ru = en_keys - ru_keys
    missing_in_en = ru_keys - en_keys

    if missing_in_ru:
        errors.append(f"❌ Keys missing in Russian ARB: {sorted(missing_in_ru)[:10]}")
        if len(missing_in_ru) > 10:
            errors.append(f"   ... and {len(missing_in_ru) - 10} more")

    if missing_in_en:
        errors.append(f"❌ Keys missing in English ARB: {sorted(missing_in_en)[:10]}")
        if len(missing_in_en) > 10:
            errors.append(f"   ... and {len(missing_in_en) - 10} more")

    return len(errors) == 0, errors

def check_forbidden_languages(ru_arb: Dict, en_arb: Dict) -> Tuple[bool, List[str]]:
    """Check for forbidden language references (Chinese, German)"""
    # Check for exact key names or standalone references
    forbidden_exact_keys = ['chinese', 'german', 'zh', 'de']
    forbidden_in_values = ['中文', 'deutsch']
    errors = []

    all_keys = get_translation_keys(ru_arb) | get_translation_keys(en_arb)
    all_values = []

    for arb in [ru_arb, en_arb]:
        all_values.extend([v for k, v in arb.items() if not k.startswith('@') and isinstance(v, str)])

    # Check for exact forbidden keys
    for keyword in forbidden_exact_keys:
        if keyword in all_keys or keyword.lower() in all_keys:
            errors.append(f"❌ Forbidden language key found: '{keyword}'")

    # Check for forbidden language names in values
    for keyword in forbidden_in_values:
        matching_values = [v for v in all_values if keyword in v]
        if matching_values:
            errors.append(f"❌ Forbidden language reference found in values: '{keyword}'")

    return len(errors) == 0, errors

def check_metadata_presence(arb_data: Dict) -> Tuple[bool, List[str]]:
    """Check if metadata (@key) exists for all translation keys"""
    translation_keys = get_translation_keys(arb_data)
    errors = []

    missing_metadata = []
    for key in translation_keys:
        metadata_key = f"@{key}"
        if metadata_key not in arb_data:
            missing_metadata.append(key)

    if missing_metadata:
        errors.append(f"⚠️  Missing metadata for {len(missing_metadata)} keys")
        errors.append(f"   First 5: {missing_metadata[:5]}")

    return len(errors) == 0, errors

def validate_localization(project_root: Path) -> int:
    """Main validation function"""
    print("🔍 Validating localization files...\n")

    # Paths
    ru_path = project_root / 'lib' / 'l10n' / 'app_ru.arb'
    en_path = project_root / 'lib' / 'l10n' / 'app_en.arb'

    # Check file existence
    if not ru_path.exists():
        print(f"❌ Russian ARB file not found: {ru_path}")
        return 1
    if not en_path.exists():
        print(f"❌ English ARB file not found: {en_path}")
        return 1

    print(f"✅ Found Russian ARB: {ru_path}")
    print(f"✅ Found English ARB: {en_path}\n")

    # Load files
    try:
        ru_arb = load_arb(ru_path)
        en_arb = load_arb(en_path)
    except json.JSONDecodeError as e:
        print(f"❌ JSON parsing error: {e}")
        return 1

    # Get statistics
    ru_keys = get_translation_keys(ru_arb)
    en_keys = get_translation_keys(en_arb)

    print(f"📊 Statistics:")
    print(f"   Russian ARB: {len(ru_arb)} total entries, {len(ru_keys)} translation keys")
    print(f"   English ARB: {len(en_arb)} total entries, {len(en_keys)} translation keys\n")

    # Run checks
    all_passed = True

    # Check 1: Synchronization
    print("1️⃣  Checking synchronization...")
    passed, errors = check_synchronization(ru_arb, en_arb)
    if passed:
        print("   ✅ All keys are synchronized")
    else:
        print("   ❌ Synchronization issues found:")
        for error in errors:
            print(f"      {error}")
        all_passed = False
    print()

    # Check 2: Forbidden languages
    print("2️⃣  Checking for forbidden language references...")
    passed, errors = check_forbidden_languages(ru_arb, en_arb)
    if passed:
        print("   ✅ No forbidden language references found")
    else:
        print("   ❌ Forbidden language references found:")
        for error in errors:
            print(f"      {error}")
        all_passed = False
    print()

    # Check 3: Metadata (warning only)
    print("3️⃣  Checking metadata presence...")
    ru_meta_ok, ru_errors = check_metadata_presence(ru_arb)
    en_meta_ok, en_errors = check_metadata_presence(en_arb)

    if ru_meta_ok and en_meta_ok:
        print("   ✅ All translation keys have metadata")
    else:
        if not ru_meta_ok:
            print("   Russian ARB:")
            for error in ru_errors:
                print(f"      {error}")
        if not en_meta_ok:
            print("   English ARB:")
            for error in en_errors:
                print(f"      {error}")
    print()

    # Final result
    if all_passed:
        print("✅ All critical checks passed!")
        print("\n📝 Next steps:")
        print("   1. Run: flutter gen-l10n")
        print("   2. Run: flutter run")
        print("   3. Test language switching in Settings")
        return 0
    else:
        print("❌ Some checks failed. Please fix the issues above.")
        return 1

if __name__ == '__main__':
    # Get project root (script is in scripts/ directory)
    script_dir = Path(__file__).parent
    project_root = script_dir.parent

    sys.exit(validate_localization(project_root))
