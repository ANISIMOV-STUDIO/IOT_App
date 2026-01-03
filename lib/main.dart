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
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/devices/devices_bloc.dart';
import 'presentation/bloc/climate/climate_bloc.dart';
import 'presentation/bloc/notifications/notifications_bloc.dart';
import 'presentation/bloc/analytics/analytics_bloc.dart';
import 'presentation/bloc/connectivity/connectivity_bloc.dart';
import 'presentation/bloc/schedule/schedule_bloc.dart';

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
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Создаём AuthBloc и сразу запускаем проверку сессии
    _authBloc = di.sl<AuthBloc>()..add(const AuthCheckRequested());
    // Router получает AuthBloc для refreshListenable и redirect
    _router = createRouter(_authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthBloc уже создан в initState - используем .value
        BlocProvider.value(value: _authBloc),
        // DevicesBloc — управление списком HVAC устройств
        BlocProvider(
          create: (context) => di.sl<DevicesBloc>(),
        ),
        // ClimateBloc — управление климатом текущего устройства
        BlocProvider(
          create: (context) => di.sl<ClimateBloc>(),
        ),
        // NotificationsBloc — уведомления устройств
        BlocProvider(
          create: (context) => di.sl<NotificationsBloc>(),
        ),
        // AnalyticsBloc — статистика и графики
        BlocProvider(
          create: (context) => di.sl<AnalyticsBloc>(),
        ),
        // ConnectivityBloc — мониторинг сетевого соединения
        BlocProvider(
          create: (context) => di.sl<ConnectivityBloc>(),
        ),
        // ScheduleBloc — расписание устройств
        BlocProvider(
          create: (context) => di.sl<ScheduleBloc>(),
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
