/// HVAC Control Application
///
/// Cross-platform HVAC management app with MQTT integration
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/services/theme_service.dart';
import 'presentation/bloc/hvac_list/hvac_list_bloc.dart';
import 'presentation/bloc/hvac_list/hvac_list_event.dart';
import 'presentation/pages/responsive_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.init();

  runApp(const HvacControlApp());
}

class HvacControlApp extends StatelessWidget {
  const HvacControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: di.sl<ThemeService>(),
      builder: (context, child) {
        return MaterialApp(
          title: 'HVAC Control',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: di.sl<ThemeService>().themeMode,
          home: BlocProvider(
            create: (context) => di.sl<HvacListBloc>()
              ..add(const LoadHvacUnitsEvent()),
            child: const ResponsiveShell(),
          ),
        );
      },
    );
  }
}
