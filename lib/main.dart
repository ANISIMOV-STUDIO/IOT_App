/// BREEZ Home Application
///
/// Cross-platform HVAC dashboard
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'generated/l10n/app_localizations.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/language_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/toast_service.dart';
import 'core/navigation/app_router.dart';
import 'core/logging/talker_config.dart';
import 'presentation/bloc/dashboard/dashboard_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error handler with Talker
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    TalkerConfig.talker.handle(
      details.exception,
      details.stack,
      'Flutter Error',
    );
  };

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
          create: (context) =>
              di.sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        // DashboardBloc предоставляется глобально, но НЕ запускается здесь.
        // DashboardStarted диспатчится в app_router.dart только после авторизации
        BlocProvider(
          create: (context) => di.sl<DashboardBloc>(),
        ),
      ],
      child: ListenableBuilder(
        listenable: Listenable.merge([
          di.sl<LanguageService>(),
          di.sl<ThemeService>(),
        ]),
        builder: (context, child) {
          final languageService = di.sl<LanguageService>();
          final themeService = di.sl<ThemeService>();

          return MaterialApp.router(
            scaffoldMessengerKey: scaffoldMessengerKey,
            routerConfig: _router,
            title: 'BREEZ Home',
            debugShowCheckedModeBanner: false,

            // Material theme
            theme: AppTheme.materialLight,
            darkTheme: AppTheme.materialDark,
            themeMode: themeService.themeMode,

            // Localization
            locale: languageService.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageService.supportedLocales,
          );
        },
      ),
    );
  }
}
