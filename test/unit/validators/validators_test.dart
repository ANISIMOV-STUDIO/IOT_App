/// Тесты для валидаторов
///
/// Проверяет все функции валидации:
/// - loginEmail / loginPassword (упрощённые для входа)
/// - email (полная валидация для регистрации)
/// - password (проверка сложности)
/// - confirmPassword (совпадение паролей)
/// - name (валидация имени)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/core/utils/validators.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';

/// Mock реализация AppLocalizations для тестов
class MockAppLocalizations implements AppLocalizations {
  @override String get enterEmail => 'Введите email';
  @override String get enterPassword => 'Введите пароль';
  @override String get invalidEmailFormat => 'Неверный формат email';
  @override String get passwordOnlyLatin => 'Пароль должен содержать только латинские буквы';
  @override String get passwordMustContainDigit => 'Должен содержать хотя бы одну цифру';
  @override String get passwordMustContainLetter => 'Должен содержать хотя бы одну латинскую букву';
  @override String get confirmPasswordRequired => 'Подтвердите пароль';
  @override String get passwordsDoNotMatch => 'Пароли не совпадают';
  @override String get enterName => 'Введите имя';
  @override String get nameOnlyLetters => 'Только буквы (допускаются пробелы и дефис)';
  @override String get firstName => 'имя';

  @override String passwordTooShort(int count) => 'Минимум $count символов';
  @override String enterField(String fieldName) => 'Введите $fieldName';
  @override String nameTooShort(String fieldName) => 'Минимум 2 символа';

  // Заглушки для остальных методов (не используются в тестах валидаторов)
  @override dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  late Validators validators;

  setUp(() {
    validators = Validators(MockAppLocalizations());
  });

  group('Validators.loginEmail', () {
    test('возвращает null для валидного email', () {
      expect(validators.loginEmail('test@example.com'), isNull);
    });

    test('возвращает null для email без точки в домене (упрощённая валидация)', () {
      // Упрощённая валидация для логина - просто проверка на пустоту
      expect(validators.loginEmail('test@domain'), isNull);
    });

    test('возвращает ошибку для пустой строки', () {
      expect(validators.loginEmail(''), equals('Введите email'));
    });

    test('возвращает ошибку для строки с пробелами', () {
      expect(validators.loginEmail('   '), equals('Введите email'));
    });

    test('возвращает ошибку для null', () {
      expect(validators.loginEmail(null), equals('Введите email'));
    });
  });

  group('Validators.loginPassword', () {
    test('возвращает null для валидного пароля', () {
      expect(validators.loginPassword('password123'), isNull);
    });

    test('возвращает null для короткого пароля (упрощённая валидация)', () {
      // Упрощённая валидация для логина - просто проверка на пустоту
      expect(validators.loginPassword('abc'), isNull);
    });

    test('возвращает ошибку для пустой строки', () {
      expect(validators.loginPassword(''), equals('Введите пароль'));
    });

    test('возвращает ошибку для null', () {
      expect(validators.loginPassword(null), equals('Введите пароль'));
    });
  });

  group('Validators.email (регистрация)', () {
    test('возвращает null для валидного email', () {
      expect(validators.email('test@example.com'), isNull);
    });

    test('возвращает null для email с поддоменом', () {
      expect(validators.email('user@mail.example.com'), isNull);
    });

    test('возвращает null для email с плюсом', () {
      expect(validators.email('test+tag@example.com'), isNull);
    });

    test('возвращает ошибку для пустой строки', () {
      expect(validators.email(''), isNotNull);
    });

    test('возвращает ошибку для null', () {
      expect(validators.email(null), isNotNull);
    });

    test('возвращает ошибку для email без @', () {
      expect(validators.email('testexample.com'), isNotNull);
    });

    test('возвращает ошибку для email без домена', () {
      expect(validators.email('test@'), isNotNull);
    });

    test('возвращает ошибку для email без имени', () {
      expect(validators.email('@example.com'), isNotNull);
    });
  });

