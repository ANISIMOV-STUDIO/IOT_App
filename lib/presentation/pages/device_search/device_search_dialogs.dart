/// Device Search Dialogs
///
/// Dialog components for device search screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/hvac_list/hvac_list_bloc.dart';
import '../../bloc/hvac_list/hvac_list_event.dart';

/// Manual device entry dialog
class ManualDeviceEntryDialog {
  static void show(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    HvacAlertDialog.show(
      context,
      title: l10n.addDevice,
      contentWidget: const _ManualDeviceEntryForm(),
      actions: [], // Actions are handled by the form
    );
  }
}

class _ManualDeviceEntryForm extends StatefulWidget {
  const _ManualDeviceEntryForm();

  @override
  State<_ManualDeviceEntryForm> createState() => _ManualDeviceEntryFormState();
}

class _ManualDeviceEntryFormState extends State<_ManualDeviceEntryForm> {
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
              HvacTextField(
                controller: _macController,
                labelText: l10n.macAddress,
                hintText: 'XX:XX:XX:XX:XX:XX',
                prefixIcon: Icons.router,
              ),
              const SizedBox(height: HvacSpacing.md),
              HvacTextField(
                controller: _nameController,
                labelText: l10n.deviceName,
                hintText: l10n.livingRoom,
                prefixIcon: Icons.label,
              ),
              const SizedBox(height: HvacSpacing.md),
              HvacTextField(
                controller: _locationController,
                labelText: l10n.location,
                hintText: l10n.optional,
                prefixIcon: Icons.location_on,
              ),
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

  void _handleAddDevice() {
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

    context.read<HvacListBloc>().add(
          AddDeviceEvent(
            macAddress: mac,
            name: name,
            location: _locationController.text.isEmpty
                ? null
                : _locationController.text.trim(),
          ),
        );

    Navigator.of(context).pop(); // Close dialog
    Navigator.of(context).pop(); // Close search screen

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.deviceAdded),
        backgroundColor: HvacColors.success,
      ),
    );
  }
}
