import 'package:room_item_tracker/models/room_item.dart';

/// Base class for room items list events.
sealed class RoomItemsListEvent {}

/// Triggers a load of room items from storage.
final class RoomItemsListLoadEvent extends RoomItemsListEvent {}

/// Triggers adding a new custom room item to storage.
final class RoomItemsListAddCustomRoomItemEvent extends RoomItemsListEvent {
  /// The new item to add.
  final RoomItem item;

  RoomItemsListAddCustomRoomItemEvent({required this.item});
}

/// Triggers removing an item from the list of items from storage.
final class RoomItemsListRemoveItemEvent extends RoomItemsListEvent {
  /// The item to be removed.
  final RoomItem item;

  RoomItemsListRemoveItemEvent({required this.item});
}

/// Triggers item list to be reset to seed items.
final class RoomItemsListResetWithSeedItemsEvent extends RoomItemsListEvent {}
