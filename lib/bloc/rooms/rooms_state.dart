import 'package:equatable/equatable.dart';
import 'package:room_item_tracker/models/room.dart';

sealed class RoomListState extends Equatable {}

final class RoomListInitial extends RoomListState {
  @override
  List<Object> get props => [];
}

final class RoomListLoading extends RoomListState {
  @override
  List<Object> get props => [];
}

final class RoomListLoadedData extends RoomListState {
  /// The list of loaded rooms.
  final List<Room> rooms;
  RoomListLoadedData({required this.rooms});

  @override
  List<Object> get props => [rooms];

  /// Get a specific room.
  Room? getRoom(int roomId) {
    for (final room in rooms) {
      if (room.id == roomId) return room;
    }
    return null;
  }
}
