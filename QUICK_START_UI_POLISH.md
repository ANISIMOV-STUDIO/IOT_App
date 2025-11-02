# Quick Start Guide - Big Tech UI/UX Polish

**Fast-track implementation guide for developers**

---

## 5-Minute Overview

You now have access to 35+ premium UI components following Apple/Google design standards. This guide shows you how to use them immediately.

---

## Essential Imports

Add these to your files:

```dart
// Typography
import 'package:iot_app/core/theme/app_typography.dart';

// Buttons
import 'package:iot_app/presentation/widgets/common/animated_button.dart';

// Cards
import 'package:iot_app/presentation/widgets/common/glassmorphic_card.dart';

// Loading
import 'package:iot_app/presentation/widgets/common/enhanced_shimmer.dart';

// Empty States
import 'package:iot_app/presentation/widgets/common/enhanced_empty_state.dart';

// Haptics
import 'package:iot_app/core/services/haptic_service.dart';

// Visual Polish
import 'package:iot_app/presentation/widgets/common/visual_polish_components.dart';
```

---

## 1. Typography - Replace ALL TextStyle

### Before (Old Way)
```dart
Text(
  'Temperature',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
)
```

### After (New Way)
```dart
Text(
  'Temperature',
  style: AppTypography.h3,
)
```

### Quick Reference
```dart
// Headlines
AppTypography.h1  // 32sp, bold (main titles)
AppTypography.h2  // 28sp, semibold (section headers)
AppTypography.h3  // 24sp, semibold (card titles)
AppTypography.h4  // 20sp, semibold (subtitles)

// Body
AppTypography.body           // 16sp, regular (main text)
AppTypography.bodyMedium     // 16sp, medium (emphasis)
AppTypography.bodyBold       // 16sp, bold (strong emphasis)

// Captions
AppTypography.caption        // 14sp, secondary color (helper text)
AppTypography.captionBold    // 14sp, semibold (important helper)

// Numbers
AppTypography.numberLarge    // 48sp, light (big metrics)
AppTypography.temperatureDisplay // 72sp, ultra-light (temp values)

// Buttons
AppTypography.buttonMedium   // 16sp, semibold (button text)
```

---

## 2. Buttons - Replace All Buttons

### Primary Button
```dart
// Replace ElevatedButton
AnimatedPrimaryButton(
  label: 'Добавить устройство',
  icon: Icons.add_circle_outline,  // Optional
  onPressed: onAddDevice,
  isLoading: isProcessing,         // Shows spinner
  enableHaptic: true,              // Haptic feedback
)
```

### Outline Button
```dart
// Replace OutlinedButton
AnimatedOutlineButton(
  label: 'Отмена',
  icon: Icons.close,
  onPressed: onCancel,
)
```

### Icon Button
```dart
// Replace IconButton
AnimatedIconButton(
  icon: Icons.settings,
  onPressed: onSettings,
  tooltip: 'Настройки',
)
```

### Floating Action Button
```dart
// Replace FloatingActionButton
AnimatedFAB(
  icon: Icons.add,
  label: 'Новое',  // Optional, creates extended FAB
  onPressed: onAdd,
)
```

---

## 3. Loading States - Add to ALL BLoC States

### Before
```dart
if (state is HvacListLoading) {
  return Center(
    child: CircularProgressIndicator(),
  );
}
```

### After
```dart
if (state is HvacListLoading) {
  return HomeDashboardSkeleton();  // Full screen skeleton
}
```

### Available Skeletons
```dart
DeviceCardSkeleton()        // For device cards
ChartSkeleton()             // For charts
ListItemSkeleton()          // For list items
AnalyticsCardSkeleton()     // For stat cards
HomeDashboardSkeleton()     // Full home screen
```

### Custom Skeleton
```dart
EnhancedShimmer(
  child: SkeletonContainer(
    width: 200.w,
    height: 100.h,
    borderRadius: BorderRadius.circular(12.r),
  ),
)
```

---

## 4. Empty States - Add to ALL Empty Data Scenarios

### No Devices
```dart
if (devices.isEmpty) {
  return NoDevicesEmptyState(
    onAddDevice: onAddDevice,  // Optional CTA
  );
}
```

### No Data
```dart
if (chartData.isEmpty) {
  return NoDataEmptyState(
    customMessage: 'Данные появятся после первого запуска',
    onRefresh: onRefresh,
  );
}
```

### No Search Results
```dart
if (searchResults.isEmpty) {
  return NoSearchResultsEmptyState(
    searchQuery: query,
    onClearSearch: onClearSearch,
  );
}
```

