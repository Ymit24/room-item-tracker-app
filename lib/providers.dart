import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/notifiers/room_items.dart';
import 'package:room_item_tracker/notifiers/rooms.dart';

/// Provider for Rooms
final roomsProvider = StateNotifierProvider<RoomsNotifier, List<Room>>((ref) {
  return RoomsNotifier();
});

/// Provider for RoomItems
final roomItemsProvider =
    StateNotifierProvider<RoomItemNotifier, List<RoomItem>>((ref) {
  return RoomItemNotifier();
});
