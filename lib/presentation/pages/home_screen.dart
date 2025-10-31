/// Home Screen
///
/// Main screen showing all devices in a grid layout
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/di/injection_container.dart' as di;
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../bloc/hvac_detail/hvac_detail_bloc.dart';
import '../widgets/device_card.dart';
import '../../domain/entities/hvac_unit.dart';
import 'room_detail_screen.dart';
import 'device_search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.hvacControl),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: BlocBuilder<HvacListBloc, HvacListState>(
        builder: (context, state) {
          if (state is HvacListLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            );
          }

          if (state is HvacListError) {
            return _buildError(context, state.message, l10n);
          }

          if (state is HvacListLoaded) {
            if (state.units.isEmpty) {
              return _buildEmpty(context, l10n);
            }

            return _buildDeviceGrid(context, state.units);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, String message, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.connectionError,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HvacListBloc>().add(const RetryConnectionEvent());
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retryConnection),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.devices_other,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noDevicesFound,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.checkMqttSettings,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<HvacListBloc>(),
                      child: const DeviceSearchScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addDevice),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceGrid(BuildContext context, List<HvacUnit> units) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HvacListBloc>().add(const RefreshHvacUnitsEvent());
      },
      color: AppTheme.primaryOrange,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: units.length,
        itemBuilder: (context, index) {
          final unit = units[index];
          return DeviceStatusCard(
            name: unit.name,
            location: unit.location ?? 'Room',
            mode: unit.mode,
            temperature: unit.currentTemp,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider<HvacDetailBloc>(
                    create: (_) => di.sl<HvacDetailBloc>(param1: unit.id),
                    child: RoomDetailScreen(unitId: unit.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
