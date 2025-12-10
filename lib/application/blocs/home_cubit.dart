import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/occupant.dart';
import '../../domain/repositories/home_repository.dart';

// ============================================
// STATE
// ============================================

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Room> rooms;
  final List<Occupant> occupants;
  final String? selectedRoomId;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.rooms = const [],
    this.occupants = const [],
    this.selectedRoomId,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Room>? rooms,
    List<Occupant>? occupants,
    String? selectedRoomId,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      rooms: rooms ?? this.rooms,
      occupants: occupants ?? this.occupants,
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Геттеры
  Room? get selectedRoom => rooms.cast<Room?>().firstWhere(
    (r) => r?.id == selectedRoomId,
    orElse: () => null,
  );

  List<Occupant> get occupantsAtHome => 
      occupants.where((o) => o.isHome).toList();

  int get occupantCount => occupants.length;
  int get atHomeCount => occupantsAtHome.length;

  @override
  List<Object?> get props => [status, rooms, occupants, selectedRoomId, errorMessage];
}

// ============================================
// CUBIT
// ============================================

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(const HomeState());

  /// Загрузить данные дома
  Future<void> loadHome() async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    try {
      final rooms = await _repository.getRooms();
      final occupants = await _repository.getOccupants();
      
      emit(state.copyWith(
        status: HomeStatus.success,
        rooms: rooms,
        occupants: occupants,
        selectedRoomId: rooms.isNotEmpty ? rooms.first.id : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Выбрать комнату
  void selectRoom(String roomId) {
    emit(state.copyWith(selectedRoomId: roomId));
  }

  /// Добавить жильца
  Future<void> addOccupant(String name) async {
    try {
      final occupant = Occupant(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        isHome: false,
      );
      
      await _repository.addOccupant(occupant);
      
      emit(state.copyWith(
        occupants: [...state.occupants, occupant],
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Подписаться на обновления
  void watchHome() {
    _repository.watchRooms().listen((rooms) {
      emit(state.copyWith(rooms: rooms));
    });
    
    _repository.watchOccupants().listen((occupants) {
      emit(state.copyWith(occupants: occupants));
    });
  }
}
