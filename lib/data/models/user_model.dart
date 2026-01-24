/// User Model (DTO) для Data Layer
///
/// Отвечает за сериализацию/десериализацию User.
/// Domain Entity User не знает про JSON.
library;

import 'package:hvac_control/domain/entities/user.dart';
import 'package:hvac_control/domain/entities/user_preferences.dart';

/// DTO для пользователя
class UserModel {

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.emailConfirmed,
    this.preferences,
  });

  /// Создание из Domain Entity
  factory UserModel.fromEntity(User user) => UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      role: user.role,
      emailConfirmed: user.emailConfirmed,
      preferences: user.preferences,
    );

  /// Десериализация из JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final preferencesJson = json['preferences'] as Map<String, dynamic>?;

    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      emailConfirmed: json['emailConfirmed'] as bool? ?? false,
      preferences: preferencesJson != null
          ? UserPreferences.fromJson(preferencesJson)
          : null,
    );
  }
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool emailConfirmed;
  final UserPreferences? preferences;

  /// Сериализация в JSON
  Map<String, dynamic> toJson() => {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'emailConfirmed': emailConfirmed,
      if (preferences != null) 'preferences': preferences!.toJson(),
    };

  /// Преобразование в Domain Entity
  User toEntity() => User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      emailConfirmed: emailConfirmed,
      preferences: preferences,
    );
}
