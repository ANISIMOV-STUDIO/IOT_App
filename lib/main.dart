/// HVAC Control Application
///
/// Cross-platform HVAC management app with MQTT integration
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n/app_localizations.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
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

        return MaterialApp(
          title: 'HVAC Control',
          debugShowCheckedModeBanner: false,

          // Theme - Dark with Orange Accents (Figma Design)
          theme: AppTheme.darkTheme(),
          darkTheme: AppTheme.darkTheme(),
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

          home: MultiBlocProvider(
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
                      backgroundColor: AppTheme.backgroundDark,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryOrange,
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
  }
}