### All Available Empty States
```dart
NoDevicesEmptyState()
NoDataEmptyState()
NoNotificationsEmptyState()
NoSearchResultsEmptyState()
OfflineEmptyState()
PermissionDeniedEmptyState()
MaintenanceEmptyState()
```

---

## 5. Cards - Premium Visual Effects

### Glassmorphic Card
```dart
GlassmorphicCard(
  blurAmount: 10.0,
  child: YourContent(),
)
```

### Gradient Card (with hover)
```dart
GradientCard(
  colors: [
    AppTheme.primaryOrange.withValues(alpha: 0.2),
    AppTheme.primaryOrangeDark.withValues(alpha: 0.1),
  ],
  enableShadow: true,
  child: YourContent(),
)
```

### Glow Card (for active elements)
```dart
GlowCard(
  glowColor: AppTheme.primaryOrange,
  child: YourContent(),
)
```

---

## 6. Haptic Feedback - Add to ALL User Actions

### Simple Usage
```dart
onPressed: () {
  HapticService.instance.light();  // Light tap
  performAction();
}
```

### All Haptic Types
```dart
HapticService.instance.selection()     // List/tab selection
HapticService.instance.light()         // Light button tap
HapticService.instance.medium()        // Important action
HapticService.instance.heavy()         // Critical action
HapticService.instance.success()       // Success feedback (2 taps)
HapticService.instance.warning()       // Warning (3 taps)
HapticService.instance.error()         // Error (heavy + vibrate)
HapticService.instance.toggle(true)    // Toggle switch
```

### Automatic Haptic Wrapper
```dart
HapticTap(
  hapticType: HapticType.lightImpact,
  onTap: onAction,
  child: YourWidget(),
)
```

---

## 7. Visual Polish Components

### Status Indicator
```dart
StatusIndicator(
  isActive: device.isOnline,
  activeLabel: 'Активно',
  inactiveLabel: 'Отключено',
  enablePulse: true,  // Pulsating glow
)
```

### Animated Badge
```dart
AnimatedBadge(
  label: 'Новое',
  backgroundColor: AppTheme.primaryOrange,
  icon: Icons.star,
  isNew: true,  // Shows red dot + shimmer
)
```

### Progress Indicator
```dart
PremiumProgressIndicator(
  value: 0.75,  // 0.0 to 1.0
  showPercentage: true,
  gradient: AppTheme.primaryGradient,
)
```

---

## 8. Complete Example - Modern Screen

```dart
class ModernDeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: Text('Устройства', style: AppTypography.h3),
        actions: [
          AnimatedIconButton(
            icon: Icons.settings,
            onPressed: () {
              HapticService.instance.light();
              Navigator.push(context, ...);
            },
          ),
        ],
      ),
      body: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          // Loading State
          if (state is DeviceLoading) {
            return ListView(
              padding: EdgeInsets.all(AppSpacing.mdR),
              children: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.mdR),
                  child: DeviceCardSkeleton(),
                ),
              ),
            );
          }

          // Empty State
          if (state is DeviceEmpty) {
            return NoDevicesEmptyState(
              onAddDevice: () {
                HapticService.instance.medium();
                context.read<DeviceBloc>().add(AddDevicePressed());
              },
            );
          }

          // Error State
          if (state is DeviceError) {
            return OfflineEmptyState(
              onRetry: () {
                HapticService.instance.medium();
                context.read<DeviceBloc>().add(RetryLoading());
              },
            );
          }

          // Success State
          if (state is DeviceLoaded) {
            return ListView.builder(
              padding: EdgeInsets.all(AppSpacing.mdR),
              itemCount: state.devices.length,
              itemBuilder: (context, index) {
                final device = state.devices[index];

                return GlassmorphicCard(
                  margin: EdgeInsets.only(bottom: AppSpacing.mdR),
                  onTap: () {
                    HapticService.instance.selection();
                    Navigator.push(context, ...);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Text(
                            device.name,
                            style: AppTypography.h4,
                          ),
                          Spacer(),
                          StatusIndicator(
                            isActive: device.isOnline,
                            enablePulse: true,
                          ),
                        ],
                      ),

                      SizedBox(height: AppSpacing.smR),

                      // Subtitle
                      Text(
                        device.location,
                        style: AppTypography.caption,
                      ),

                      SizedBox(height: AppSpacing.mdR),

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStat('Температура', '${device.temp}°C'),
                          _buildStat('Влажность', '${device.humidity}%'),
                          _buildStat('Скорость', '${device.fanSpeed}'),
                        ],
                      ),

                      SizedBox(height: AppSpacing.lgR),

                      // Action Button
                      AnimatedPrimaryButton(
                        label: 'Управление',
                        icon: Icons.settings,
                        onPressed: () {
                          HapticService.instance.light();
                          Navigator.push(context, ...);
                        },
                        isExpanded: true,
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
      floatingActionButton: AnimatedFAB(
        icon: Icons.add,
        label: 'Добавить',
        onPressed: () {
          HapticService.instance.medium();
          context.read<DeviceBloc>().add(AddDevicePressed());
        },
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.bodyMedium),
        SizedBox(height: AppSpacing.xxsR),
        Text(label, style: AppTypography.label),
      ],
    );
  }
}
```

