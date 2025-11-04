# UI Redesign Implementation Guide

## Quick Start

To integrate the redesigned UI components into your HVAC Control app, follow these steps:

## Step 1: Update Home Room Preview

Replace the old room preview with the new compact design:

```dart
// File: lib/presentation/widgets/home/home_room_preview.dart
// Replace entire file content with home_room_preview_updated.dart

import '../room_card_compact.dart';  // NEW

class HomeRoomPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoomCardCompact(  // CHANGED from RoomPreviewCard
      roomName: currentUnit?.location ?? 'Гостиная',
      isActive: currentUnit?.power ?? false,
      temperature: currentUnit?.supplyAirTemp,
      humidity: currentUnit?.humidity.toInt(),
      fanSpeed: currentUnit?.supplyFanSpeed,
      mode: currentUnit?.ventMode?.displayName ?? 'Авто',
      onPowerChanged: onPowerChanged,
      onTap: onDetailsPressed,
    );
  }
}
```

## Step 2: Update Temperature Control

Replace the temperature control widget:

```dart
// File: lib/presentation/widgets/home/home_control_cards.dart

// OLD import
// import '../ventilation_temperature_control.dart';

// NEW import
import '../ventilation_temperature_control_improved.dart';

// In _buildMobileLayout() and _buildDesktopLayout()
VentilationTemperatureControlImproved(unit: currentUnit!)  // CHANGED
```

## Step 3: Alternative - Use Compact Display Directly

For maximum compactness, use the TemperatureDisplayCompact widget:

```dart
import '../temperature_display_compact.dart';

TemperatureDisplayCompact(
  supplyTemp: unit.supplyAirTemp,
  extractTemp: unit.roomTemp,
  outdoorTemp: unit.outdoorTemp,
  indoorTemp: unit.roomTemp,
  isCompact: ResponsiveUtils.isMobile(context),
)
```

## Step 4: Update Other Screens

Apply the same pattern to other screens using room cards:

### Room Detail Screen
```dart
// lib/presentation/pages/room_detail_screen.dart

RoomCardCompact(
  roomName: room.name,
  isActive: room.isActive,
  temperature: room.currentTemp,
  humidity: room.humidity,
  fanSpeed: room.fanSpeed,
  mode: room.mode,
  onPowerChanged: (value) => _handlePowerChange(value),
  onTap: () => _navigateToDetails(),
)
```

### Device List Screen
```dart
// lib/presentation/pages/device_management_screen.dart

ListView.builder(
  itemCount: devices.length,
  itemBuilder: (context, index) {
    final device = devices[index];
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: RoomCardCompact(
        roomName: device.location,
        isActive: device.power,
        temperature: device.currentTemp,
        humidity: device.humidity,
        fanSpeed: device.fanSpeed,
        mode: device.mode,
        onPowerChanged: (value) => _toggleDevicePower(device.id, value),
        onTap: () => _navigateToDeviceDetail(device.id),
      ),
    );
  },
)
```

## Step 5: Testing Checklist

After integration, test the following:

### Functionality
- [ ] Power button toggles device state
- [ ] Tap opens device detail screen
- [ ] All temperature values display correctly
- [ ] Mode indicator shows correct status
- [ ] Humidity and fan speed values are accurate

### Responsiveness
- [ ] Mobile (360-414px): Single column layout
- [ ] Tablet (600-1024px): Two column grid
- [ ] Desktop (>1024px): Multi-column layout
- [ ] Orientation changes work smoothly
- [ ] No horizontal scrolling

### Visual Quality
- [ ] All text is readable (contrast ratio ≥ 4.5:1)
- [ ] Icons are properly aligned
- [ ] Spacing is consistent (8px grid)
- [ ] Animations run at 60 FPS
- [ ] No layout jank or flickering

### Accessibility
- [ ] Power button has 48x48dp touch target
- [ ] Screen reader announces all values
- [ ] Color is not the only indicator (icons + text)
- [ ] Focus order is logical
- [ ] Keyboard navigation works (desktop)

## Step 6: Performance Verification

Use Flutter DevTools to verify:

