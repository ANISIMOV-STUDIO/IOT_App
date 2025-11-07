/// Example usage of HvacSkeletonLoader
library;

import 'package:flutter/material.dart';
import '../hvac_skeleton_loader.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

class SkeletonLoaderExample extends StatefulWidget {
  const SkeletonLoaderExample({super.key});

  @override
  State<SkeletonLoaderExample> createState() => _SkeletonLoaderExampleState();
}

class _SkeletonLoaderExampleState extends State<SkeletonLoaderExample> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Skeleton Loader Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(HvacSpacing.md),
        child: Column(
          children: [
            // Shimmer effect example
            HvacSkeletonLoader(
              isLoading: _isLoading,
              child: _buildDeviceCard(),
            ),
            const SizedBox(height: HvacSpacing.lg),

            // Pulse effect example
            HvacSkeletonPulse(
              isLoading: _isLoading,
              child: _buildStatCard(),
            ),
            const SizedBox(height: HvacSpacing.lg),

            // Fade effect example
            HvacSkeletonFade(
              isLoading: _isLoading,
              child: _buildListTile(),
            ),

            const SizedBox(height: HvacSpacing.xl),
            ElevatedButton(
              onPressed: () => setState(() => _isLoading = !_isLoading),
              child: Text(_isLoading ? 'Stop Loading' : 'Start Loading'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard() {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.md),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Living Room AC', style: TextStyle(fontSize: 18)),
          const SizedBox(height: HvacSpacing.sm),
          const Text('Temperature: 24°C', style: TextStyle(fontSize: 14)),
          const SizedBox(height: HvacSpacing.sm),
          Row(
            children: [
              Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  color: HvacColors.primaryOrange,
                  borderRadius: HvacRadius.smRadius,
                ),
              ),
              const SizedBox(width: HvacSpacing.sm),
              const Text('Active'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard() {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.md),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
      ),
      child: const Row(
        children: [
          Icon(Icons.thermostat, size: 48),
          SizedBox(width: HvacSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Temperature', style: TextStyle(fontSize: 14)),
              Text('24.5°C', style: TextStyle(fontSize: 24)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListTile() {
    return const ListTile(
      leading: CircleAvatar(child: Icon(Icons.device_thermostat)),
      title: Text('Device Name'),
      subtitle: Text('Status information'),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
