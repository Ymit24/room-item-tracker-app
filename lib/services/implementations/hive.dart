import 'dart:io';

import 'package:hive/hive.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/services/storage.dart';

class HiveBasedStorageService extends RoomStorageService {
  @override
  Future<List<RoomItem>> readItems() {
    // TODO: implement readItems
    throw UnimplementedError();
  }

  @override
  Future<List<Room>> readRooms() {
    var roomsBox = Hive.box<Room>('rooms');
    final roomsById = roomsBox.toMap();

    return Future.value(roomsById.values.toList());
  }

  @override
  Future<List<RoomItem>> readSeedItems() {
    // TODO: implement readSeedItems
    throw UnimplementedError();
  }

  @override
  Future<void> writeItems(List<RoomItem> roomItems) {
    // TODO: implement writeItems
    throw UnimplementedError();
  }

  @override
  Future<void> writeRooms(List<Room> rooms) {
    throw UnimplementedError();
  }
}
