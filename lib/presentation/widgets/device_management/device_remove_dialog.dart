/// Device Remove Dialog Widget
///
/// Confirmation dialog for removing HVAC devices
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/hvac_list/hvac_list_bloc.dart';
import '../../bloc/hvac_list/hvac_list_event.dart';

class DeviceRemoveDialog extends StatelessWidget {
  final String unitId;
  final String name;
  final String? macAddress;

  const DeviceRemoveDialog({
    super.key,
    required this.unitId,
    required this.name,
    this.macAddress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor:
          isDark ? HvacColors.backgroundCard : HvacColors.glassWhite,
      title: Text(l10n.removeDevice),
      content: Text(l10n.confirmRemoveDevice(name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => _handleRemoveDevice(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: HvacColors.error,
            foregroundColor: HvacColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: HvacRadius.mdRadius,
            ),
          ),
          child: Text(l10n.remove),
        ),
      ],
    );
  }

  Future<void> _handleRemoveDevice(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      // Remove device using REST API via bloc
      context.read<HvacListBloc>().add(RemoveDeviceEvent(deviceId: unitId));

      if (context.mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deviceRemoved),
            backgroundColor: HvacColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
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
