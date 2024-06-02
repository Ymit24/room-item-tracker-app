import 'package:room_item_tracker/models/room.dart';

sealed class RoomListState {}

final class RoomListInitial extends RoomListState {}

final class RoomListLoading extends RoomListState {}

final class RoomListLoadedData extends RoomListState {
  final List<Room> rooms;
  RoomListLoadedData({required this.rooms});

  /// Get a specific room.
  Room? getRoom(int roomId) {
    for (final room in rooms) {
      if (room.id == roomId) return room;
    }
    return null;
  }
}
