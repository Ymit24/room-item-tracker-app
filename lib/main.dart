import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/models/seed_models.dart';
import 'package:room_item_tracker/pages/rooms/rooms_page.dart';

void main() {
  runApp(const ProviderScope(child: RoomItemTrackerApp()));
}

// NOTE: Removing these for providers.
// final List<RoomItem> roomItems = <RoomItem>[];
// final List<Room> rooms = <Room>[];

class RoomsNotifier extends StateNotifier<List<Room>> {
  RoomsNotifier() : super([]);

  void loadFromFile() async {
    print("Room provider fetching rooms.");
    // final result = await readRooms();
    // if (result.isEmpty) {
    //   state = List.from(seedRooms);
    // } else {
    //   state = List.from(result);
    // }
    state = List.from(seedRooms);
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
        if (room.id == roomId) room.copyWith(status: !room.status) else room
    ];
    writeRooms(state);
  }

  void addItemToRoom(int roomId, RoomItem item) {
    print("adding item to room");
    state = [
      for (final room in state)
        if (room.id != roomId)
          room
        else
          room.copyWith(presentItems: [...room.presentItems, item])
    ];
    writeRooms(state);
  }

  void removeItemFromRoom(int roomId, RoomItem item) {
    print("removing item to room");
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
    writeRooms(state);
  }

  void clearRoom(Room room) {
    state = [
      for (final c in state)
        if (c == room) room.copyWith(presentItems: []) else c
    ];
    writeRooms(state);
  }

  void clearAllRooms() {
    state = [for (final room in state) room.copyWith(presentItems: [])];
    writeRooms(state);
  }

  void removeItemFromAllRooms(RoomItem item) {
    state = [
      for (final room in state)
        if (room.presentItems.contains(item))
          room.copyWith(presentItems: [
            for (final it in room.presentItems)
              if (it != item) it
          ])
    ];
    writeRooms(state);
  }
}

class RoomItemNotifier extends StateNotifier<List<RoomItem>> {
  RoomItemNotifier() : super([]);

  void loadFromFile() async {
    print("RoomItem provider fetching items.");
    // final result = await readItems();

    // if (result.isEmpty) {
    //   state = List.from(seedItems);
    // } else {
    //   state = List.from(result);
    // }
    state = List.from(seedItems);
  }

  void addCustomRoomItem(RoomItem item) {
    final nextItemId = state.fold(0, (max, e) => e.id > max ? e.id + 1 : max);
    state = [...state, item.copyWith(id: nextItemId)];
    writeItems(state);
  }

  void removeItem(RoomItem item) {
    state = [
      for (final it in state)
        if (it != item) it
    ];
    writeItems(state);
  }
}

final roomsProvider = StateNotifierProvider<RoomsNotifier, List<Room>>((ref) {
  return RoomsNotifier();
});

final roomItemsProvider =
    StateNotifierProvider<RoomItemNotifier, List<RoomItem>>((ref) {
  return RoomItemNotifier();
});

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _roomsFile async {
  final path = await _localPath;
  return File('$path/rooms.json');
}

Future<File> get _itemsFile async {
  final path = await _localPath;
  return File('$path/items.json');
}

Future<File> writeRooms(List<Room> rooms) async {
  print("Writing rooms");
  final file = await _roomsFile;

  Map<String, dynamic> map = {'rooms': rooms.map((e) => e.toJson()).toList()};

  return file.writeAsString(json.encode(map));
}

Future<File> writeItems(List<RoomItem> roomItems) async {
  print("Writing items");
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

class RoomItemTrackerApp extends HookConsumerWidget {
  const RoomItemTrackerApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loadDataFromFile(ref);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RoomsPage(),
    );
  }

  void loadDataFromFile(WidgetRef ref) async {
    await Future.delayed(const Duration(milliseconds: 10), () {
      ref.watch(roomsProvider.notifier).loadFromFile();
      ref.watch(roomItemsProvider.notifier).loadFromFile();
    });
  }
}
