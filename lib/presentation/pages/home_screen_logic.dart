/// Home Screen Business Logic
///
/// Extracted business logic from HomeScreen following SOLID principles
/// Single Responsibility: Handles all business operations for home screen
library;

import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/di/injection_container.dart';
import '../../core/navigation/app_router.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/ventilation_mode.dart';
import '../../domain/entities/mode_preset.dart';
import '../../domain/entities/automation_rule.dart';
import '../../domain/repositories/hvac_repository.dart';
import '../../domain/usecases/update_ventilation_mode.dart';
import '../../domain/usecases/update_fan_speeds.dart';
import '../../domain/usecases/apply_preset.dart';
import '../../domain/usecases/group_power_control.dart';
import '../../domain/usecases/sync_settings_to_all.dart';
import '../../domain/usecases/apply_schedule_to_all.dart';

/// Business logic handler for Home Screen
class HomeScreenLogic {
  final BuildContext context;
  final Function(String) showSuccessSnackbar;
  final Function(String) showErrorSnackbar;
  final Function(String) showInfoSnackbar;

  HomeScreenLogic({
    required this.context,
    required this.showSuccessSnackbar,
    required this.showErrorSnackbar,
    required this.showInfoSnackbar,
  });

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  // Navigation methods
  void navigateToSettings() => context.goToSettings();
  void navigateToDetails(HvacUnit unit) => context.goToUnitDetail(unit.id);
  void navigateToSchedule(HvacUnit unit) => context.goToSchedule(unit.id);

  // UI Event Handlers
  void handleAddUnit() {
    showInfoSnackbar(l10n.addUnitComingSoon);
  }

  void handleRuleToggled(AutomationRule rule) {
    final status = rule.enabled ? l10n.activated : l10n.deactivated;
    showSuccessSnackbar('${rule.name} $status');
  }

  void handleManageRules() {
    showInfoSnackbar(l10n.manageRules);
  }

  // API Operations with error handling
  Future<void> updatePower(HvacUnit unit, bool power) async {
    try {
      await sl<HvacRepository>().updateUnitEntity(
        unit.copyWith(power: power),
      );
      showSuccessSnackbar(
        power ? '${unit.name} turned on' : '${unit.name} turned off',
      );
    } catch (e) {
      showErrorSnackbar('${l10n.errorChangingPower}: ${_formatError(e)}');
    }
  }

  Future<void> updateVentilationMode(
    HvacUnit unit,
    VentilationMode mode,
  ) async {
    try {
      await sl<UpdateVentilationMode>()(unit.id, mode);
      showSuccessSnackbar('Mode updated to ${mode.displayName}');
    } catch (e) {
      showErrorSnackbar('${l10n.errorUpdatingMode}: ${_formatError(e)}');
    }
  }

  Future<void> updateFanSpeeds(
    HvacUnit unit, {
    int? supplySpeed,
    int? exhaustSpeed,
  }) async {
    try {
      await sl<UpdateFanSpeeds>().call(
        unitId: unit.id,
        supplyFanSpeed: supplySpeed,
        exhaustFanSpeed: exhaustSpeed,
      );
      showSuccessSnackbar('Fan speed updated successfully');
    } catch (e) {
      showErrorSnackbar('${l10n.errorUpdatingFanSpeed}: ${_formatError(e)}');
    }
  }

  Future<void> applyPreset(HvacUnit unit, ModePreset preset) async {
    try {
      await sl<ApplyPreset>()(unit.id, preset);
      showSuccessSnackbar(
        '${l10n.presetApplied}: ${preset.mode.displayName}',
      );
    } catch (e) {
      showErrorSnackbar('${l10n.errorApplyingPreset}: ${_formatError(e)}');
    }
  }

  Future<void> powerAllOn() async {
    try {
      await sl<GroupPowerControl>().powerOnAll();
      showSuccessSnackbar(l10n.allUnitsOn);
    } catch (e) {
      showErrorSnackbar('${l10n.errorTurningOnUnits}: ${_formatError(e)}');
    }
  }

  Future<void> powerAllOff() async {
    try {
      await sl<GroupPowerControl>().powerOffAll();
      showSuccessSnackbar(l10n.allUnitsOff);
    } catch (e) {
      showErrorSnackbar('${l10n.errorTurningOffUnits}: ${_formatError(e)}');
    }
  }

  Future<void> syncSettings(HvacUnit sourceUnit) async {
    try {
      await sl<SyncSettingsToAll>()(sourceUnit.id);
      showSuccessSnackbar(l10n.settingsSynced);
    } catch (e) {
      showErrorSnackbar('${l10n.errorSyncingSettings}: ${_formatError(e)}');
    }
  }

  Future<void> applyScheduleToAll(HvacUnit sourceUnit) async {
    try {
      await sl<ApplyScheduleToAll>()(sourceUnit.id);
      showSuccessSnackbar(l10n.scheduleAppliedToAll);
    } catch (e) {
      showErrorSnackbar('${l10n.errorApplyingSchedule}: ${_formatError(e)}');
    }
  }

  /// Format error messages for user display
  String _formatError(dynamic error) {
    if (error is Exception) {
      final message = error.toString();
      // Remove 'Exception:' prefix if present
      return message.replaceAll('Exception:', '').trim();
    }
    return error.toString();
  }
}
