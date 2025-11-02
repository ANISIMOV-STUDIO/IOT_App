/// User Entity
///
/// Core business object representing a user
library;

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isGuest;
  final List<String> permissions;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
    this.lastLogin,
    this.isGuest = false,
    this.permissions = const [],
  });

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isGuest,
    List<String>? permissions,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isGuest: isGuest ?? this.isGuest,
      permissions: permissions ?? this.permissions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatarUrl,
        createdAt,
        lastLogin,
        isGuest,
        permissions,
      ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name)';
  }
}