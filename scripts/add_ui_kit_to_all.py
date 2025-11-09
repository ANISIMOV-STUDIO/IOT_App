#!/usr/bin/env python3
"""Add UI Kit import to all remaining files"""
import os
import sys
import io

# Fix Windows encoding
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Get all files without UI Kit
no_ui_kit_files = """lib/presentation/bloc/auth/auth_bloc.dart
lib/presentation/bloc/auth/auth_bloc_refactored.dart
lib/presentation/bloc/hvac_detail/hvac_detail_bloc.dart
lib/presentation/bloc/hvac_detail/hvac_detail_event.dart
lib/presentation/bloc/hvac_detail/hvac_detail_state.dart
lib/presentation/bloc/hvac_list/hvac_list_bloc.dart
lib/presentation/bloc/hvac_list/hvac_list_bloc_refactored.dart
lib/presentation/bloc/hvac_list/hvac_list_event.dart
lib/presentation/bloc/hvac_list/hvac_list_state.dart
lib/presentation/pages/home/home_screen_logic.dart
lib/presentation/pages/home_screen_logic.dart
lib/presentation/pages/login_screen.dart
lib/presentation/pages/schedule/schedule_logic.dart
lib/presentation/pages/schedule_screen.dart
lib/presentation/pages/settings/settings_controller.dart
lib/presentation/providers/analytics_data_provider.dart
lib/presentation/widgets/common/app_snackbar.dart
lib/presentation/widgets/common/error_widget.dart
lib/presentation/widgets/common/glassmorphic/glassmorphic.dart
lib/presentation/widgets/common/snackbar/snackbar_types.dart
lib/presentation/widgets/common/tooltip/tooltip.dart
lib/presentation/widgets/device_management/device_utils.dart
lib/presentation/widgets/home/notifications/notification_grouper.dart
lib/presentation/widgets/optimized/list/lazy_list_controller.dart
lib/presentation/widgets/optimized/list/virtual_scroll_controller.dart
lib/presentation/widgets/optimized/optimized_hvac_card.dart
lib/presentation/widgets/qr_scanner/qr_scanner_controller.dart
lib/presentation/widgets/schedule/schedule_components.dart
lib/presentation/widgets/schedule/schedule_model.dart
lib/presentation/widgets/schedule/schedule_widgets.dart
lib/presentation/widgets/temperature/temperature_helpers.dart
lib/presentation/widgets/utils/performance_monitor.dart
lib/presentation/widgets/utils/ripple_painter.dart""".strip().split('\n')

base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
migrated = []
skipped = []

ui_kit_import = "import 'package:hvac_ui_kit/hvac_ui_kit.dart';"

for file_rel in no_ui_kit_files:
    file_path = os.path.join(base_path, file_rel.replace('/', os.sep))

    if not os.path.exists(file_path):
        skipped.append((file_rel, "not found"))
        continue

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Already has UI Kit?
    if ui_kit_import in content:
        skipped.append((file_rel, "already has"))
        continue

    # Just export file?
    lines = content.split('\n')
    first_code_lines = [l.strip() for l in lines[:30] if l.strip() and not l.strip().startswith('///') and not l.strip().startswith('//')]

    # Skip library-only and export-only files
    if len(first_code_lines) <= 3 and all(l.startswith('library') or l.startswith('export') for l in first_code_lines):
        skipped.append((file_rel, "export only"))
        continue

    # Find position to insert
    insert_pos = None
    for i, line in enumerate(lines):
        if line.startswith('import '):
            # Insert after flutter imports, before other package imports
            if "'package:flutter/" in line or "'dart:" in line:
                insert_pos = i + 1
            elif "'package:" in line and insert_pos is None:
                insert_pos = i
                break

    if insert_pos is None:
        # No imports found, skip
        skipped.append((file_rel, "no imports"))
        continue

    # Insert the import
    lines.insert(insert_pos, ui_kit_import)

    # Write back
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    migrated.append(file_rel)

print(f"Migrated: {len(migrated)} files")
for f in migrated:
    print(f"  - {f}")

print(f"\nSkipped: {len(skipped)} files")
for f, reason in skipped:
    print(f"  - {f} ({reason})")

print(f"\n=== SUMMARY ===")
print(f"Total processed: {len(no_ui_kit_files)}")
print(f"Successfully migrated: {len(migrated)}")
print(f"Skipped: {len(skipped)}")
