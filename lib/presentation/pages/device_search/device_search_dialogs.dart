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
    final macController = TextEditingController();
    final nameController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.addDevice),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: macController,
                decoration: InputDecoration(
                  labelText: l10n.macAddress,
                  hintText: 'XX:XX:XX:XX:XX:XX',
                  prefixIcon: const Icon(Icons.router),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.deviceName,
                  hintText: l10n.livingRoom,
                  prefixIcon: const Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: l10n.location,
                  hintText: l10n.optional,
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => _handleAddDevice(
              context,
              dialogContext,
              l10n,
              macController,
              nameController,
              locationController,
            ),
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  static void _handleAddDevice(
    BuildContext context,
    BuildContext dialogContext,
    AppLocalizations l10n,
    TextEditingController macController,
    TextEditingController nameController,
    TextEditingController locationController,
  ) {
    final mac = macController.text.trim();
    final name = nameController.text.trim();

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
            location: locationController.text.isEmpty
                ? null
                : locationController.text.trim(),
          ),
        );

    Navigator.of(dialogContext).pop();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.deviceAdded),
        backgroundColor: HvacColors.success,
      ),
    );
  }
}
