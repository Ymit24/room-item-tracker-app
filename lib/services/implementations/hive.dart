import 'package:hive/hive.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/services/storage.dart';

const _boxNameForRooms = 'rooms';
const _boxNameForRoomItems = 'items';

class HiveBasedStorageService extends RoomStorageService {
  @override
  Future<List<RoomItem>> readItems() async {
    var roomsBox = Hive.box<RoomItem>(_boxNameForRoomItems);
    final itemsById = roomsBox.toMap();

    return itemsById.values.toList();
  }

  @override
  Future<List<Room>> readRooms() async {
    var roomsBox = Hive.box<Room>(_boxNameForRooms);
    final roomsById = roomsBox.toMap();

    return roomsById.values.toList();
  }

  @override
  Future<void> writeItems(List<RoomItem> roomItems) async {
    final roomItemsBox = Hive.box<RoomItem>(_boxNameForRoomItems);
    // await roomItemsBox.clear();

    for (final roomItem in roomItems) {
      await roomItemsBox.put(roomItem.id, roomItem);
    }
  }

  @override
  Future<void> writeRooms(List<Room> rooms) async {
    final roomsBox = Hive.box<Room>(_boxNameForRooms);
    // await roomsBox.clear();

    for (final room in rooms) {
      await roomsBox.put(room.id, room);
    }
  }
}
