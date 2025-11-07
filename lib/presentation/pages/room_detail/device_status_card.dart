/// Device Status Card Component
/// Individual status card for devices
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Device status card widget
class DeviceStatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isOn;
  final ValueChanged<bool> onToggle;

  const DeviceStatusCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isOn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: HvacTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12.0),
          _buildValue(context),
          const SizedBox(height: 4.0),
          _buildLabel(context),
          const SizedBox(height: 12.0),
          _buildToggle(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, size: 24.0, color: HvacColors.textSecondary),
        Text(
          'Mode 2',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.0,
              ),
        ),
      ],
    );
  }

  Widget _buildValue(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12.0,
          ),
      maxLines: 2,
    );
  }

  Widget _buildToggle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isOn ? 'On' : 'Off',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.0,
              ),
        ),
        Semantics(
          label: '${label.replaceAll('\n', ' ')} power switch',
          toggled: isOn,
          child: MouseRegion(
            cursor: kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
            child: Switch(
              value: isOn,
              onChanged: (value) {
                if (!kIsWeb) {
                  HapticFeedback.mediumImpact();
                }
                onToggle(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
