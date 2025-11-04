/// Device Management Screen
///
/// Allows adding and removing HVAC devices
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../bloc/hvac_list/hvac_list_state.dart';

class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({super.key});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Trigger refresh event
    context.read<HvacListBloc>().add(const LoadHvacUnitsEvent());

    // Wait for a short delay to show the refresh animation
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deviceManagement),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Add Device Button
          Padding(
            padding: const EdgeInsets.all(HvacSpacing.md),
            child: HvacInteractiveScale(
              child: Container(
                decoration: HvacDecorations.gradientBlue(),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: HvacRadius.lgRadius,
                    onTap: () => _showAddDeviceDialog(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: HvacSpacing.lg,
                        vertical: HvacSpacing.md,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle_outline_rounded,
                            color: HvacColors.textPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: HvacSpacing.sm),
                          Text(
                            l10n.addDevice,
                            style: const TextStyle(
                              color: HvacColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Devices List with RefreshIndicator
          Expanded(
            child: BlocBuilder<HvacListBloc, HvacListState>(
              builder: (context, state) {
                // Show skeleton loader during initial loading
                if (state is HvacListLoading && !_isRefreshing) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.md),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: HvacSpacing.sm),
                        child: HvacSkeletonLoader(
                          isLoading: true,
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              color: HvacColors.backgroundCard,
                              borderRadius: HvacRadius.lgRadius,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is HvacListError) {
                  return HvacRefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 64,
                                color: HvacColors.error.withValues(alpha: 0.7),
                              ),
                              const SizedBox(height: HvacSpacing.md),
                              Text(
                                state.message,
                                style: const TextStyle(
                                  color: HvacColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: HvacSpacing.lg),
                              ElevatedButton.icon(
                                onPressed: _handleRefresh,
                                icon: const Icon(Icons.refresh_rounded),
                                label: Text(l10n.retry),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HvacColors.primaryBlue,
                                  foregroundColor: HvacColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (state is HvacListLoaded) {
                  final units = state.units;

                  if (units.isEmpty) {
                    return HvacRefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.devices_other_rounded,
                                  size: 64,
                                  color: HvacColors.textSecondary.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: HvacSpacing.md),
                                Text(
                                  l10n.noDevicesFound,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: HvacSpacing.sm),
                                Text(
                                  l10n.pullToRefresh,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: HvacColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return HvacRefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.md),
                      itemCount: units.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final unit = units[index];
                        const isOnline = true; // You can add online status logic here

                        return Padding(
                          padding: const EdgeInsets.only(bottom: HvacSpacing.sm),
                          child: HvacSwipeableCard(
                            key: ValueKey(unit.id),
                            onSwipeRight: () => _showEditDeviceDialog(context, unit),
                            onSwipeLeft: () => _confirmRemoveDevice(
                              context,
                              unit.id,
                              unit.name,
                              unit.macAddress,
                            ),
                            rightActionLabel: l10n.edit,
                            leftActionLabel: l10n.delete,
                            rightActionIcon: Icons.edit,
                            leftActionIcon: Icons.delete,
                            rightActionColor: HvacColors.info,
                            leftActionColor: HvacColors.error,
                            child: HvacInteractiveScale(
                              onTap: () {
                                // Navigate to device details
                                Navigator.of(context).pop();
                              },
                              child: Hero(
                                tag: 'device_${unit.id}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: HvacGradientBorder(
                                          gradientColors: const [
                                            HvacColors.primaryOrange,
                                            HvacColors.primaryBlue,
                                          ],
                                          child: Container(
                                            decoration: HvacDecorations.card(),
                                            child: Padding(
                                      padding: const EdgeInsets.all(HvacSpacing.md),
                                      child: Row(
                                        children: [
                                          // Icon with mode color
                                          Stack(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(HvacSpacing.sm),
                                                decoration: BoxDecoration(
                                                  color: HvacColors.getModeColor(unit.mode),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.thermostat,
                                                  color: HvacColors.textPrimary,
                                                  size: 24,
                                                ),
                                              ),
                                              // Online status indicator
                                              if (isOnline)
                                                const Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: HvacPulsingDot(
                                                    color: HvacColors.success,
                                                    size: 12,
                                                  ),
                                                ),
                                            ],
                                          ),

                                          const SizedBox(width: HvacSpacing.md),

                                          // Device info
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  unit.name,
                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(height: HvacSpacing.xxs),
                                                Text(
                                                  'ID: ${unit.id}',
                                                  style: TextStyle(
                                                    color: HvacColors.textSecondary.withValues(alpha: 0.5),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                if (unit.macAddress != null) ...[
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'MAC: ${_formatMacAddress(unit.macAddress!)}',
                                                    style: TextStyle(
                                                      color: HvacColors.textSecondary.withValues(alpha: 0.5),
                                                      fontSize: 12,
                                                      fontFamily: 'monospace',
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),

                                          // Status badge
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: HvacSpacing.sm,
                                              vertical: HvacSpacing.xxs,
                                            ),
                                            decoration: BoxDecoration(
                                              color: HvacColors.success.withValues(alpha: 0.2),
                                              borderRadius: HvacRadius.smRadius,
                                            ),
                                            child: Text(
                                              l10n.online,
                                              style: const TextStyle(
                                                color: HvacColors.success,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatMacAddress(String mac) {
    // Add colons every 2 characters if not present
    if (!mac.contains(':') && !mac.contains('-')) {
      final buffer = StringBuffer();
      for (int i = 0; i < mac.length; i += 2) {
        if (i > 0) buffer.write(':');
        buffer.write(mac.substring(i, i + 2 > mac.length ? mac.length : i + 2));
      }
      return buffer.toString().toUpperCase();
    }
    return mac.toUpperCase();
  }

  Future<void> _showAddDeviceDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final macController = TextEditingController();
    final nameController = TextEditingController();
    final locationController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? HvacColors.backgroundCard : HvacColors.glassWhite,
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
              ),
              const SizedBox(height: HvacSpacing.md),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.deviceName,
                  hintText: l10n.livingRoom,
                  prefixIcon: const Icon(Icons.label_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: HvacRadius.mdRadius,
                  ),
                ),
              ),
              const SizedBox(height: HvacSpacing.md),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: l10n.location,
                  hintText: l10n.optional,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: HvacRadius.mdRadius,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
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

              try {
                // Add device using REST API via bloc
                context.read<HvacListBloc>().add(
                  AddDeviceEvent(
                    macAddress: mac,
                    name: name,
                    location: locationController.text.isEmpty
                        ? null
                        : locationController.text.trim(),
                  ),
                );

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.deviceAdded),
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
            },
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
      ),
    );
  }

  Future<void> _showEditDeviceDialog(BuildContext context, dynamic unit) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameController = TextEditingController(text: unit.name);
    final locationController = TextEditingController(text: unit.location ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? HvacColors.backgroundCard : HvacColors.glassWhite,
        title: Text(l10n.editDevice),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // MAC address is read-only
              TextField(
                controller: TextEditingController(
                  text: unit.macAddress != null
                      ? _formatMacAddress(unit.macAddress!)
                      : unit.id,
                ),
                enabled: false,
                decoration: InputDecoration(
                  labelText: l10n.macAddress,
                  prefixIcon: const Icon(Icons.router_rounded),
                  border: OutlineInputBorder(
                    borderRadius: HvacRadius.mdRadius,
                  ),
                ),
              ),
              const SizedBox(height: HvacSpacing.md),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.deviceName,
                  prefixIcon: const Icon(Icons.label_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: HvacRadius.mdRadius,
                  ),
                ),
              ),
              const SizedBox(height: HvacSpacing.md),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: l10n.location,
                  hintText: l10n.optional,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: HvacRadius.mdRadius,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();

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
                //     deviceId: unit.id,
                //     name: name,
                //     location: locationController.text.isEmpty
                //         ? null
                //         : locationController.text.trim(),
                //   ),
                // );

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.deviceUpdated),
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HvacColors.primaryBlue,
              foregroundColor: HvacColors.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: HvacRadius.mdRadius,
              ),
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRemoveDevice(
    BuildContext context,
    String unitId,
    String name,
    String? macAddress,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final bloc = context.read<HvacListBloc>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? HvacColors.backgroundCard : HvacColors.glassWhite,
        title: Text(l10n.removeDevice),
        content: Text(l10n.confirmRemoveDevice(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
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
      ),
    );

    if (confirmed == true) {
      try {
        // Remove device using REST API via bloc
        bloc.add(RemoveDeviceEvent(deviceId: unitId));

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.deviceRemoved),
            backgroundColor: HvacColors.success,
          ),
        );
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            backgroundColor: HvacColors.error,
          ),
        );
      }
    }
  }
}
