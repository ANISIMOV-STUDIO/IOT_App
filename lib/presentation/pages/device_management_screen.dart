/// Device Management Screen
///
/// Allows adding and removing HVAC devices
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../../core/config/env_config.dart';
import '../../data/datasources/mqtt_datasource.dart';
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
  MqttDatasource? _mqttDatasource;
  bool _isMqttMode = false;

  @override
  void initState() {
    super.initState();
    _isMqttMode = EnvConfig.useMqtt;
    if (_isMqttMode) {
      _mqttDatasource = sl<MqttDatasource>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deviceManagement),
        elevation: 0,
        backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      ),
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: Column(
        children: [
          // Add Device Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _isMqttMode
                      ? () => _showAddDeviceDialog(context)
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.mqttModeRequired),
                              backgroundColor: const Color(0xFFEF4444),
                            ),
                          );
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.addDevice,
                          style: const TextStyle(
                            color: Colors.white,
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

          // Devices List
          Expanded(
            child: BlocBuilder<HvacListBloc, HvacListState>(
              builder: (context, state) {
                if (state is HvacListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is HvacListError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                      ),
                    ),
                  );
                }

                if (state is HvacListLoaded) {
                  final units = state.units;

                  if (units.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.devices_other_rounded,
                            size: 64,
                            color: isDark
                                ? AppTheme.darkTextHint
                                : AppTheme.lightTextHint,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noDevicesFound,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: units.length,
                    itemBuilder: (context, index) {
                      final unit = units[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: AppTheme.glassmorphicCard(
                            isDark: isDark,
                            borderRadius: 16,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: AppTheme.getModeGradient(
                                  unit.mode,
                                  isDark: isDark,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                AppTheme.getModeIcon(unit.mode),
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              unit.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${unit.id}',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppTheme.darkTextHint
                                        : AppTheme.lightTextHint,
                                    fontSize: 12,
                                  ),
                                ),
                                if (unit.macAddress != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    'MAC: ${_formatMacAddress(unit.macAddress!)}',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppTheme.darkTextHint
                                          : AppTheme.lightTextHint,
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Color(0xFFEF4444),
                              ),
                              onPressed: _isMqttMode
                                  ? () => _confirmRemoveDevice(
                                        context,
                                        unit.id,
                                        unit.name,
                                        unit.macAddress,
                                      )
                                  : () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(l10n.mqttModeRequired),
                                          backgroundColor: const Color(0xFFEF4444),
                                        ),
                                      );
                                    },
                            ),
                          ),
                        ),
                      );
                    },
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
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
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
                    borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.deviceName,
                  hintText: l10n.livingRoom,
                  prefixIcon: const Icon(Icons.label_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: l10n.location,
                  hintText: l10n.optional,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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
                    backgroundColor: const Color(0xFFEF4444),
                  ),
                );
                return;
              }

              try {
                await _mqttDatasource!.addDevice(
                  macAddress: mac,
                  name: name,
                  location: locationController.text.isEmpty
                      ? null
                      : locationController.text.trim(),
                );

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.deviceAdded),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );

                  // Refresh devices list
                  context.read<HvacListBloc>().add(const LoadHvacUnitsEvent());
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.error}: $e'),
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.add),
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
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
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
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _mqttDatasource!.removeDevice(
          unitId: unitId,
          macAddress: macAddress,
        );

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.deviceRemoved),
            backgroundColor: AppTheme.successColor,
          ),
        );

        // Refresh devices list
        bloc.add(const LoadHvacUnitsEvent());
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }
}