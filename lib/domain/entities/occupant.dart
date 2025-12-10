import 'package:equatable/equatable.dart';

/// Житель/пользователь дома
class Occupant extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isHome;
  final String? currentRoom;

  const Occupant({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isHome = false,
    this.currentRoom,
  });

  Occupant copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool? isHome,
    String? currentRoom,
  }) {
    return Occupant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isHome: isHome ?? this.isHome,
      currentRoom: currentRoom ?? this.currentRoom,
    );
  }

  @override
  List<Object?> get props => [id, name, avatarUrl, isHome, currentRoom];
}
