/// Device Add Dialog Widget
///
/// Dialog for adding new HVAC devices
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/hvac_list/hvac_list_bloc.dart';
import '../../bloc/hvac_list/hvac_list_event.dart';

class DeviceAddDialog extends StatefulWidget {
  const DeviceAddDialog({super.key});

  @override
  State<DeviceAddDialog> createState() => _DeviceAddDialogState();
}

class _DeviceAddDialogState extends State<DeviceAddDialog> {
  final _macController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _macController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor:
          isDark ? HvacColors.backgroundCard : HvacColors.glassWhite,
      title: Text(l10n.addDevice),
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
          onPressed: _handleAddDevice,
          style: ElevatedButton.styleFrom(
            backgroundColor: HvacColors.primaryBlue,
            foregroundColor: HvacColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: HvacRadius.mdRadius,
            ),
          ),
          child: Text(l10n.add),
        ),
      ],
    );
  }

  Widget _buildMacAddressField(AppLocalizations l10n) {
    return TextField(
      controller: _macController,
      decoration: InputDecoration(
        labelText: l10n.macAddress,
        hintText: 'XX:XX:XX:XX:XX:XX',
        prefixIcon: const Icon(Icons.router_rounded),
        border: OutlineInputBorder(
          borderRadius: HvacRadius.mdRadius,
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9A-Fa-f:-]'),
        ),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text.toUpperCase();
          return TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        }),
      ],
    );
  }

  Widget _buildNameField(AppLocalizations l10n) {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: l10n.deviceName,
        hintText: l10n.livingRoom,
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

  Future<void> _handleAddDevice() async {
    final l10n = AppLocalizations.of(context)!;
    final mac = _macController.text.trim();
    final name = _nameController.text.trim();

    if (mac.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillRequiredFields),
          backgroundColor: HvacColors.error,
        ),
      );
      return;
    }

    try {
      // Add device using REST API via bloc
      context.read<HvacListBloc>().add(
            AddDeviceEvent(
              macAddress: mac,
              name: name,
              location: _locationController.text.isEmpty
                  ? null
                  : _locationController.text.trim(),
            ),
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deviceAdded),
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
