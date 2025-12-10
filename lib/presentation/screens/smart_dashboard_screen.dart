// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:smart_home_core/domain/entities/device.dart';
import 'package:smart_home_core/domain/entities/ventilation_device.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';
import '../../../data/repositories/unified_device_repository_impl.dart';

class SmartDashboardScreen extends StatefulWidget {
  const SmartDashboardScreen({super.key});

  @override
  State<SmartDashboardScreen> createState() => _SmartDashboardScreenState();
}

class _SmartDashboardScreenState extends State<SmartDashboardScreen> {
  final _repository = UnifiedDeviceRepositoryImpl();
  late Stream<List<Device>> _devicesStream;

  @override
  void initState() {
    super.initState();
    _devicesStream = _repository.devices;
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.sectionSpacing),
              _buildDeviceGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Home',
          style: AppTypography.displayMedium,
        ),
        const SizedBox(height: AppSpacing.v4),
        Text(
          'Manage your smart devices',
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildDeviceGrid() {
    return Expanded(
      child: StreamBuilder<List<Device>>(
        stream: _devicesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final devices = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.elementSpacing,
              mainAxisSpacing: AppSpacing.elementSpacing,
              childAspectRatio: 0.85,
            ),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return _buildDeviceCard(devices[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildDeviceCard(Device device) {
    final isVentilation = device is VentilationDevice;
    final isOn = isVentilation ? device.isPowerOn : false;
    final temp = isVentilation ? device.currentTemperature : 0.0;

    return SmartCard(
      backgroundColor: isOn ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : null,
      onTap: () {
        if (device is VentilationDevice) {
          _repository.updateDevice(
            device.copyWithPower(!device.isPowerOn),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.air,
                color: isOn ? Theme.of(context).colorScheme.primary : AppColors.textDisabled,
                size: 32,
              ),
              if (isOn)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ON',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.success),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            device.name,
            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.v4),
          if (isVentilation)
            Text(
              '${temp.toStringAsFixed(1)}°C',
              style: AppTypography.displayMedium.copyWith(fontSize: 20),
            ),
        ],
      ),
    );
  }
}
