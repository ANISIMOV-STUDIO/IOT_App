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

void main() {
  group('Validators.loginEmail', () {
    test('возвращает null для валидного email', () {
      expect(Validators.loginEmail('test@example.com'), isNull);
    });

    test('возвращает null для email без точки в домене (упрощённая валидация)', () {
      // Упрощённая валидация для логина - просто проверка на пустоту
      expect(Validators.loginEmail('test@domain'), isNull);
    });

    test('возвращает ошибку для пустой строки', () {
      expect(Validators.loginEmail(''), equals('Введите email'));
    });

    test('возвращает ошибку для строки с пробелами', () {
      expect(Validators.loginEmail('   '), equals('Введите email'));
    });

    test('возвращает ошибку для null', () {
      expect(Validators.loginEmail(null), equals('Введите email'));
    });
  });

  group('Validators.loginPassword', () {
    test('возвращает null для валидного пароля', () {
      expect(Validators.loginPassword('password123'), isNull);
    });

    test('возвращает null для короткого пароля (упрощённая валидация)', () {
      // Упрощённая валидация для логина - просто проверка на пустоту
      expect(Validators.loginPassword('abc'), isNull);
    });

    test('возвращает ошибку для пустой строки', () {
      expect(Validators.loginPassword(''), equals('Введите пароль'));
    });

    test('возвращает ошибку для null', () {
      expect(Validators.loginPassword(null), equals('Введите пароль'));
    });
  });

  group('Validators.email (регистрация)', () {
    test('возвращает null для валидного email', () {
      expect(Validators.email('test@example.com'), isNull);
    });

    test('возвращает null для email с поддоменом', () {
      expect(Validators.email('user@mail.example.com'), isNull);
    });

    test('возвращает null для email с плюсом', () {
      expect(Validators.email('test+tag@example.com'), isNull);
    });

    test('возвращает ошибку для пустой строки', () {
      expect(Validators.email(''), isNotNull);
    });

    test('возвращает ошибку для null', () {
      expect(Validators.email(null), isNotNull);
    });

    test('возвращает ошибку для email без @', () {
      expect(Validators.email('testexample.com'), isNotNull);
    });

    test('возвращает ошибку для email без домена', () {
      expect(Validators.email('test@'), isNotNull);
    });

    test('возвращает ошибку для email без имени', () {
      expect(Validators.email('@example.com'), isNotNull);
    });
  });

  group('Validators.password (регистрация)', () {
    test('возвращает null для валидного пароля', () {
      expect(Validators.password('Password123!'), isNull);
    });

    test('возвращает null для пароля ровно 8 символов', () {
      expect(Validators.password('Pass123!'), isNull);
    });

    test('возвращает null для длинного пароля', () {
      expect(Validators.password('VeryLongPassword123!@#'), isNull);
    });

    test('возвращает ошибку для пустого пароля', () {
      expect(Validators.password(''), equals('Введите пароль'));
    });

    test('возвращает ошибку для null', () {
      expect(Validators.password(null), equals('Введите пароль'));
    });

    test('возвращает ошибку для короткого пароля (< 8 символов)', () {
      expect(Validators.password('Pass1!'), equals('Минимум 8 символов'));
    });

    test('возвращает ошибку для пароля без цифр', () {
      expect(
        Validators.password('PasswordABC!'),
        equals('Должен содержать хотя бы одну цифру'),
      );
    });

    test('возвращает ошибку для пароля без букв', () {
      expect(
        Validators.password('12345678!'),
        equals('Должен содержать хотя бы одну латинскую букву'),
      );
    });

    test('возвращает ошибку для пароля с кириллицей', () {
      expect(
        Validators.password('Пароль123!'),
        equals('Пароль должен содержать только латинские буквы'),
      );
    });

    test('возвращает ошибку для пароля с кириллической буквой в середине', () {
      expect(
        Validators.password('Passwoрd123!'),
        equals('Пароль должен содержать только латинские буквы'),
      );
    });

    test('проверяет кастомную минимальную длину', () {
      expect(Validators.password('Pass1!', minLength: 6), isNull);
      expect(Validators.password('Pa1!', minLength: 6), equals('Минимум 6 символов'));
    });
  });

  group('Validators.confirmPassword', () {
    test('возвращает null когда пароли совпадают', () {
      expect(Validators.confirmPassword('Password123!', 'Password123!'), isNull);
    });

    test('возвращает ошибку для пустого подтверждения', () {
      expect(Validators.confirmPassword('', 'Password123!'), isNotNull);
    });

    test('возвращает ошибку для null подтверждения', () {
      expect(Validators.confirmPassword(null, 'Password123!'), isNotNull);
    });

    test('возвращает ошибку когда пароли не совпадают', () {
      final result = Validators.confirmPassword('Password123!', 'Different456!');
      expect(result, equals('Пароли не совпадают'));
    });

    test('возвращает ошибку при частичном совпадении', () {
      final result = Validators.confirmPassword('Password123', 'Password123!');
      expect(result, equals('Пароли не совпадают'));
    });

    test('обрабатывает null пароль корректно', () {
      final result = Validators.confirmPassword('Password123!', null);
      expect(result, equals('Пароли не совпадают'));
    });
  });

  group('Validators.name', () {
    test('возвращает null для валидного имени на кириллице', () {
      expect(Validators.name('Иван'), isNull);
    });

    test('возвращает null для валидного имени на латинице', () {
      expect(Validators.name('John'), isNull);
    });

    test('возвращает null для имени с пробелом', () {
      expect(Validators.name('Анна Мария'), isNull);
    });

    test('возвращает null для имени с дефисом', () {
      expect(Validators.name('Жан-Пьер'), isNull);
    });

    test('возвращает null для имени ровно 2 символа', () {
      expect(Validators.name('Ян'), isNull);
    });

    test('возвращает ошибку для пустого имени', () {
      expect(Validators.name(''), isNotNull);
    });

    test('возвращает ошибку для null', () {
      expect(Validators.name(null), isNotNull);
    });

    test('возвращает ошибку для короткого имени (< 2 символов)', () {
      expect(Validators.name('И'), equals('Минимум 2 символа'));
    });

    test('возвращает ошибку для имени с цифрами', () {
      expect(
        Validators.name('Иван123'),
        equals('Только буквы (допускаются пробелы и дефис)'),
      );
    });

    test('возвращает ошибку для имени со спецсимволами', () {
      expect(
        Validators.name('Иван@'),
        equals('Только буквы (допускаются пробелы и дефис)'),
      );
    });

    test('использует кастомное имя поля в ошибке', () {
      final result = Validators.name('', fieldName: 'фамилию');
      expect(result, equals('Введите фамилию'));
    });
  });
}
