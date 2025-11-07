/// User Model
///
/// Data model for User with JSON serialization
library;

import 'dart:convert';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.avatarUrl,
    required super.createdAt,
    super.lastLogin,
    super.isGuest,
    super.permissions,
  });

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      isGuest: json['isGuest'] as bool? ?? false,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  /// Create from JSON string
  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(json.decode(jsonString));
  }

  /// Convert to JSON
  Map<String, dynamic> toJsonMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      if (lastLogin != null) 'lastLogin': lastLogin!.toIso8601String(),
      'isGuest': isGuest,
      'permissions': permissions,
    };
  }

  /// Convert to JSON string for storage
  String toJson() {
    return json.encode(toJsonMap());
  }

  /// Alias for toJson (compatibility)
  String toJsonString() => toJson();

  /// Create from Entity
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
      lastLogin: entity.lastLogin,
      isGuest: entity.isGuest,
      permissions: entity.permissions,
    );
  }

  /// Convert to Entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      lastLogin: lastLogin,
      isGuest: isGuest,
      permissions: permissions,
    );
  }
}
