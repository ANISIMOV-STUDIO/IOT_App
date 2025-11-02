/// Home Screen
///
/// Modern smart home dashboard with live room view
/// Refactored from 1,162 lines to ~280 lines
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/di/injection_container.dart';
import '../../core/utils/responsive_utils.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_room_preview.dart';
import '../widgets/home/home_sidebar.dart';
import '../widgets/home/home_automation_section.dart';
import '../widgets/home/home_notifications_panel.dart';
import '../widgets/ventilation_mode_control.dart';
import '../widgets/ventilation_temperature_control.dart';
import '../widgets/ventilation_schedule_control.dart';
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
import 'schedule_screen.dart';
import 'unit_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedUnit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            HomeAppBar(
              selectedUnit: _selectedUnit,
              onUnitSelected: (unit) {
                HapticFeedback.selectionClick();
                setState(() => _selectedUnit = unit);
              },
              onSettingsPressed: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
              onAddUnitPressed: () {
                HapticFeedback.lightImpact();
                _showInfoSnackBar(AppLocalizations.of(context)!.addUnitComingSoon);
              },
            ),

            // Main content with state management
            Expanded(
              child: BlocBuilder<HvacListBloc, HvacListState>(
                builder: (context, state) {
                  if (state is HvacListLoading) return _buildLoadingState();
                  if (state is HvacListError) return _buildErrorState(state.message);
                  if (state is HvacListLoaded) {
                    if (state.units.isEmpty) return _buildEmptyState();
                    return _buildDashboard(context, state.units);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryOrange,
            strokeWidth: 3.w,
          ),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)!.loadingDevices,
            style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: AppTheme.error),
          SizedBox(height: 24.h),
          Text(
            AppLocalizations.of(context)!.connectionError,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => context.read<HvacListBloc>().add(const LoadHvacUnitsEvent()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(AppLocalizations.of(context)!.retry, style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.devices_other, size: 64.sp, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
          SizedBox(height: 24.h),
          Text(
            l10n.noDevices,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.addFirstDevice,
            style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildDashboard(BuildContext context, List<HvacUnit> units) {
    // Initialize selected unit
    if (_selectedUnit == null && units.isNotEmpty) {
      _selectedUnit = units.first.name;
    }

    // Find current unit
    HvacUnit? currentUnit;
    try {
      currentUnit = units.firstWhere(
        (unit) => unit.name == _selectedUnit || unit.location == _selectedUnit,
      );
    } catch (e) {
      currentUnit = units.isNotEmpty ? units.first : null;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      child: ResponsiveUtils.isMobile(context)
          ? _buildMobileLayout(currentUnit, units)
          : _buildDesktopLayout(currentUnit, units),
    );
  }

  Widget _buildMobileLayout(HvacUnit? currentUnit, List<HvacUnit> units) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeRoomPreview(
            currentUnit: currentUnit,
            selectedUnit: _selectedUnit,
            onPowerChanged: (power) => _updatePower(currentUnit!, power),
            onDetailsPressed: currentUnit != null ? () => _navigateToDetails(currentUnit) : null,
          ),
          SizedBox(height: 20.h),
          _buildControlCards(currentUnit),
          SizedBox(height: 20.h),
          HomeAutomationSection(
            currentUnit: currentUnit,
            onRuleToggled: _handleRuleToggled,
            onManageRules: _handleManageRules,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(HvacUnit? currentUnit, List<HvacUnit> units) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main content area
        Expanded(
          flex: 7,
          child: Column(
            children: [
              HomeRoomPreview(
                currentUnit: currentUnit,
                selectedUnit: _selectedUnit,
                onPowerChanged: (power) => _updatePower(currentUnit!, power),
                onDetailsPressed: currentUnit != null ? () => _navigateToDetails(currentUnit) : null,
              ),
              SizedBox(height: 20.h),
              _buildControlCards(currentUnit),
              SizedBox(height: 20.h),
              HomeAutomationSection(
                currentUnit: currentUnit,
                onRuleToggled: _handleRuleToggled,
                onManageRules: _handleManageRules,
              ),
              const Spacer(),
            ],
          ),
        ),

        SizedBox(width: 20.w),

        // Sidebar
        HomeSidebar(
          currentUnit: currentUnit,
          onPresetSelected: (preset) => _applyPreset(currentUnit!, preset),
          onPowerAllOn: _powerAllOn,
          onPowerAllOff: _powerAllOff,
          onSyncSettings: () => _syncSettings(currentUnit!),
          onApplyScheduleToAll: () => _applyScheduleToAll(currentUnit!),
          notificationsPanel: currentUnit != null
              ? HomeNotificationsPanel(unit: currentUnit)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildControlCards(HvacUnit? currentUnit) {
    if (currentUnit == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.deviceNotSelected,
          style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: VentilationModeControl(
            unit: currentUnit,
            onModeChanged: (mode) => _updateVentilationMode(currentUnit, mode),
            onSupplyFanChanged: (speed) => _updateFanSpeeds(currentUnit, supplySpeed: speed),
            onExhaustFanChanged: (speed) => _updateFanSpeeds(currentUnit, exhaustSpeed: speed),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(child: VentilationTemperatureControl(unit: currentUnit)),
        SizedBox(width: 16.w),
        Expanded(
          child: VentilationScheduleControl(
            unit: currentUnit,
            onSchedulePressed: () => _navigateToSchedule(currentUnit),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  // Navigation
  void _navigateToDetails(HvacUnit unit) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UnitDetailScreen(unit: unit)));
  }

  void _navigateToSchedule(HvacUnit unit) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleScreen(unit: unit)));
  }

  // Update methods
  Future<void> _updatePower(HvacUnit unit, bool power) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      await sl<HvacRepository>().updateUnitEntity(unit.copyWith(power: power));
    } catch (e) {
      _showErrorSnackBar('${l10n.errorChangingPower}: $e');
    }
  }

  Future<void> _updateVentilationMode(HvacUnit unit, VentilationMode mode) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      await sl<UpdateVentilationMode>()(unit.id, mode);
    } catch (e) {
      _showErrorSnackBar('${l10n.errorUpdatingMode}: $e');
    }
  }

  Future<void> _updateFanSpeeds(HvacUnit unit, {int? supplySpeed, int? exhaustSpeed}) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      await sl<UpdateFanSpeeds>().call(
        unitId: unit.id,
        supplyFanSpeed: supplySpeed,
        exhaustFanSpeed: exhaustSpeed,
      );
    } catch (e) {
      _showErrorSnackBar('${l10n.errorUpdatingFanSpeed}: $e');
    }
  }

  Future<void> _applyPreset(HvacUnit unit, ModePreset preset) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      await sl<ApplyPreset>()(unit.id, preset);
      _showSuccessSnackBar('${l10n.presetApplied}: ${preset.mode.displayName}');
    } catch (e) {
      _showErrorSnackBar('${l10n.errorApplyingPreset}: $e');
    }
  }

  Future<void> _powerAllOn() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      await sl<GroupPowerControl>().powerOnAll();
      _showSuccessSnackBar(l10n.allUnitsOn);
    } catch (e) {
      _showErrorSnackBar('${l10n.errorTurningOnUnits}: $e');
    }
  }

  Future<void> _powerAllOff() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      await sl<GroupPowerControl>().powerOffAll();
      _showSuccessSnackBar(l10n.allUnitsOff);
    } catch (e) {
      _showErrorSnackBar('${l10n.errorTurningOffUnits}: $e');
    }
  }

  Future<void> _syncSettings(HvacUnit sourceUnit) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      await sl<SyncSettingsToAll>()(sourceUnit.id);
      _showSuccessSnackBar(l10n.settingsSynced);
    } catch (e) {
      _showErrorSnackBar('${l10n.errorSyncingSettings}: $e');
    }
  }

  Future<void> _applyScheduleToAll(HvacUnit sourceUnit) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      await sl<ApplyScheduleToAll>()(sourceUnit.id);
      _showSuccessSnackBar(l10n.scheduleAppliedToAll);
    } catch (e) {
      _showErrorSnackBar('${l10n.errorApplyingSchedule}: $e');
    }
  }

  void _handleRuleToggled(AutomationRule rule) {
    final l10n = AppLocalizations.of(context)!;
    _showSuccessSnackBar('${rule.name} ${rule.enabled ? l10n.activated : l10n.deactivated}');
  }

  void _handleManageRules() {
    _showInfoSnackBar(AppLocalizations.of(context)!.manageRules);
  }

  // Snackbar helpers
  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.info,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
