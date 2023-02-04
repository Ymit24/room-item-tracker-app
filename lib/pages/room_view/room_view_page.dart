import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/main.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';

/*
 * Find the room using an Id. Will update when the rooms update.
 */
final currentRoomProvider = Provider.family<Room?, int>((ref, roomId) {
  final rooms = ref.watch(roomsProvider);
  for (final room in rooms) {
    if (room.id == roomId) {
      return room;
    }
  }
  return null;
});

class RoomPage extends HookConsumerWidget {
  final int roomId;

  const RoomPage({super.key, required this.roomId});

  void addCustomItem(BuildContext context, WidgetRef ref,
      TextEditingController controller) async {
    final result = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Create Item"),
              content: TextField(
                  controller: controller,
                  decoration:
                      const InputDecoration(hintText: "Enter Item Name")),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(null);
                      controller.clear();
                    },
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      if (controller.text.isEmpty) {
                        Navigator.of(ctx).pop(null);
                      } else {
                        Navigator.of(ctx)
                            .pop(RoomItem(id: -1, name: controller.text));
                      }
                      controller.clear();
                    },
                    child: const Text("Create"))
              ],
            ),
        barrierDismissible: true);
    if (result != null) {
      ref.read(roomItemsProvider.notifier).addCustomRoomItem(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final allRoomItems = ref.watch(roomItemsProvider);

    final roomResult = ref.watch(currentRoomProvider(roomId));

    if (roomResult == null) {
      return Scaffold(
          appBar: AppBar(title: Text("Failed to load Room.")),
          body: Center(child: Text("Failed to load Room.")));
    }

    final room = roomResult;

    final itemsDisplay = room.presentItems
        .fold("", (a, b) => "$a${a.isEmpty ? "" : ", "}${b.name}");

    return Scaffold(
        appBar: AppBar(
          title: Text(room.name),
          actions: [
            ElevatedButton(
                onPressed: () => clearRoom(ref), child: const Text("Clear"))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addCustomItem(context, ref, controller),
          tooltip: 'Add Custom Item',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                  height: 150,
                  child: Text("Items: $itemsDisplay",
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.left)),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selected",
                    style: TextStyle(fontSize: 22),
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: allRoomItems.length,
                        itemBuilder: (context, index) {
                          final item = allRoomItems[index];
                          return ListTile(
                            title: Text(item.name),
                            leading: ElevatedButton(
                              child: Icon(Icons.delete, color: Colors.white),
                              style: buildStyleFrom(),
                              onPressed: () => deleteItem(ref, item),
                            ),
                            trailing: Checkbox(
                                value: room.presentItems.contains(item),
                                onChanged: (isNowChecked) => checkItem(
                                    ref, isNowChecked ?? false, item)),
                          );
                        }),
                  ),
                ],
              )),
              SizedBox(height: 90)
            ],
          ),
        ));
  }

  ButtonStyle buildStyleFrom() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
    );
  }

  void checkItem(WidgetRef ref, bool isNowChecked, RoomItem item) {
    final notifier = ref.read(roomsProvider.notifier);
    if (isNowChecked) {
      notifier.addItemToRoom(roomId, item);
    } else {
      notifier.removeItemFromRoom(roomId, item);
    }
  }

  void clearRoom(WidgetRef ref) {
    ref.read(roomsProvider.notifier).clearRoom(roomId);
  }

  void deleteItem(WidgetRef ref, RoomItem item) {
    ref.read(roomItemsProvider.notifier).removeItem(item);

    ref.read(roomsProvider.notifier).removeItemFromAllRooms(item);
  }
}
