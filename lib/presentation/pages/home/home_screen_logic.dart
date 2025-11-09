/// Home Screen Logic
///
/// Business logic and operations for home screen
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/navigation/app_router.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/ventilation_mode.dart';
import '../../../domain/entities/mode_preset.dart';
import '../../../domain/entities/automation_rule.dart';
import '../../../domain/repositories/hvac_repository.dart';
import '../../../domain/usecases/update_ventilation_mode.dart';
import '../../../domain/usecases/update_fan_speeds.dart';
import '../../../domain/usecases/apply_preset.dart';
import '../../../domain/usecases/group_power_control.dart';
import '../../../domain/usecases/sync_settings_to_all.dart';
import '../../../domain/usecases/apply_schedule_to_all.dart';
import '../../mixins/snackbar_mixin.dart';

/// Home screen logic mixin
/// Extracts business logic and API operations from the main screen
mixin HomeScreenLogic<T extends StatefulWidget> on State<T>, SnackbarMixin<T> {

  // Event Handlers
  void handleUnitSelection(String? unit, void Function(String?) setState) {
    HapticFeedback.selectionClick();
    setState(unit);
  }

  void handleAddUnit() {
    HapticFeedback.lightImpact();
    showInfoSnackbar(AppLocalizations.of(context)!.addUnitComingSoon);
  }

  void handleRuleToggled(AutomationRule rule) {
    final l10n = AppLocalizations.of(context)!;
    final status = rule.enabled ? l10n.activated : l10n.deactivated;
    showSuccessSnackbar('${rule.name} $status');
  }

  void handleManageRules() {
    showInfoSnackbar(AppLocalizations.of(context)!.manageRules);
  }

  // Navigation
  void navigateToSettings() {
    HapticFeedback.lightImpact();
    context.goToSettings();
  }

  void navigateToDetails(HvacUnit unit) {
    HapticFeedback.lightImpact();
    context.goToUnitDetail(unit.id);
  }

  void navigateToSchedule(HvacUnit unit) {
    context.goToSchedule(unit.id);
  }

  // API Operations
  Future<void> updatePower(HvacUnit unit, bool power) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<HvacRepository>().updateUnitEntity(unit.copyWith(power: power));
    } catch (e) {
      showErrorSnackbar('${l10n.errorChangingPower}: $e');
    }
  }

  Future<void> updateVentilationMode(
      HvacUnit unit, VentilationMode mode) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<UpdateVentilationMode>()(unit.id, mode);
    } catch (e) {
      showErrorSnackbar('${l10n.errorUpdatingMode}: $e');
    }
  }

  Future<void> updateFanSpeeds(HvacUnit unit,
      {int? supplySpeed, int? exhaustSpeed}) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<UpdateFanSpeeds>().call(
        unitId: unit.id,
        supplyFanSpeed: supplySpeed,
        exhaustFanSpeed: exhaustSpeed,
      );
    } catch (e) {
      showErrorSnackbar('${l10n.errorUpdatingFanSpeed}: $e');
    }
  }

  Future<void> applyPreset(HvacUnit unit, ModePreset preset) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<ApplyPreset>()(unit.id, preset);
      showSuccessSnackbar('${l10n.presetApplied}: ${preset.mode.displayName}');
    } catch (e) {
      showErrorSnackbar('${l10n.errorApplyingPreset}: $e');
    }
  }

  Future<void> powerAllOn() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<GroupPowerControl>().powerOnAll();
      showSuccessSnackbar(l10n.allUnitsOn);
    } catch (e) {
      showErrorSnackbar('${l10n.errorTurningOnUnits}: $e');
    }
  }

  Future<void> powerAllOff() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<GroupPowerControl>().powerOffAll();
      showSuccessSnackbar(l10n.allUnitsOff);
    } catch (e) {
      showErrorSnackbar('${l10n.errorTurningOffUnits}: $e');
    }
  }

  Future<void> syncSettings(HvacUnit sourceUnit) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<SyncSettingsToAll>()(sourceUnit.id);
      showSuccessSnackbar(l10n.settingsSynced);
    } catch (e) {
      showErrorSnackbar('${l10n.errorSyncingSettings}: $e');
    }
  }

  Future<void> applyScheduleToAll(HvacUnit sourceUnit) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<ApplyScheduleToAll>()(sourceUnit.id);
      showSuccessSnackbar(l10n.scheduleAppliedToAll);
    } catch (e) {
      showErrorSnackbar('${l10n.errorApplyingSchedule}: $e');
    }
  }
}
