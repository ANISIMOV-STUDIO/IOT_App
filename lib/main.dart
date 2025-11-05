/// BREEZ Home Application
///
/// Cross-platform HVAC management app with MQTT integration
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'generated/l10n/app_localizations.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/theme_service.dart';
import 'core/services/language_service.dart';
import 'presentation/bloc/hvac_list/hvac_list_bloc.dart';
import 'presentation/bloc/hvac_list/hvac_list_event.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/pages/responsive_shell.dart';
import 'presentation/pages/login_screen.dart';
import 'presentation/widgets/common/login_skeleton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()
            ..add(const CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<HvacListBloc>()
            ..add(const LoadHvacUnitsEvent()),
        ),
      ],
      child: ListenableBuilder(
        listenable: Listenable.merge([
          di.sl<ThemeService>(),
          di.sl<LanguageService>(),
        ]),
        builder: (context, child) {
          final languageService = di.sl<LanguageService>();

          return MaterialApp(
            title: 'BREEZ Home',
            debugShowCheckedModeBanner: false,

            // Theme - Dark with Orange Accents (Figma Design)
            theme: HvacTheme.darkTheme(),
            darkTheme: HvacTheme.darkTheme(),
            themeMode: ThemeMode.dark, // Always use dark theme

            // Localization
            locale: languageService.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageService.supportedLocales,

            // Responsive Framework - Industry Standard Approach
            builder: (context, widget) => Container(
              color: HvacColors.backgroundDark,
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
                        const Condition.between(start: 600, end: 1024, value: 768),
                        const Condition.largerThan(name: TABLET, value: 1920),
                      ],
                    ).value,
                    child: widget!,
                  ),
                ),
              ),
            ),

            home: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                // Handle auth state changes globally if needed
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) {
                  // Only rebuild when auth state actually changes type
                  return previous.runtimeType != current.runtimeType;
                },
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return const ResponsiveShell();
                  } else if (state is AuthUnauthenticated || state is AuthError) {
                    return const LoginScreen();
                  } else {
                    // Loading or initial state - show login skeleton
                    return const LoginSkeleton();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
