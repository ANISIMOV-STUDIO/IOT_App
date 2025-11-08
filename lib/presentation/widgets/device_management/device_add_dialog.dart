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

  /// Show the device add dialog
  static Future<void> show(BuildContext context) {
    return HvacAlertDialog.show(
      context,
      title: AppLocalizations.of(context)!.addDevice,
      contentWidget: const _DeviceAddForm(),
      actions: [], // Actions are handled by the form itself
    );
  }

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
    return const _DeviceAddForm();
  }
}

class _DeviceAddForm extends StatefulWidget {
  const _DeviceAddForm();

  @override
  State<_DeviceAddForm> createState() => _DeviceAddFormState();
}

class _DeviceAddFormState extends State<_DeviceAddForm> {
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
              label: l10n.add,
              onPressed: _handleAddDevice,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacAddressField(AppLocalizations l10n) {
    return HvacTextField(
      controller: _macController,
      labelText: l10n.macAddress,
      hintText: 'XX:XX:XX:XX:XX:XX',
      prefixIcon: Icons.router_rounded,
      textCapitalization: TextCapitalization.characters,
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
    return HvacTextField(
      controller: _nameController,
      labelText: l10n.deviceName,
      hintText: l10n.livingRoom,
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
