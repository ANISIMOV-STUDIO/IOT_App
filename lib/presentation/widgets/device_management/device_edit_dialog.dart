/// Device Edit Dialog Widget
///
/// Dialog for editing existing HVAC devices
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'device_utils.dart';

class DeviceEditDialog extends StatefulWidget {
  final dynamic unit;

  const DeviceEditDialog({
    super.key,
    required this.unit,
  });

  @override
  State<DeviceEditDialog> createState() => _DeviceEditDialogState();
}

class _DeviceEditDialogState extends State<DeviceEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _macController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.unit.name);
    _locationController = TextEditingController(text: widget.unit.location ?? '');
    _macController = TextEditingController(
      text: widget.unit.macAddress != null
          ? DeviceUtils.formatMacAddress(widget.unit.macAddress!)
          : widget.unit.id,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _macController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? HvacColors.backgroundCard : HvacColors.glassWhite,
      title: Text(l10n.editDevice),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMacAddressField(l10n),
            const SizedBox(height: HvacSpacing.md),
            _buildNameField(l10n),
            const SizedBox(height: HvacSpacing.md),
            _buildLocationField(l10n),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _handleEditDevice,
          style: ElevatedButton.styleFrom(
            backgroundColor: HvacColors.primaryBlue,
            foregroundColor: HvacColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: HvacRadius.mdRadius,
            ),
          ),
          child: Text(l10n.save),
        ),
      ],
    );
  }

  Widget _buildMacAddressField(AppLocalizations l10n) {
    return TextField(
      controller: _macController,
      enabled: false, // MAC address is read-only
      decoration: InputDecoration(
        labelText: l10n.macAddress,
        prefixIcon: const Icon(Icons.router_rounded),
        border: OutlineInputBorder(
          borderRadius: HvacRadius.mdRadius,
        ),
      ),
    );
  }

  Widget _buildNameField(AppLocalizations l10n) {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: l10n.deviceName,
        prefixIcon: const Icon(Icons.label_outline_rounded),
        border: OutlineInputBorder(
          borderRadius: HvacRadius.mdRadius,
        ),
      ),
    );
  }

  Widget _buildLocationField(AppLocalizations l10n) {
    return TextField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: l10n.location,
        hintText: l10n.optional,
        prefixIcon: const Icon(Icons.location_on_outlined),
        border: OutlineInputBorder(
          borderRadius: HvacRadius.mdRadius,
        ),
      ),
    );
  }

  Future<void> _handleEditDevice() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillRequiredFields),
          backgroundColor: HvacColors.error,
        ),
      );
      return;
    }

    try {
      // TODO: Implement UpdateDeviceEvent in HvacListBloc
      // For now, just show success message
      // context.read<HvacListBloc>().add(
      //   UpdateDeviceEvent(
      //     deviceId: widget.unit.id,
      //     name: name,
      //     location: _locationController.text.isEmpty
      //         ? null
      //         : _locationController.text.trim(),
      //   ),
      // );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deviceUpdated),
            backgroundColor: HvacColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            backgroundColor: HvacColors.error,
          ),
        );
      }
    }
  }
}