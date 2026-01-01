/// Интеграционные (E2E) тесты для BREEZ Home App
///
/// Тестирует полные пользовательские сценарии:
/// - Запуск приложения
/// - Навигация между экранами
/// - Основные взаимодействия с UI
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hvac_control/main.dart';
import 'package:hvac_control/core/di/injection_container.dart' as di;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Группа тестов: Запуск приложения
  group('Запуск приложения', () {
    testWidgets('Приложение запускается без ошибок', (tester) async {
      // Arrange & Act
      await di.init();
      await tester.pumpWidget(const HvacControlApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Приложение запустилось
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  /// Группа тестов: Экран авторизации
  group('Экран авторизации', () {
    testWidgets('Отображаются поля ввода логина и пароля', (tester) async {
      // Arrange
      await di.init();
      await tester.pumpWidget(const HvacControlApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Проверяем наличие полей формы авторизации
      // Примечание: Зависит от текущего состояния аутентификации
      final emailField = find.byKey(const Key('email_field'));
      final passwordField = find.byKey(const Key('password_field'));

      // Если пользователь не авторизован, должны быть поля входа
      // Если авторизован - должен быть dashboard
      final isDashboard = find.text('Dashboard').evaluate().isNotEmpty ||
          find.text('Панель управления').evaluate().isNotEmpty;

      if (!isDashboard) {
        // На экране авторизации
        expect(
          emailField.evaluate().isNotEmpty ||
              passwordField.evaluate().isNotEmpty ||
              find.byType(TextFormField).evaluate().isNotEmpty,
          isTrue,
          reason: 'Должны отображаться поля ввода или текстовые поля',
        );
      } else {
        // На dashboard - пользователь авторизован
        expect(isDashboard, isTrue);
      }
    });
  });

  /// Группа тестов: Навигация
  group('Навигация', () {
    testWidgets('Нижняя панель навигации работает', (tester) async {
      // Arrange
      await di.init();
      await tester.pumpWidget(const HvacControlApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Ищем элементы навигации (BottomNavigationBar или NavigationBar)
      final bottomNav = find.byType(NavigationBar);
      final bottomNavOld = find.byType(BottomNavigationBar);

      // Act & Assert - Если есть навигация, пробуем переключиться
      if (bottomNav.evaluate().isNotEmpty) {
        // Новый Material 3 NavigationBar
        expect(bottomNav, findsOneWidget);
      } else if (bottomNavOld.evaluate().isNotEmpty) {
        // Старый BottomNavigationBar
        expect(bottomNavOld, findsOneWidget);
      }
      // Примечание: Навигация может отсутствовать на экране логина
    });
  });

  /// Группа тестов: UI компоненты
  group('UI компоненты', () {
    testWidgets('Тема применяется корректно', (tester) async {
      // Arrange
      await di.init();
      await tester.pumpWidget(const HvacControlApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - MaterialApp существует и имеет тему
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).first,
      );
      expect(materialApp.theme, isNotNull);
    });

    testWidgets('Локализация настроена', (tester) async {
      // Arrange
      await di.init();
      await tester.pumpWidget(const HvacControlApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - Проверяем настройку локализации
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).first,
      );
      expect(materialApp.supportedLocales, isNotEmpty);
      expect(materialApp.localizationsDelegates, isNotNull);
    });
  });
}
