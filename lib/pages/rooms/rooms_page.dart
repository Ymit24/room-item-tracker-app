import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/pages/rooms/widgets/room_entry.dart';
import 'package:room_item_tracker/providers.dart';

class RoomsPage extends HookConsumerWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(roomsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Room Tracker'),
        actions: [
          ElevatedButton(
              onPressed: () => clearAllRooms(ref),
              child: const Text("Clear All Rooms"))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: rooms.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RoomEntry(roomId: rooms[index].id);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void clearAllRooms(WidgetRef ref) async {
    ref.read(roomsProvider.notifier).clearAllRooms();
  }
}
