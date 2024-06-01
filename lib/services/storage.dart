import 'dart:async';
import 'dart:io';

import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';

abstract class RoomStorageService {
  /// Write rooms to storage.
  Future<File> writeRooms(List<Room> rooms);

  /// Write items for a room to storage.
  Future<File> writeItems(List<RoomItem> roomItems);

  /// Read list of all items from storage.
  Future<List<RoomItem>> readItems();

  /// Read initial list of seed items from storage.
  Future<List<RoomItem>> readSeedItems();

  /// Read rooms from storage.
  Future<List<Room>> readRooms();
}