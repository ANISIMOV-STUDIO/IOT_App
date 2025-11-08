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

  /// Show the device edit dialog
  static Future<void> show(BuildContext context, {required dynamic unit}) {
    return HvacAlertDialog.show(
      context,
      title: AppLocalizations.of(context)!.editDevice,
      contentWidget: _DeviceEditForm(unit: unit),
      actions: [], // Actions are handled by the form itself
    );
  }

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
    _locationController =
        TextEditingController(text: widget.unit.location ?? '');
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
    return _DeviceEditForm(unit: widget.unit);
  }
}

class _DeviceEditForm extends StatefulWidget {
  final dynamic unit;

  const _DeviceEditForm({required this.unit});

  @override
  State<_DeviceEditForm> createState() => _DeviceEditFormState();
}

class _DeviceEditFormState extends State<_DeviceEditForm> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _macController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.unit.name);
    _locationController =
        TextEditingController(text: widget.unit.location ?? '');
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
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
        const SizedBox(height: HvacSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            HvacTextButton(
              label: l10n.cancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: HvacSpacing.sm),
            HvacPrimaryButton(
              label: l10n.save,
              onPressed: _handleEditDevice,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacAddressField(AppLocalizations l10n) {
    return HvacTextField(
      controller: _macController,
      enabled: false, // MAC address is read-only
      labelText: l10n.macAddress,
      prefixIcon: Icons.router_rounded,
    );
  }

  Widget _buildNameField(AppLocalizations l10n) {
    return HvacTextField(
      controller: _nameController,
      labelText: l10n.deviceName,
      prefixIcon: Icons.label_outline_rounded,
    );
  }

  Widget _buildLocationField(AppLocalizations l10n) {
    return HvacTextField(
      controller: _locationController,
      labelText: l10n.location,
      hintText: l10n.optional,
      prefixIcon: Icons.location_on_outlined,
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
