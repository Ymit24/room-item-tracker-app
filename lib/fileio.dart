import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _roomsFile async {
  final path = await _localPath;
  return File('$path/rooms.json');
}

Future<File> get _itemsSeedFile async {
  final path = await _localPath;
  return File('$path/seedItems.csv');
}

Future<File> get _itemsFile async {
  final path = await _localPath;
  return File('$path/items.json');
}

Future<File> writeRooms(List<Room> rooms) async {
  final file = await _roomsFile;

  Map<String, dynamic> map = {'rooms': rooms.map((e) => e.toJson()).toList()};

  return file.writeAsString(json.encode(map));
}

Future<File> writeItems(List<RoomItem> roomItems) async {
  final file = await _itemsFile;
  Map<String, dynamic> map = {
    'items': roomItems.map((e) => e.toJson()).toList()
  };
  return file.writeAsString(json.encode(map));
}

Future<List<RoomItem>> readItems() async {
  final items = <RoomItem>[];
  try {
    final file = await _itemsFile;
    final contents = await file.readAsString();

    final jsonData = jsonDecode(contents);

    for (var item in jsonData['items']) {
      items.add(RoomItem.fromJson(item));
    }
  } catch (e) {
    print(e);
  }
  return items;
}

Future<List<RoomItem>> readSeedItems() async {
  final items = <RoomItem>[];
  var itemId = 0;
  try {
    final lines = await rootBundle.loadString('assets/data/seedItems.csv');
    for (var line in lines.split("\n")) {
      items.add(RoomItem(id: itemId++, name: line));
    }
  } catch (e) {
    print(e);
  }
  return items;
}

Future<List<Room>> readRooms() async {
  final roomsDecoded = <Room>[];
  try {
    final file = await _roomsFile;

    // Read the file
    final contents = await file.readAsString();

    final jsonData = jsonDecode(contents);
    for (var room in jsonData['rooms']) {
      roomsDecoded.add(Room.fromJson(room));
    }
  } catch (e) {
    print(e);
  }
  return roomsDecoded;
}
