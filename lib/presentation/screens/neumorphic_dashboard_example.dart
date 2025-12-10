import 'package:flutter/material.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';

/// Example Smart Home Dashboard using Neumorphic Design System
class NeumorphicDashboardExample extends StatefulWidget {
  const NeumorphicDashboardExample({super.key});

  @override
  State<NeumorphicDashboardExample> createState() => _NeumorphicDashboardExampleState();
}

class _NeumorphicDashboardExampleState extends State<NeumorphicDashboardExample> {
  int _selectedNavIndex = 0;
  double _temperature = 22;
  double _humidity = 60;
  TemperatureMode _temperatureMode = TemperatureMode.heating;
  
  // Device states
  final Map<String, bool> _deviceStates = {
    'Smart TV': true,
    'Speaker': true,
    'Router': false,
    'Wifi': true,
    'Heater': true,
    'Socket': false,
  };

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      data: NeumorphicThemeData.light(), // or .dark()
      child: NeumorphicDashboardShell(
        sidebar: _buildSidebar(),
        mainContent: _buildMainContent(),
        rightPanel: _buildRightPanel(),
      ),
    );
  }

  Widget _buildSidebar() {
    return NeumorphicSidebar(
      selectedIndex: _selectedNavIndex,
      onItemSelected: (index) => setState(() => _selectedNavIndex = index),
      userName: 'Raymanux Safetg',
      items: const [
        NeumorphicNavItem(icon: Icons.dashboard, label: 'Dashboard'),
        NeumorphicNavItem(icon: Icons.meeting_room, label: 'Rooms'),
        NeumorphicNavItem(icon: Icons.history, label: 'Recent'),
        NeumorphicNavItem(icon: Icons.bookmark_outline, label: 'Bookmark'),
        NeumorphicNavItem(icon: Icons.notifications_outlined, label: 'Notification', badge: '3'),
        NeumorphicNavItem(icon: Icons.download_outlined, label: 'Downloaded'),
      ],
      bottomItems: const [
        NeumorphicNavItem(icon: Icons.help_outline, label: 'Support'),
        NeumorphicNavItem(icon: Icons.settings_outlined, label: 'Setting'),
      ],
    );
  }

  Widget _buildMainContent() {
    return NeumorphicMainContent(
      title: 'My Devices',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Device grid - Row 1
          _buildDeviceRow([
            _buildDeviceCard('Smart TV', Icons.tv, '5Kwh'),
            _buildDeviceCard('Speaker', Icons.speaker, '5Kwh'),
            _buildDeviceCard('Router', Icons.router, '5Kwh'),
          ]),
          
          const SizedBox(height: NeumorphicSpacing.cardGap),
          
          // Device grid - Row 2
          _buildDeviceRow([
            _buildDeviceCard('Wifi', Icons.wifi, '5Kwh'),
            _buildDeviceCard('Heater', Icons.heat_pump, '5Kwh'),
            _buildDeviceCard('Socket', Icons.power, '5Kwh'),
          ]),
          
          const SizedBox(height: NeumorphicSpacing.sectionGap),
          
          // Bottom section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Usage Status
              Expanded(
                flex: 2,
                child: _buildUsageStatusCard(),
              ),
              const SizedBox(width: NeumorphicSpacing.cardGap),
              // Appliances
              Expanded(
                flex: 2,
                child: _buildAppliancesCard(),
              ),
            ],
          ),
          
          const SizedBox(height: NeumorphicSpacing.cardGap),
          
          // Power consumption & Occupants row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPowerConsumptionCard()),
              const SizedBox(width: NeumorphicSpacing.cardGap),
              Expanded(child: _buildOccupantsCard()),
            ],
          ),
          
          const SizedBox(height: NeumorphicSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    final theme = NeumorphicThemeData.light();
    
    return NeumorphicRightPanel(
      children: [
        // Temperature section
        Text('Temperature', style: theme.typography.headlineMedium),
        const SizedBox(height: NeumorphicSpacing.lg),
        
        Center(
          child: NeumorphicTemperatureDial(
            value: _temperature,
            minValue: 10,
            maxValue: 30,
            mode: _temperatureMode,
            label: 'Heating',
            onChanged: (value) => setState(() => _temperature = value),
          ),
        ),
        
        const SizedBox(height: NeumorphicSpacing.lg),
        
        // Mode selector
        NeumorphicModeSelector(
          selectedMode: _temperatureMode,
          onModeChanged: (mode) => setState(() => _temperatureMode = mode),
        ),
        
        const SizedBox(height: NeumorphicSpacing.xl),
        
        // Humidity
        NeumorphicSlider(
          label: 'Humidity',
          value: _humidity,
          min: 0,
          max: 100,
          suffix: '%',
          onChanged: (value) => setState(() => _humidity = value),
        ),
        
        const SizedBox(height: NeumorphicSpacing.md),
        
        // Humidity presets
        NeumorphicSliderPresets(
          currentValue: _humidity,
          presets: const [
            SliderPreset(label: 'Auto', value: 50),
            SliderPreset(label: '30%', value: 30),
            SliderPreset(label: '60%', value: 60),
          ],
          onPresetSelected: (value) => setState(() => _humidity = value),
        ),
        
        const SizedBox(height: NeumorphicSpacing.xl),
        
        // Air Quality
        const NeumorphicAirQualityCard(
          level: AirQualityLevel.good,
          co2Ppm: 874,
          pollutantsAqi: 60,
        ),
      ],
    );
  }

  Widget _buildDeviceRow(List<Widget> devices) {
    return Row(
      children: devices
          .map((device) => Expanded(child: device))
          .toList()
          .expand((widget) => [widget, const SizedBox(width: NeumorphicSpacing.cardGap)])
          .toList()
        ..removeLast(),
    );
  }

  Widget _buildDeviceCard(String name, IconData icon, String power) {
    final isOn = _deviceStates[name] ?? false;
    
    return SizedBox(
      height: 140,
      child: NeumorphicDeviceCard(
        name: name,
        icon: icon,
        isOn: isOn,
        subtitle: 'Active for 3 hours',
        powerConsumption: power,
        onToggle: (value) => setState(() => _deviceStates[name] = value),
      ),
    );
  }

  Widget _buildUsageStatusCard() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(NeumorphicSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Usage Status', 
                style: NeumorphicTypography.light.titleMedium),
              Row(
                children: [
                  const Icon(Icons.grid_view, size: 16),
                  const SizedBox(width: 8),
                  const Icon(Icons.bar_chart, size: 16),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: NeumorphicColors.lightSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Today', style: NeumorphicTypography.light.labelSmall),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total spent', style: NeumorphicTypography.light.labelSmall),
                  Text('35.02Kwh', style: NeumorphicTypography.light.numericLarge),
                ],
              ),
              const SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total hours', style: NeumorphicTypography.light.labelSmall),
                  Text('32h', style: NeumorphicTypography.light.numericLarge),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Placeholder for chart
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: NeumorphicColors.lightSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Chart placeholder')),
          ),
        ],
      ),
    );
  }

  Widget _buildAppliancesCard() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(NeumorphicSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('APPLIANCES', style: NeumorphicTypography.light.titleMedium),
          const SizedBox(height: 16),
          // Tabs
          Row(
            children: ['All', 'Hall', 'Lounge', 'Bedroom', 'Ki']
                .map((tab) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(tab, style: NeumorphicTypography.light.labelSmall),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          // Appliance list
          _buildApplianceRow('TV set', 'Light fixture', false, 50),
          _buildApplianceRow('Sterio system', 'Backlight', true, 70),
          _buildApplianceRow('Play Station 4', 'Lamp 1', false, 10),
          _buildApplianceRow('Computer', 'Lamp 2', false, 30),
        ],
      ),
    );
  }

  Widget _buildApplianceRow(String left, String right, bool leftOn, int rightValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(left, style: NeumorphicTypography.light.bodySmall),
                const Spacer(),
                Switch(value: leftOn, onChanged: null, activeThumbColor: NeumorphicColors.accentPrimary),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Text(right, style: NeumorphicTypography.light.bodySmall),
                const Spacer(),
                Text('$rightValue%', style: NeumorphicTypography.light.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerConsumptionCard() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(NeumorphicSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Device Power Consumption', style: NeumorphicTypography.light.titleMedium),
          const SizedBox(height: 16),
          _buildPowerRow(Icons.ac_unit, 'Air Condition', '2 unit', '52kw'),
          _buildPowerRow(Icons.lightbulb_outline, 'Smart Lamp', '8 unit', '12kw'),
          _buildPowerRow(Icons.tv, 'Smart TV', '5 unit', '21kw'),
          _buildPowerRow(Icons.speaker, 'Speaker', '1 unit', '42kw'),
        ],
      ),
    );
  }

  Widget _buildPowerRow(IconData icon, String name, String units, String power) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: NeumorphicColors.lightSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: NeumorphicTypography.light.bodyMedium),
                Text(units, style: NeumorphicTypography.light.labelSmall),
              ],
            ),
          ),
          Text(power, style: NeumorphicTypography.light.numericMedium),
        ],
      ),
    );
  }

  Widget _buildOccupantsCard() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(NeumorphicSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Occupant', style: NeumorphicTypography.light.titleMedium),
              Text('See All →', style: NeumorphicTypography.light.labelSmall),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildAvatar('Lvankan'),
              _buildAvatar('Jennyrix'),
              _buildAvatar('Enrique'),
              _buildAvatar('Christine'),
              _buildAvatar('Natalie'),
              _buildAvatar('Rawelax'),
              _buildAvatar('Bryan'),
              _buildAvatar('Saefqvf'),
              _buildAvatar('Dsafgdr'),
              _buildAvatarAdd(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: NeumorphicColors.lightShadowDark,
          child: Text(name[0], style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 4),
        Text(name, style: NeumorphicTypography.light.labelSmall),
      ],
    );
  }

  Widget _buildAvatarAdd() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: NeumorphicColors.lightSurface,
          child: Icon(Icons.add),
        ),
        const SizedBox(height: 4),
        Text('Add', style: NeumorphicTypography.light.labelSmall),
      ],
    );
  }
}
