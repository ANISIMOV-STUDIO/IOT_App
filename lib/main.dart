/// BREEZ Home Application
///
/// Cross-platform HVAC management app with MQTT integration
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_ui_kit/smart_ui_kit.dart';
import 'generated/l10n/app_localizations.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/theme_service.dart';
import 'core/services/language_service.dart';
import 'core/navigation/app_router.dart';
import 'presentation/bloc/hvac_list/hvac_list_bloc.dart';
import 'presentation/bloc/hvac_list/hvac_list_event.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/screens/zilon_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Add comment to force rebuild
  // Initialize dependencies
  await di.init();

  runApp(const HvacControlApp());
}

/// Responsive breakpoints configuration
/// Based on industry standards (Material Design, Bootstrap, Tailwind)
/// - Mobile: < 600px
/// - Tablet: 600px - 1024px
/// - Desktop: 1024px - 1920px
/// - Large Desktop: > 1920px (content max-width clamped to 1920px)

class HvacControlApp extends StatefulWidget {
  const HvacControlApp({super.key});

  @override
  State<HvacControlApp> createState() => _HvacControlAppState();
}

class _HvacControlAppState extends State<HvacControlApp> {
  late final GoRouter _router;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = di.sl<AuthBloc>()..add(const CheckAuthStatusEvent());
    _router = createRouter(_authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(
          create: (context) =>
              di.sl<HvacListBloc>()..add(const LoadHvacUnitsEvent()),
        ),
      ],
      child: ListenableBuilder(
        listenable: Listenable.merge([
          di.sl<ThemeService>(),
          di.sl<LanguageService>(),
        ]),
        builder: (context, child) {
          final languageService = di.sl<LanguageService>();

          return MaterialApp.router(
            routerConfig: _router,
            title: 'BREEZ Home',
            debugShowCheckedModeBanner: false,

            // Theme - Light with Blue & White Balance (Corporate Colors)
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.light, // Light theme - blue & white balanced

            // Localization - Russian (default) and English
            // Automatically switches based on LanguageService.currentLocale
            locale: languageService.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageService.supportedLocales, // ['ru', 'en']

            // Responsive Framework - Industry Standard Approach
            builder: (context, widget) => Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ResponsiveBreakpoints(
                breakpoints: const [
                  Breakpoint(start: 0, end: 599, name: MOBILE),
                  Breakpoint(start: 600, end: 1023, name: TABLET),
                  Breakpoint(start: 1024, end: 1919, name: DESKTOP),
                  Breakpoint(start: 1920, end: double.infinity, name: '4K'),
                ],
                child: Builder(
                  builder: (context) => ResponsiveScaledBox(
                    width: ResponsiveValue<double>(
                      context,
                      defaultValue: 1920,
                      conditionalValues: [
                        const Condition.equals(name: MOBILE, value: 375),
                        const Condition.between(
                            start: 600, end: 1024, value: 768),
                        const Condition.largerThan(name: TABLET, value: 1920),
                      ],
                    ).value,
                    child: widget!,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }
}
