/// Accessible Button Components
/// Main export file for accessible button widgets
library;

// Export all button components
export 'buttons/button_types.dart';
export 'buttons/base_accessible_button.dart';
export 'buttons/accessible_icon_button.dart';
export 'buttons/accessible_fab.dart';
export 'buttons/button_factories.dart';

// For backwards compatibility, re-export main components with original names
import 'buttons/base_accessible_button.dart';

typedef AccessibleButton = BaseAccessibleButton;