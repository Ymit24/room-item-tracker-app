import 'package:room_item_tracker/models/seed_models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/injection.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/services/storage.dart';

class RoomsNotifier extends StateNotifier<List<Room>> {
  final _storageService = locator.get<RoomStorageService>();

  RoomsNotifier() : super([]);

  void loadFromFile() async {
    final result = await _storageService.readRooms();
    if (result.isEmpty) {
      state = List.from(seedRooms);
    } else {
      state = List.from(result);
    }
  }

  Room? getRoom(int roomId) {
    for (final room in state) {
      if (room.id == roomId) return room;
    }
    return null;
  }

  void toggleRoomStatus(int roomId) {
    state = [
      for (final room in state)
        if (room.id == roomId)
          room.copyWith(status: room.status.nextToggleState())
        else
          room
    ];
    _storageService.writeRooms(state);
  }

  void addItemToRoom(int roomId, RoomItem item) {
    state = [
      for (final room in state)
        if (room.id != roomId)
          room
        else
          room.copyWith(presentItems: [...room.presentItems, item])
    ];
    _storageService.writeRooms(state);
  }

  void removeItemFromRoom(int roomId, RoomItem item) {
    state = [
      for (final room in state)
        if (room.id != roomId)
          room
        else
          room.copyWith(presentItems: [
            for (final it in room.presentItems)
              if (it != item) it
          ])
    ];
    _storageService.writeRooms(state);
  }

  void clearRoom(int roomId) {
    state = [
      for (final room in state)
        if (room.id == roomId) room.copyWith(presentItems: []) else room
    ];
    _storageService.writeRooms(state);
  }

  void clearAllRooms() {
    state = [
      for (final room in state)
        room.copyWith(presentItems: [], status: RoomStatus.Unknown)
    ];
    _storageService.writeRooms(state);
  }

  void removeItemFromAllRooms(RoomItem item) {
    state = [
      for (final room in state)
        if (room.presentItems.contains(item))
          room.copyWith(presentItems: [
            for (final it in room.presentItems)
              if (it != item) it
          ])
        else
          room
    ];
    _storageService.writeRooms(state);
  }
}
