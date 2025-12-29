/// User Entity
library;

import 'package:equatable/equatable.dart';

/// Пользователь системы
class User extends Equatable {
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

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.emailConfirmed,
  });

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
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
    );
  }

  /// Из JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      emailConfirmed: json['emailConfirmed'] as bool? ?? false,
    );
  }

  /// В JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'emailConfirmed': emailConfirmed,
    };
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, role, emailConfirmed];
}
