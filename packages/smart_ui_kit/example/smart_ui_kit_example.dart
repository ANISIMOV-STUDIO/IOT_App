// Example demonstrating Smart UI Kit usage
// ignore_for_file: avoid_print

import 'package:smart_ui_kit/smart_ui_kit.dart';

void main() {
  // Demonstrate theme access
  final lightTheme = NeumorphicThemeData.light();
  final darkTheme = NeumorphicThemeData.dark();
  
  print('Smart UI Kit loaded');
  print('Light theme surface: ${lightTheme.colors.surface}');
  print('Dark theme surface: ${darkTheme.colors.surface}');
}
