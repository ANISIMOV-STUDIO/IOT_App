/// Device Management Screen
///
/// Allows adding and removing HVAC devices
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../widgets/device_management/device_add_button.dart';
import '../widgets/device_management/device_add_dialog.dart';
import '../widgets/device_management/device_empty_state.dart';
import '../widgets/device_management/device_error_state.dart';
import '../widgets/device_management/device_list_view.dart';
import '../widgets/device_management/device_loading_state.dart';

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

  void _showAddDeviceDialog() {
    showDialog(
      context: context,
      builder: (context) => const DeviceAddDialog(),
    );
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
          DeviceAddButton(
            onTap: _showAddDeviceDialog,
          ),

          // Devices List with State Management
          Expanded(
            child: BlocBuilder<HvacListBloc, HvacListState>(
              builder: (context, state) {
                // Show skeleton loader during initial loading
                if (state is HvacListLoading && !_isRefreshing) {
                  return const DeviceLoadingState();
                }

                // Show error state
                if (state is HvacListError) {
                  return DeviceErrorState(
                    errorMessage: state.message,
                    onRefresh: _handleRefresh,
                  );
                }

                // Show loaded state
                if (state is HvacListLoaded) {
                  final units = state.units;

                  // Show empty state if no devices
                  if (units.isEmpty) {
                    return DeviceEmptyState(
                      onRefresh: _handleRefresh,
                    );
                  }

                  // Show device list
                  return DeviceListView(
                    units: units,
                    onRefresh: _handleRefresh,
                    onItemTap: () => Navigator.of(context).pop(),
                  );
                }

                // Default empty state
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
