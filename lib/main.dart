/// BREEZ Home Application
///
/// Cross-platform HVAC dashboard
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'core/theme/app_theme.dart';
import 'generated/l10n/app_localizations.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/language_service.dart';
import 'core/navigation/app_router.dart';
import 'presentation/bloc/dashboard/dashboard_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.init();

  runApp(const HvacControlApp());
}

class HvacControlApp extends StatefulWidget {
  const HvacControlApp({super.key});

  @override
  State<HvacControlApp> createState() => _HvacControlAppState();
}

class _HvacControlAppState extends State<HvacControlApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<DashboardBloc>()..add(const DashboardStarted()),
        ),
      ],
      child: ListenableBuilder(
        listenable: di.sl<LanguageService>(),
        builder: (context, child) {
          final languageService = di.sl<LanguageService>();

          return AdaptiveTheme(
            light: AppTheme.light,
            dark: AppTheme.dark,
            initial: AdaptiveThemeMode.light,
            builder: (theme, darkTheme) => MaterialApp.router(
              routerConfig: _router,
              title: 'BREEZ Home',
              debugShowCheckedModeBanner: false,

              // Theme
              theme: theme,
              darkTheme: darkTheme,

              // Localization
              locale: languageService.currentLocale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: LanguageService.supportedLocales,

              // Responsive breakpoints
              builder: (context, widget) => ResponsiveBreakpoints.builder(
                breakpoints: const [
                  Breakpoint(start: 0, end: 599, name: MOBILE),
                  Breakpoint(start: 600, end: 1023, name: TABLET),
                  Breakpoint(start: 1024, end: 1919, name: DESKTOP),
                  Breakpoint(start: 1920, end: double.infinity, name: '4K'),
                ],
                child: widget!,
              ),
            ),
          );
        },
      ),
    );
  }
}
