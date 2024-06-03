import 'package:room_item_tracker/models/room_item.dart';

sealed class RoomListEvent {}

/// Trigger loading rooms from storage.
final class RoomListLoadEvent extends RoomListEvent {}

/// Notify room status change .
final class RoomListToggleRoomStatusEvent extends RoomListEvent {
  /// Id of Room whose status should be toggled.
  final int roomId;

  RoomListToggleRoomStatusEvent({required this.roomId});
}

/// Notify item added to remove.
final class RoomListAddItemToRoomEvent extends RoomListEvent {
  /// Id of room where the item has been added.
  final int roomId;

  /// The item to add to the room.
  final RoomItem item;

  RoomListAddItemToRoomEvent({required this.roomId, required this.item});
}

/// Notify item added to remove.
final class RoomListRemoveItemFromRoomEvent extends RoomListEvent {
  /// Id of room where the item has been added.
  final int roomId;

  /// The item to add to the room.
  final RoomItem item;

  RoomListRemoveItemFromRoomEvent({required this.roomId, required this.item});
}

/// Trigger a room to be cleared.
final class RoomListClearRoomEvent extends RoomListEvent {
  /// Id of room to clear.
  final int roomId;

  RoomListClearRoomEvent({required this.roomId});
}

/// Trigger clearing all rooms.
final class RoomListClearAllRoomsEvent extends RoomListEvent {}

/// Trigger removing an item from all rooms.
final class RoomListRemoveItemFromAllRoomsEvent extends RoomListEvent {
  /// The item to be removed.
  final RoomItem item;

  RoomListRemoveItemFromAllRoomsEvent({required this.item});
}
