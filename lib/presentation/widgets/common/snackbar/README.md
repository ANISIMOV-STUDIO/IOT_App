# Modular Snackbar System

## Overview
This directory contains the refactored snackbar system for the HVAC Control App. The original 565-line file has been split into 11 modular components, each under 250 lines, with enhanced web-responsive design and improved maintainability.

## Architecture

### Core Components

#### 1. **app_snackbar.dart** (223 lines)
- Main entry point maintaining backward compatibility
- Exports all snackbar functionality
- Provides legacy `AppSnackBar` and `AppToast` classes

#### 2. **base_snackbar.dart** (199 lines)
- Base snackbar implementation with shared logic
- Handles common functionality like haptic feedback
- Provides responsive layout adjustments
- Manages screen reader announcements

#### 3. **snackbar_types.dart** (90 lines)
- Enums: `SnackBarType`, `ToastPosition`
- Configuration classes: `SnackBarConfig`, `ErrorAction`
- Default configurations for each snackbar type

#### 4. **responsive_utils.dart** (150 lines)
- Web-responsive utilities
- Device type detection (mobile/tablet/desktop)
- Responsive sizing calculations
- Extension methods for responsive values (.w, .h, .sp, .r)

### Snackbar Variants

#### 5. **success_snackbar.dart** (159 lines)
- Success message displays
- Quick success notifications
- Operations completed confirmations
- Save/Update/Delete success messages

#### 6. **error_snackbar.dart** (240 lines)
- Error handling displays
- Network/Server/Validation errors
- Permission and authentication errors
- Technical details dialog support

#### 7. **warning_snackbar.dart** (200 lines)
- Warning notifications
- System alerts (low battery, maintenance)
- Temperature warnings
- Data loss warnings

#### 8. **info_snackbar.dart** (245 lines)
- Informational messages
- Tips and hints
- Update notifications
- Energy saving suggestions

#### 9. **loading_snackbar.dart** (238 lines)
- Loading indicators
- Progress tracking
- Upload/Download progress
- Indefinite operations

### Toast System

#### 10. **toast_notification.dart** (188 lines)
- Quick toast messages
- Network status changes
- Action confirmations
- Clipboard operations

#### 11. **toast_widget.dart** (198 lines)
- Toast UI implementation
- Hover effects for web
- Swipe-to-dismiss support
- Responsive positioning

## Usage Examples

### Basic Usage (Backward Compatible)
```dart
// Success message
AppSnackBar.showSuccess(
  context,
  message: 'Settings saved successfully',
);

// Error with retry
AppSnackBar.showError(
  context,
  message: 'Failed to connect',
  action: SnackBarAction(
    label: 'RETRY',
    onPressed: () => retry(),
  ),
);

// Loading indicator
final controller = AppSnackBar.showLoading(
  context,
  message: 'Processing...',
);
// Later...
LoadingSnackBar.hide(controller);
```

### Using Specific Variants
```dart
// Success with undo
SuccessSnackBar.showDeleted(
  context,
  itemName: 'Schedule',
  onUndo: () => undoDelete(),
);

// Network error
ErrorSnackBar.showNetworkError(
  context,
  onRetry: () => fetchData(),
);

// Temperature warning
WarningSnackBar.showTemperatureWarning(
  context,
  zone: 'Living Room',
  temperature: 32.5,
  unit: 'C',
  isHigh: true,
);

// Update available
InfoSnackBar.showUpdateAvailable(
  context,
  version: '2.1.0',
  onUpdate: () => installUpdate(),
);
```

### Toast Notifications
```dart
// Quick success
ToastNotification.showSuccess(
  context,
  message: 'Copied!',
);

// Network status
ToastNotification.showNetworkStatus(
  context,
  isOnline: false,
);

// Action completed
ToastNotification.showActionCompleted(
  context,
  action: 'Export',
);
```

## Web-Responsive Features

### Breakpoints
- Mobile: < 600px
- Tablet: 600-1024px
- Desktop: > 1024px

### Responsive Behavior
- **Mobile**: Full width snackbars, compact spacing
- **Tablet**: Max width 500px, medium spacing
- **Desktop**: Max width 450px, generous spacing

### Hover Effects (Web)
- Snackbars scale slightly on hover
- Close button appears on hover (when enabled)
- Cursor changes to pointer for interactive elements

## Migration Guide

### From Old to New
The system maintains 100% backward compatibility. Existing code will continue to work without changes.

```dart
// Old code (still works)
AppSnackBar.showSuccess(context, message: 'Done');

// New enhanced API (optional)
SuccessSnackBar.showCompleted(
  context,
  operation: 'Data sync',
  details: '150 items synchronized',
);
```

## Key Improvements

1. **Modular Design**: Each component has a single responsibility
2. **Web-Responsive**: Adapts to different screen sizes
3. **Accessibility**: Screen reader support, proper contrast ratios
4. **Type Safety**: Strongly typed configurations
5. **Performance**: Optimized animations, lazy loading
6. **Maintainability**: Each file under 250 lines
7. **Extensibility**: Easy to add new variants or features

## Testing

Each component should be tested independently:
- Widget tests for UI components
- Unit tests for utility functions
- Integration tests for the complete flow
- Golden tests for visual regression

## Contributing

When adding new features:
1. Keep files under 250 lines
2. Follow the existing pattern (variant classes extend base functionality)
3. Add responsive support using `ResponsiveUtils`
4. Include accessibility features
5. Update this README with usage examples