  group('Validators.password (регистрация)', () {
    test('возвращает null для валидного пароля', () {
      expect(validators.password('Password123!'), isNull);
    });

    test('возвращает null для пароля ровно 8 символов', () {
      expect(validators.password('Pass123!'), isNull);
    });

    test('возвращает null для длинного пароля', () {
      expect(validators.password('VeryLongPassword123!@#'), isNull);
    });

    test('возвращает ошибку для пустого пароля', () {
      expect(validators.password(''), equals('Введите пароль'));
    });

    test('возвращает ошибку для null', () {
      expect(validators.password(null), equals('Введите пароль'));
    });

    test('возвращает ошибку для короткого пароля (< 8 символов)', () {
      expect(validators.password('Pass1!'), equals('Минимум 8 символов'));
    });

    test('возвращает ошибку для пароля без цифр', () {
      expect(
        validators.password('PasswordABC!'),
        equals('Должен содержать хотя бы одну цифру'),
      );
    });

    test('возвращает ошибку для пароля без букв', () {
      expect(
        validators.password('12345678!'),
        equals('Должен содержать хотя бы одну латинскую букву'),
      );
    });

    test('возвращает ошибку для пароля с кириллицей', () {
      expect(
        validators.password('Пароль123!'),
        equals('Пароль должен содержать только латинские буквы'),
      );
    });

    test('возвращает ошибку для пароля с кириллической буквой в середине', () {
      expect(
        validators.password('Passwoрd123!'),
        equals('Пароль должен содержать только латинские буквы'),
      );
    });

    test('проверяет кастомную минимальную длину', () {
      expect(validators.password('Pass1!', minLength: 6), isNull);
      expect(validators.password('Pa1!', minLength: 6), equals('Минимум 6 символов'));
    });
  });

  group('Validators.confirmPassword', () {
    test('возвращает null когда пароли совпадают', () {
      expect(validators.confirmPassword('Password123!', 'Password123!'), isNull);
    });

    test('возвращает ошибку для пустого подтверждения', () {
      expect(validators.confirmPassword('', 'Password123!'), isNotNull);
    });

    test('возвращает ошибку для null подтверждения', () {
      expect(validators.confirmPassword(null, 'Password123!'), isNotNull);
    });

    test('возвращает ошибку когда пароли не совпадают', () {
      final result = validators.confirmPassword('Password123!', 'Different456!');
      expect(result, equals('Пароли не совпадают'));
    });

    test('возвращает ошибку при частичном совпадении', () {
      final result = validators.confirmPassword('Password123', 'Password123!');
      expect(result, equals('Пароли не совпадают'));
    });

    test('обрабатывает null пароль корректно', () {
      final result = validators.confirmPassword('Password123!', null);
      expect(result, equals('Пароли не совпадают'));
    });
  });

  group('Validators.name', () {
    test('возвращает null для валидного имени на кириллице', () {
      expect(validators.name('Иван'), isNull);
    });

    test('возвращает null для валидного имени на латинице', () {
      expect(validators.name('John'), isNull);
    });

    test('возвращает null для имени с пробелом', () {
      expect(validators.name('Анна Мария'), isNull);
    });

    test('возвращает null для имени с дефисом', () {
      expect(validators.name('Жан-Пьер'), isNull);
    });

    test('возвращает null для имени ровно 2 символа', () {
      expect(validators.name('Ян'), isNull);
    });

    test('возвращает ошибку для пустого имени', () {
      expect(validators.name(''), isNotNull);
    });

    test('возвращает ошибку для null', () {
      expect(validators.name(null), isNotNull);
    });

    test('возвращает ошибку для короткого имени (< 2 символов)', () {
      expect(validators.name('И'), equals('Минимум 2 символа'));
    });

    test('возвращает ошибку для имени с цифрами', () {
      expect(
        validators.name('Иван123'),
        equals('Только буквы (допускаются пробелы и дефис)'),
      );
    });

    test('возвращает ошибку для имени со спецсимволами', () {
      expect(
        validators.name('Иван@'),
        equals('Только буквы (допускаются пробелы и дефис)'),
      );
    });

    test('использует кастомное имя поля в ошибке', () {
      final result = validators.name('', fieldName: 'фамилию');
      expect(result, equals('Введите фамилию'));
    });
  });
}
