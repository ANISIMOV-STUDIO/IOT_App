/// Утилиты валидации с поддержкой локализации
library;

import 'package:flutter/widgets.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:hvac_control/generated/l10n/app_localizations.dart';

/// Статические валидаторы с локализованными сообщениями.
/// Требует передачи AppLocalizations для корректного отображения ошибок.
class Validators {

  const Validators(this.l10n);

  /// Получить валидатор из BuildContext
  factory Validators.of(BuildContext context) => Validators(AppLocalizations.of(context)!);

  final AppLocalizations l10n;

  /// Упрощенная валидация email для логина (только проверка на пустоту)
  String? loginEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return l10n.enterEmail;
    }
    return null;
  }

  /// Упрощенная валидация пароля для логина (только проверка на пустоту)
  String? loginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.enterPassword;
    }
    return null;
  }

  /// Валидация email для регистрации с проверкой формата
  String? email(String? value) => FormBuilderValidators.compose<String>([
      FormBuilderValidators.required<String>(errorText: l10n.enterEmail),
      FormBuilderValidators.email(errorText: l10n.invalidEmailFormat),
    ])(value);

  /// Валидация пароля (соответствует требованиям бэкенда)
  /// - Минимум 8 символов
  /// - Хотя бы одна цифра
  /// - Хотя бы одна латинская буква
  /// - Только латинские буквы, цифры и спецсимволы (без кириллицы)
  String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return l10n.enterPassword;
    }

    if (value.length < minLength) {
      return l10n.passwordTooShort(minLength);
    }

    // Проверка на кириллицу
    if (RegExp('[а-яА-ЯёЁ]').hasMatch(value)) {
      return l10n.passwordOnlyLatin;
    }

    // Проверка на наличие цифры
    if (!RegExp('[0-9]').hasMatch(value)) {
      return l10n.passwordMustContainDigit;
    }

    // Проверка на наличие латинской буквы
    if (!RegExp('[a-zA-Z]').hasMatch(value)) {
      return l10n.passwordMustContainLetter;
    }

    return null;
  }

  /// Валидация подтверждения пароля
  String? confirmPassword(String? value, String? password) => FormBuilderValidators.compose<String>([
      FormBuilderValidators.required<String>(errorText: l10n.confirmPasswordRequired),
      FormBuilderValidators.equal<String>(
        password ?? '',
        errorText: l10n.passwordsDoNotMatch,
      ),
    ])(value);

  /// Валидация имени (без цифр и спецсимволов)
  String? name(String? value, {String? fieldName}) => FormBuilderValidators.compose<String>([
      FormBuilderValidators.required<String>(
        errorText: fieldName != null ? l10n.enterField(fieldName) : l10n.enterName,
      ),
      FormBuilderValidators.minLength<String>(
        2,
        errorText: l10n.nameTooShort(fieldName ?? l10n.firstName),
      ),
      FormBuilderValidators.match(
        RegExp(r'^[а-яА-ЯёЁa-zA-Z\s-]+$'),
        errorText: l10n.nameOnlyLetters,
      ),
    ])(value);
}