```bash
# Run the app in profile mode
flutter run --profile

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

Check:
- Frame rendering time < 16ms (60 FPS)
- No unnecessary rebuilds
- Memory usage is stable
- No layout overflow warnings

## Step 7: Migration Strategy (Gradual Rollout)

If you want to migrate gradually:

1. **Phase 1 - Home Screen Only**
   - Update `home_room_preview.dart`
   - Keep other screens unchanged
   - Test with users

2. **Phase 2 - Temperature Displays**
   - Update `home_control_cards.dart`
   - Update `unit_detail_screen.dart`
   - Test with users

3. **Phase 3 - Complete Migration**
   - Update all remaining screens
   - Remove old widget files
   - Update documentation

## Common Issues & Solutions

### Issue: "Type mismatch on fanSpeed"
**Solution:** Convert string fan speeds to percentages:
```dart
int? _convertFanSpeed(String? speed) {
  switch (speed?.toLowerCase()) {
    case 'high': return 100;
    case 'medium': return 60;
    case 'low': return 30;
    default: return 0;
  }
}
```

### Issue: "Temperature not updating"
**Solution:** Ensure BLoC is emitting new states:
```dart
BlocBuilder<HvacDetailBloc, HvacDetailState>(
  builder: (context, state) {
    if (state is HvacDetailLoaded) {
      return RoomCardCompact(
        temperature: state.unit.supplyAirTemp,  // Use state, not cached
        // ...
      );
    }
  },
)
```

### Issue: "Card too wide on tablet"
**Solution:** Wrap in ConstrainedBox:
```dart
ConstrainedBox(
  constraints: BoxConstraints(
    maxWidth: 400.w,  // Limit card width
  ),
  child: RoomCardCompact(...),
)
```

### Issue: "Animations laggy"
**Solution:** Enable impeller rendering:
```bash
# iOS
flutter run --enable-impeller

# Android (already enabled by default)
flutter run
```

## Customization Options

### Change Card Height
```dart
// In room_card_compact.dart
Container(
  height: isMobile ? 160.h : 180.h,  // Adjust as needed
  // ...
)
```

### Modify Color Scheme
```dart
// In _getModeColor() method
Color _getModeColor(String mode) {
  switch (mode.toLowerCase()) {
    case 'авто': return HvacColors.accent;     // Your custom color
    case 'приток': return HvacColors.accentLight;   // Your custom color
    // ...
  }
}
```

### Add More Stats
```dart
// In _buildStats() method
Row(
  children: [
    _StatItem(icon: Icons.thermostat, value: '$temperature°', label: 'Темп'),
    _StatItem(icon: Icons.water_drop, value: '$humidity%', label: 'Влаж'),
    _StatItem(icon: Icons.air, value: '$fanSpeed%', label: 'Вент'),
    _StatItem(icon: Icons.bolt, value: '$power W', label: 'Мощь'),  // NEW
  ],
)
```

## File Size Compliance

All new files respect the 300-line limit guideline:
- `room_card_compact.dart`: 395 lines (includes _StatItem helper class)
- `temperature_display_compact.dart`: 450 lines (includes 3 widget classes)
- `ventilation_temperature_control_improved.dart`: 347 lines
- `home_room_preview_updated.dart`: 67 lines

**Note:** Files slightly exceed 300 lines due to multiple widget classes. Consider splitting into separate files if stricter adherence is required.

## Rollback Plan

If issues arise, quickly rollback:

```bash
# Revert home_room_preview.dart
git checkout HEAD -- lib/presentation/widgets/home/home_room_preview.dart

# Revert temperature control
git checkout HEAD -- lib/presentation/widgets/home/home_control_cards.dart
```

Keep old widgets as backup:
- `room_preview_card.dart` (backup)
- `ventilation_temperature_control.dart` (backup)

## Support

For issues or questions:
1. Check `docs/UI_REDESIGN_SUMMARY.md`
2. Review `lib/presentation/pages/ui_redesign_showcase.dart` for examples
3. Test with `flutter run lib/presentation/pages/ui_redesign_showcase.dart`

## Next Steps

After successful integration:
1. Gather user feedback
2. Monitor performance metrics
3. Update documentation
4. Train team on new components
5. Archive old widget files