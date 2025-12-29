/// Утилиты валидации
library;

import 'package:form_builder_validators/form_builder_validators.dart';

class Validators {
  /// Упрощенная валидация email для логина (только проверка на пустоту)
  /// Если пользователь введет неправильный email - просто не зайдет
  static String? loginEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите email';
    }
    return null;
  }

  /// Упрощенная валидация пароля для логина (только проверка на пустоту)
  /// Полная валидация не нужна - если пароль неправильный, то не зайдет
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    return null;
  }

  /// Валидация email для регистрации с проверкой формата
  static String? email(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Введите email'),
      FormBuilderValidators.email(errorText: 'Неверный формат email'),
    ])(value);
  }

  /// Валидация пароля (соответствует требованиям бэкенда)
  /// - Минимум 8 символов
  /// - Хотя бы одна цифра
  /// - Хотя бы одна латинская буква
  /// - Только латинские буквы, цифры и спецсимволы (без кириллицы)
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }

    if (value.length < minLength) {
      return 'Минимум $minLength символов';
    }

    // Проверка на кириллицу
    if (RegExp(r'[а-яА-ЯёЁ]').hasMatch(value)) {
      return 'Пароль должен содержать только латинские буквы';
    }

    // Проверка на наличие цифры
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Должен содержать хотя бы одну цифру';
    }

    // Проверка на наличие латинской буквы
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Должен содержать хотя бы одну латинскую букву';
    }

    return null;
  }

  /// Валидация подтверждения пароля
  static String? confirmPassword(String? value, String? password) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Подтвердите пароль'),
      FormBuilderValidators.equal(
        password ?? '',
        errorText: 'Пароли не совпадают',
      ),
    ])(value);
  }

  /// Валидация имени (без цифр и спецсимволов)
  static String? name(String? value, {String? fieldName}) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(
        errorText: fieldName != null ? 'Введите $fieldName' : 'Введите имя',
      ),
      FormBuilderValidators.minLength(
        2,
        errorText: 'Минимум 2 символа',
      ),
      FormBuilderValidators.match(
        RegExp(r'^[а-яА-ЯёЁa-zA-Z\s-]+$'),
        errorText: 'Только буквы (допускаются пробелы и дефис)',
      ),
    ])(value);
  }
}
