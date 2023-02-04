import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/fileio.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/models/seed_models.dart';
import 'package:room_item_tracker/pages/rooms/rooms_page.dart';

void main() {
  runApp(const ProviderScope(child: RoomItemTrackerApp()));
}

class RoomsNotifier extends StateNotifier<List<Room>> {
  RoomsNotifier() : super([]);

  void loadFromFile() async {
    final result = await readRooms();
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
    writeRooms(state);
  }

  void addItemToRoom(int roomId, RoomItem item) {
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

  void clearRoom(int roomId) {
    state = [
      for (final room in state)
        if (room.id == roomId) room.copyWith(presentItems: []) else room
    ];
    writeRooms(state);
  }

  void clearAllRooms() {
    state = [
      for (final room in state)
        room.copyWith(presentItems: [], status: RoomStatus.Unknown)
    ];
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
        else
          room
    ];
    writeRooms(state);
  }
}

class RoomItemNotifier extends StateNotifier<List<RoomItem>> {
  RoomItemNotifier() : super([]);

  void loadFromFile() async {
    final result = await readItems();

    if (result.isEmpty) {
      state = List.from(await readSeedItems());
    } else {
      state = List.from(result);
    }
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

class RoomItemTrackerApp extends HookConsumerWidget {
  const RoomItemTrackerApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loadDataFromFile(ref);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: SafeArea(child: const RoomsPage()),
    );
  }

  void loadDataFromFile(WidgetRef ref) async {
    await Future.delayed(const Duration(milliseconds: 10), () {
      ref.watch(roomsProvider.notifier).loadFromFile();
      ref.watch(roomItemsProvider.notifier).loadFromFile();
    });
  }
}
