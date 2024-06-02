import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_bloc.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_events.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_bloc.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_events.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_state.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/utils/providers.dart';

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

class RoomPage extends StatelessWidget {
  /// The id of the current room being viewed.
  final int roomId;

  const RoomPage({super.key, required this.roomId});

  void addCustomItem(
      BuildContext context, TextEditingController controller) async {
    final roomItemsListBloc = context.read<RoomItemsListBloc>();
    final result = await showDialog<RoomItem>(
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
      roomItemsListBloc.add(RoomItemsListAddCustomRoomItemEvent(item: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return BlocBuilder<RoomListBloc, RoomListState>(builder: (ctx, state) {
      if (state is RoomListLoadedData) {
        final currentRoom = state.getRoom(roomId);
        if (currentRoom == null) {
          return Scaffold(
              appBar: AppBar(title: const Text("Failed to load Room.")),
              body: const Center(child: Text("Failed to load Room.")));
        }
        final roomListBloc = context.read<RoomListBloc>();
        return Scaffold(
            appBar: AppBar(
              title: Text(currentRoom.name),
              actions: [
                ElevatedButton(
                    onPressed: () => roomListBloc
                        .add(RoomListClearRoomEvent(roomId: roomId)),
                    child: const Text("Clear"))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => addCustomItem(context, controller),
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
                          style: const TextStyle(fontSize: 22),
                          textAlign: TextAlign.left)),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Room Items",
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
                                  style: buildStyleFrom(),
                                  onPressed: () => deleteItem(ref, item),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                trailing: Checkbox(
                                    value:
                                        currentRoom.presentItems.contains(item),
                                    onChanged: (isNowChecked) => checkItem(
                                        ref, isNowChecked ?? false, item)),
                              );
                            }),
                      ),
                    ],
                  )),
                  const SizedBox(height: 90)
                ],
              ),
            ));
      } else if (state is RoomListLoading) {
        return const CircularProgressIndicator(
          value: null,
        );
      } else {
        return Text('Error. Unknown state: $state');
      }
    });
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

  void deleteItem(WidgetRef ref, RoomItem item) {
    ref.read(roomItemsProvider.notifier).removeItem(item);

    ref.read(roomsProvider.notifier).removeItemFromAllRooms(item);
  }
}
