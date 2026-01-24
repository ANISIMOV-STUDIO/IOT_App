/// User Entity
///
/// Чистая доменная сущность без зависимостей от сериализации.
/// Сериализация выполняется в Data Layer через UserModel.
library;

import 'package:equatable/equatable.dart';
import 'package:hvac_control/domain/entities/user_preferences.dart';

/// Пользователь системы
class User extends Equatable {

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.emailConfirmed,
    this.preferences,
  });
  /// Уникальный идентификатор
  final String id;

  /// Email адрес
  final String email;

  /// Имя
  final String firstName;

  /// Фамилия
  final String lastName;

  /// Роль (User, Admin)
  final String role;

  /// Email подтверждён
  final bool emailConfirmed;

  /// Настройки пользователя (тема, язык, уведомления)
  final UserPreferences? preferences;

  /// Полное имя
  String get fullName => '$firstName $lastName';

  /// Копирование с изменениями
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    bool? emailConfirmed,
    UserPreferences? preferences,
  }) => User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
      preferences: preferences ?? this.preferences,
    );

  @override
  List<Object?> get props => [id, email, firstName, lastName, role, emailConfirmed, preferences];
}
