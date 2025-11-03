/// HVAC Control Application
///
/// Cross-platform HVAC management app with MQTT integration
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.init();

  runApp(const HvacControlApp());
}

/// Get responsive design size based on screen width
/// For web/desktop, we use a fixed large size since ScreenUtil
/// works best with a consistent design size
Size _getDesignSize(double width) {
  if (width >= 1200) {
    // Desktop: based on 1920x1080
    return const Size(1920, 1080);
  } else if (width >= 600) {
    // Tablet: based on iPad (768x1024)
    return const Size(768, 1024);
  } else {
    // Mobile: based on iPhone X (375x812)
    return const Size(375, 812);
  }
}

class HvacControlApp extends StatelessWidget {
  const HvacControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        di.sl<ThemeService>(),
        di.sl<LanguageService>(),
      ]),
      builder: (context, child) {
        final languageService = di.sl<LanguageService>();

        return LayoutBuilder(
          builder: (context, constraints) {
            final designSize = _getDesignSize(constraints.maxWidth);
            return ScreenUtilInit(
              key: ValueKey(designSize),
              designSize: designSize,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp(
                  title: 'HVAC Control',
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

                  home: child,
                );
              },
              child: MultiBlocProvider(
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
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                // Handle auth state changes globally if needed
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return const ResponsiveShell();
                  } else if (state is AuthUnauthenticated || state is AuthError) {
                    return const LoginScreen();
                  } else {
                    // Loading or initial state
                    return const Scaffold(
                      backgroundColor: HvacColors.backgroundDark,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: HvacColors.primaryOrange,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
            );
          },
        );
      },
    );
  }
}