---

## 9. Migration Checklist

Use this for each screen you update:

### Typography
- [ ] Replace all `TextStyle(...)` with `AppTypography.*`
- [ ] Verify responsive sizing (no hard-coded font sizes)
- [ ] Test on different screen sizes

### Buttons
- [ ] Replace `ElevatedButton` with `AnimatedPrimaryButton`
- [ ] Replace `OutlinedButton` with `AnimatedOutlineButton`
- [ ] Replace `IconButton` with `AnimatedIconButton`
- [ ] Replace `FloatingActionButton` with `AnimatedFAB`

### States
- [ ] Add skeleton loader for `isLoading` state
- [ ] Add empty state for `isEmpty` condition
- [ ] Add error state with retry action
- [ ] Test all state transitions

### Haptics
- [ ] Add haptic to all button taps
- [ ] Add haptic to toggles/switches
- [ ] Add haptic to slider changes
- [ ] Add haptic to list item selection

### Visual Polish
- [ ] Add status indicators where applicable
- [ ] Add badges for notifications/alerts
- [ ] Add progress bars for metrics
- [ ] Test animations at 60fps

---

## 10. Common Patterns

### Pattern 1: Card with Header + Stats + Action
```dart
GlassmorphicCard(
  child: Column(
    children: [
      // Header
      Row(
        children: [
          Text('Title', style: AppTypography.h4),
          Spacer(),
          StatusIndicator(isActive: true),
        ],
      ),
      SizedBox(height: AppSpacing.mdR),

      // Stats
      Row(
        children: stats.map((s) => _buildStat(s)).toList(),
      ),
      SizedBox(height: AppSpacing.lgR),

      // Action
      AnimatedPrimaryButton(
        label: 'Action',
        onPressed: onAction,
      ),
    ],
  ),
)
```

### Pattern 2: BLoC State Management
```dart
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    if (state is Loading) return MySkeleton();
    if (state is Empty) return MyEmptyState();
    if (state is Error) return OfflineEmptyState(onRetry: onRetry);
    if (state is Loaded) return _buildContent(state.data);
    return Container();
  },
)
```

### Pattern 3: List with Skeletons
```dart
isLoading
  ? ListView.builder(
      itemCount: 3,
      itemBuilder: (_, i) => DeviceCardSkeleton(),
    )
  : ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) => _buildItem(items[i]),
    )
```

---

## Performance Tips

1. **Use const constructors** where possible:
   ```dart
   const AnimatedPrimaryButton(...)
   ```

2. **Dispose controllers** properly (already handled in components)

3. **Lazy load** heavy animations:
   ```dart
   enableAnimation: mounted && visible
   ```

4. **Test on low-end devices** - all animations are 60fps optimized

---

## Testing Checklist

- [ ] All text is readable (contrast check)
- [ ] All buttons are tappable (48x48dp minimum)
- [ ] All animations run smoothly (60fps)
- [ ] Haptic feedback works on device
- [ ] Loading states appear correctly
- [ ] Empty states show proper messages
- [ ] Error states allow retry
- [ ] Responsive on tablet/desktop

---

## Need Help?

Refer to the comprehensive documentation:
- **BIG_TECH_UI_UX_POLISH_REPORT.md** - Full technical details
- **Component source files** - IntelliSense will show all properties

**Quick Links:**
- Typography: `lib/core/theme/app_typography.dart`
- Buttons: `lib/presentation/widgets/common/animated_button.dart`
- Cards: `lib/presentation/widgets/common/glassmorphic_card.dart`
- Loading: `lib/presentation/widgets/common/enhanced_shimmer.dart`
- Empty: `lib/presentation/widgets/common/enhanced_empty_state.dart`
- Haptics: `lib/core/services/haptic_service.dart`

---

**Start with one screen, test thoroughly, then roll out to others.**
**Quality over speed - ensure each screen is pixel-perfect before moving on.**
