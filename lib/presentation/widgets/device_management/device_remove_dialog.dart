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

class DeviceRemoveDialog {
  /// Show device removal confirmation dialog
  static Future<bool?> show(
    BuildContext context, {
    required String unitId,
    required String name,
    String? macAddress,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await HvacConfirmDialog.show(
      context,
      title: l10n.removeDevice,
      message: l10n.confirmRemoveDevice(name),
      confirmText: l10n.remove,
      cancelText: l10n.cancel,
      dangerous: true,
    );

    if (confirmed == true && context.mounted) {
      try {
        // Remove device using REST API via bloc
        context.read<HvacListBloc>().add(RemoveDeviceEvent(deviceId: unitId));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.deviceRemoved),
              backgroundColor: HvacColors.success,
            ),
          );
        }
        return true;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.error}: $e'),
              backgroundColor: HvacColors.error,
            ),
          );
        }
        return false;
      }
    }

    return confirmed;
  }
}
