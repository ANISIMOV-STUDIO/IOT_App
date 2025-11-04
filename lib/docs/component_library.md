# Component Library

> Reusable widgets and components for the HVAC Control Application

## Table of Contents
1. [Buttons](#buttons)
2. [Cards](#cards)
3. [Controls](#controls)
4. [Indicators](#indicators)
5. [Panels](#panels)
6. [Charts](#charts)
7. [Animations](#animations)

---

## Buttons

### OrangeButton
**Location:** `lib/presentation/widgets/orange_button.dart`

Primary call-to-action button with orange gradient.

```dart
OrangeButton(
  text: 'Save Changes',
  width: double.infinity,
  onPressed: () => handleSave(),
  isLoading: false,
)
```

**Props:**
- `text` (String, required) - Button label
- `width` (double, optional) - Button width
- `onPressed` (VoidCallback, required) - Tap handler
- `isLoading` (bool, default: false) - Shows loading indicator

**Features:**
- Minimum height: 48dp (accessibility)
- Haptic feedback on tap
- Loading state with spinner
- Disabled state support

---

### OutlineButton
**Location:** `lib/presentation/widgets/orange_button.dart`

Secondary button with orange outline.

```dart
OutlineButton(
  text: 'Cancel',
  width: double.infinity,
  onPressed: () => Navigator.pop(context),
)
```

**Props:**
- `text` (String, required) - Button label
- `width` (double, optional) - Button width
- `onPressed` (VoidCallback, required) - Tap handler

---

### GradientButton
**Location:** `lib/presentation/widgets/gradient_button.dart`

Button with custom gradient background.

```dart
GradientButton(
  text: 'Get Started',
  gradient: LinearGradient(
    colors: [HvacColors.primaryOrange, HvacColors.primaryOrangeLight],
  ),
  onPressed: () => navigateToHome(),
)
```

---

## Cards

### DeviceCard
**Location:** `lib/presentation/widgets/device_card.dart`

Card displaying device information with power controls.

```dart
DeviceCard(
  deviceName: 'Living Room AC',
  location: 'Living Room',
  temperature: 22,
  mode: 'cooling',
  isOnline: true,
  isPoweredOn: true,
  onTap: () => navigateToDeviceDetail(),
  onPowerToggle: (value) => updatePower(value),
)
```

**Props:**
- `deviceName` (String, required)
- `location` (String, optional)
- `temperature` (double, required)
- `mode` (String, required)
- `isOnline` (bool, default: true)
- `isPoweredOn` (bool, required)
- `onTap` (VoidCallback, optional)
- `onPowerToggle` (ValueChanged<bool>, required)

**Features:**
- Shows device status (online/offline)
- Temperature display
- Power switch with haptic feedback
- Mode color indication
- Tap target: 48dp minimum

---

### RoomPreviewCard
**Location:** `lib/presentation/widgets/room_preview_card.dart`

Large card showing live room preview with status badges.

```dart
RoomPreviewCard(
  roomName: 'Living Room',
  isLive: true,
  badges: [
    StatusBadge(icon: Icons.thermostat, value: '22°C'),
    StatusBadge(icon: Icons.water_drop, value: '45%'),
  ],
  onPowerChanged: (value) => updatePower(value),
  onDetailsPressed: () => navigateToDetails(),
)
```

**Props:**
- `roomName` (String, required)
- `isLive` (bool, required)
- `badges` (List<StatusBadge>, optional)
- `onPowerChanged` (ValueChanged<bool>, required)
- `onDetailsPressed` (VoidCallback, optional)

**Features:**
- Animated live indicator
- Status badges with icons
- Power control
- Details navigation
- Responsive layout

---

### DashboardStatCard
**Location:** `lib/presentation/widgets/dashboard_stat_card.dart`

Small card showing a single statistic.

```dart
DashboardStatCard(
  title: 'Temperature',
  value: '22°C',
  icon: Icons.thermostat,
  color: HvacColors.modeCool,
  trend: '+2°',
)
```

---

### DashboardChartCard
**Location:** `lib/presentation/widgets/dashboard_chart_card.dart`

Card containing a chart widget.

```dart
DashboardChartCard(
  title: 'Temperature History',
  child: TemperatureChart(data: temperatureData),
  onTap: () => navigateToAnalytics(),
)
```

---

### ModePresetCard
**Location:** `lib/presentation/widgets/mode_preset_card.dart`

Card for selecting HVAC mode presets.

```dart
ModePresetCard(
  preset: ModePreset.comfort,
  isSelected: false,
  onTap: () => applyPreset(ModePreset.comfort),
)
```

---

### DayScheduleCard
**Location:** `lib/presentation/widgets/day_schedule_card.dart`

Card for configuring daily schedule.

```dart
DayScheduleCard(
  day: DayOfWeek.monday,
  schedule: mondaySchedule,
  onChanged: (schedule) => updateSchedule(schedule),
)
```

---

## Controls

### VentilationModeControl
**Location:** `lib/presentation/widgets/ventilation_mode_control.dart`

Control panel for ventilation mode and fan speeds.

```dart
VentilationModeControl(
  unit: hvacUnit,
  onModeChanged: (mode) => updateMode(mode),
  onSupplyFanChanged: (speed) => updateSupplyFan(speed),
  onExhaustFanChanged: (speed) => updateExhaustFan(speed),
)
```

**Props:**
- `unit` (HvacUnit, required)
- `onModeChanged` (ValueChanged<VentilationMode>, required)
- `onSupplyFanChanged` (ValueChanged<int>, required)
- `onExhaustFanChanged` (ValueChanged<int>, required)

**Features:**
- Mode selector (Supply, Exhaust, Balanced)
- Dual fan speed sliders
- Real-time feedback
- Haptic feedback on changes

---

### VentilationTemperatureControl
**Location:** `lib/presentation/widgets/ventilation_temperature_control.dart`

Temperature control with supply/return air indicators.

```dart
VentilationTemperatureControl(
  unit: hvacUnit,
)
```

**Features:**
- Current temperature display
- Supply air temperature
- Return air temperature
- Visual temperature indicators

---

### VentilationScheduleControl
**Location:** `lib/presentation/widgets/ventilation_schedule_control.dart`

Schedule overview and quick access.

```dart
VentilationScheduleControl(
  unit: hvacUnit,
  onSchedulePressed: () => navigateToSchedule(),
)
```

**Features:**
- Today's schedule preview
- Next scheduled event
- Quick enable/disable toggle
- Navigate to full schedule

---

### FanSpeedSlider
**Location:** `lib/presentation/widgets/fan_speed_slider.dart`

Slider for adjusting fan speed.

```dart
FanSpeedSlider(
  label: 'Supply Fan',
  value: 75,
  onChanged: (value) => updateFanSpeed(value),
)
```

**Props:**
- `label` (String, required)
- `value` (int, required) - 0-100
- `onChanged` (ValueChanged<int>, required)

**Features:**
- Percentage display
- Haptic feedback on drag
- Semantic labels for accessibility
- Min/max indicators

---

### VentilationModeSelector
**Location:** `lib/presentation/widgets/ventilation_mode_selector.dart`

Button group for selecting ventilation mode.

```dart
VentilationModeSelector(
  selectedMode: VentilationMode.balanced,
  onModeChanged: (mode) => updateMode(mode),
)
```

**Modes:**
- Supply Only
- Exhaust Only
- Balanced

---

## Indicators

### AirQualityIndicator
**Location:** `lib/presentation/widgets/air_quality_indicator.dart`

Animated air quality indicator with metrics.

```dart
AirQualityIndicator(
  level: AirQualityLevel.good,
  co2Level: 650,
  pm25Level: 12.5,
  vocLevel: 150,
)
```

**Props:**
- `level` (AirQualityLevel, required)
- `co2Level` (int, optional) - CO₂ in ppm
- `pm25Level` (double, optional) - PM2.5 in μg/m³
- `vocLevel` (double, optional) - VOC in ppb

**Levels:**
- Excellent (green)
- Good (light green)
- Moderate (yellow)
- Poor (orange)
- Very Poor (red)

**Features:**
- Pulsing animation
- Color-coded levels
- Detailed metrics
- Emoji indicators

---

### CircularTemperatureIndicator
**Location:** `lib/presentation/widgets/circular_temperature_indicator.dart`

Circular gauge for temperature display.

```dart
CircularTemperatureIndicator(
  currentTemp: 22,
  targetTemp: 24,
  minTemp: 16,
  maxTemp: 30,
)
```

**Features:**
- Animated progress arc
- Current vs target display
- Color gradient based on temperature
- Touch to adjust (optional)

---

### TemperatureInfoCard
**Location:** `lib/presentation/widgets/temperature_info_card.dart`

Compact temperature information display.

```dart
TemperatureInfoCard(
  label: 'Indoor',
  temperature: 22,
  humidity: 45,
  icon: Icons.home,
)
```

---

## Panels

### QuickPresetsPanel
**Location:** `lib/presentation/widgets/quick_presets_panel.dart`

Panel with quick access mode presets.

```dart
QuickPresetsPanel(
  onPresetSelected: (preset) => applyPreset(preset),
)
```

**Presets:**
- Comfort Mode
- Economy Mode
- Sleep Mode
- Away Mode
- Custom

**Features:**
- Icon representation
- Quick tap selection
- Current preset highlighted
- Haptic feedback

---

### GroupControlPanel
**Location:** `lib/presentation/widgets/group_control_panel.dart`

Control panel for managing multiple units.

```dart
GroupControlPanel(
  units: allUnits,
  onPowerAllOn: () => powerAll(true),
  onPowerAllOff: () => powerAll(false),
  onSyncSettings: () => syncSettingsToAll(),
  onApplyScheduleToAll: () => applyScheduleToAll(),
)
```

**Props:**
- `units` (List<HvacUnit>, required)
- `onPowerAllOn` (VoidCallback, required)
- `onPowerAllOff` (VoidCallback, required)
- `onSyncSettings` (VoidCallback, required)
- `onApplyScheduleToAll` (VoidCallback, required)

**Features:**
- Batch power control
- Settings synchronization
- Schedule propagation
- Unit count display

---

### AutomationPanel
**Location:** `lib/presentation/widgets/automation_panel.dart`

Panel for managing automation rules.

```dart
AutomationPanel(
  rules: automationRules,
  onRuleToggled: (rule) => toggleRule(rule),
  onManageRules: () => navigateToAutomation(),
)
```

**Features:**
- List of active rules
- Toggle rules on/off
- Rule descriptions
- Navigate to full automation settings

---

### AlertsCard
**Location:** `lib/presentation/widgets/alerts_card.dart`

Card displaying active alerts and warnings.

```dart
AlertsCard(
  alerts: activeAlerts,
  onAlertTap: (alert) => showAlertDetails(alert),
  onDismiss: (alert) => dismissAlert(alert),
)
```

---

## Charts

### TemperatureChart
**Location:** `lib/presentation/widgets/temperature_chart.dart`

Line chart for temperature history.

```dart
TemperatureChart(
  data: temperatureReadings,
  timeRange: TimeRange.day,
  showTarget: true,
)
```

**Props:**
- `data` (List<TemperatureReading>, required)
- `timeRange` (TimeRange, default: day)
- `showTarget` (bool, default: false)

**Features:**
- Smooth line interpolation
- Touch to show values
- Time range selection (day/week/month)
- Target temperature line (optional)
- Grid lines
- Responsive sizing

**Uses:** fl_chart package

---

## Animations

### AirflowAnimation
**Location:** `lib/presentation/widgets/airflow_animation.dart`

Animated visualization of airflow.

```dart
AirflowAnimation(
  isActive: true,
  direction: AirflowDirection.supply,
  speed: AirflowSpeed.medium,
)
```

**Directions:**
- Supply (inward)
- Exhaust (outward)
- Balanced (both)

**Speeds:**
- Slow
- Medium
- Fast

**Features:**
- Particle animation
- Color-coded by direction
- Speed-based animation rate
- Pauses when inactive

---

### AnimatedStatCard
**Location:** `lib/presentation/widgets/animated_stat_card.dart`

Stat card with number count-up animation.

```dart
AnimatedStatCard(
  title: 'Active Devices',
  value: 4,
  icon: Icons.devices,
  duration: Duration(milliseconds: 500),
)
```

**Features:**
- Smooth number transition
- Icon bounce on update
- Customizable duration

---

### ActivityTimeline
**Location:** `lib/presentation/widgets/activity_timeline.dart`

Vertical timeline of activities and events.

```dart
ActivityTimeline(
  activities: recentActivities,
  maxItems: 10,
)
```

**Features:**
- Chronological display
- Color-coded by severity
- Icons for event types
- Relative timestamps
- Expandable items

---

## Layout Components

### DeviceControlCard
**Location:** `lib/presentation/widgets/device_control_card.dart`

Generic card wrapper for device controls.

```dart
DeviceControlCard(
  title: 'Climate Control',
  icon: Icons.thermostat,
  child: TemperatureSlider(...),
)
```

---

### DashboardAlertItem
**Location:** `lib/presentation/widgets/dashboard_alert_item.dart`

Single alert item for dashboard display.

```dart
DashboardAlertItem(
  alert: criticalAlert,
  onTap: () => showAlertDetails(),
  onDismiss: () => dismissAlert(),
)
```

---

### DashboardAirQuality
**Location:** `lib/presentation/widgets/dashboard_air_quality.dart`

Compact air quality display for dashboard.

```dart
DashboardAirQuality(
  quality: AirQualityLevel.good,
  onTap: () => showAirQualityDetails(),
)
```

---

## Navigation Components

### ResponsiveShell
**Location:** `lib/presentation/pages/responsive_shell.dart`

Responsive navigation shell that adapts to screen size.

```dart
ResponsiveShell(
  currentIndex: 0,
  onNavigate: (index) => handleNavigation(index),
  child: currentScreen,
)
```

**Features:**
- Bottom navigation (mobile)
- Side navigation (tablet/desktop)
- Adaptive layout
- Smooth transitions

---

## Usage Guidelines

### Accessibility
All components include:
- ✅ Minimum 48x48dp tap targets
- ✅ Semantic labels
- ✅ Haptic feedback
- ✅ WCAG AA contrast compliance
- ✅ Screen reader support

### Performance
- Use `const` constructors where possible
- Implement `ListView.builder` for lists
- Cache images with `cacheWidth`/`cacheHeight`
- Avoid rebuilds with proper `keys`

### Responsive Design
- Use `.w`, `.h`, `.sp` from flutter_screenutil
- Test on multiple screen sizes
- Support landscape orientation
- Follow breakpoint guidelines

---

## Component Checklist

Before creating a new component, check:

- [ ] Is this functionality covered by an existing component?
- [ ] Does it follow the design system colors?
- [ ] Are tap targets >= 48x48dp?
- [ ] Is haptic feedback included for interactions?
- [ ] Are semantic labels added for accessibility?
- [ ] Does it use responsive sizing (.w, .h, .sp)?
- [ ] Is the file under 300 lines?
- [ ] Are props properly documented?
- [ ] Does it have a const constructor?
- [ ] Has it been tested on multiple screen sizes?

---

## Contributing

When adding new components:

1. Follow the design system guidelines
2. Add comprehensive documentation here
3. Include usage examples
4. Test for accessibility
5. Optimize for performance
6. Keep files modular and under 300 lines

---

**Last Updated:** November 2, 2025
**Total Components:** 40+
**Component Coverage:** 100% of UI elements
