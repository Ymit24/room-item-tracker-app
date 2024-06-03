import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_bloc.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_events.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_state.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_bloc.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_events.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_state.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/pages/room_view/widgets/clear_room_confirm_dialog.dart';
import 'package:room_item_tracker/pages/room_view/widgets/create_item_dialog.dart';
import 'package:room_item_tracker/pages/room_view/widgets/room_item_list.dart';

class RoomPage extends StatelessWidget {
  /// The id of the current room being viewed.
  final int roomId;

  const RoomPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext ctx) {
    return BlocBuilder<RoomListBloc, RoomListState>(
      builder: (ctx, state) {
        switch (state) {
          case RoomListLoadedData loadedData:
            {
              final loadedRoom = loadedData.getRoom(roomId)!;
              return Scaffold(
                appBar: AppBar(
                  title: Text(loadedRoom.name),
                  actions: [
                    ElevatedButton(
                      onPressed: () => _onClear(ctx, loadedRoom.id),
                      child: const Text("Clear"),
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _addCustomItem(ctx),
                  tooltip: 'Add Custom Item',
                  child: const Icon(Icons.add),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Text(
                          "Items: ${loadedRoom.itemDisplayString}",
                          style: const TextStyle(fontSize: 22),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Room Items",
                            style: TextStyle(fontSize: 22),
                          ),
                          Expanded(
                            child: BlocBuilder<RoomItemsListBloc,
                                    RoomItemsListState>(
                                builder: (ctx, state) => switch (state) {
                                      RoomItemsListLoadedData(
                                        items: final allRoomItems
                                      ) =>
                                        RoomItemList(
                                          allRoomItems: allRoomItems,
                                          currentRoom: loadedRoom,
                                          onDeleteItem: (item) =>
                                              _onDeleteItem(ctx, item),
                                          onToggleItem: (item, isChecked) =>
                                              _onToggleItem(
                                                  ctx, item, isChecked),
                                        ),
                                      _ => const CircularProgressIndicator(
                                          value: null,
                                        )
                                    }),
                          ),
                        ],
                      )),
                      const SizedBox(height: 90)
                    ],
                  ),
                ),
              );
            }
          case RoomListLoading _:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading room...'),
              ),
              body: const Center(
                child: CircularProgressIndicator(
                  value: null,
                ),
              ),
            );
          case _:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Failed to load room.'),
              ),
              body: const Text('Failed to load the room.'),
            );
        }
      },
    );
  }

  /// Delete the item from the item list.
  _onDeleteItem(BuildContext ctx, RoomItem item) {
    final roomListBloc = ctx.read<RoomListBloc>();
    final roomItemsListBloc = ctx.read<RoomItemsListBloc>();
    roomListBloc.add(
      RoomListRemoveItemFromAllRoomsEvent(item: item),
    );
    roomItemsListBloc.add(
      RoomItemsListRemoveItemEvent(item: item),
    );
  }

  /// Toggle the presence of an item in the room.
  _onToggleItem(BuildContext ctx, RoomItem item, bool isChecked) {
    final roomListBloc = ctx.read<RoomListBloc>();
    if (isChecked) {
      roomListBloc.add(
        RoomListAddItemToRoomEvent(
          roomId: roomId,
          item: item,
        ),
      );
    } else {
      roomListBloc.add(
        RoomListRemoveItemFromRoomEvent(
          roomId: roomId,
          item: item,
        ),
      );
    }
  }
}

/// Show dialog to confirm clearing room.
void _onClear(BuildContext ctx, int roomId) async {
  final roomListBloc = ctx.read<RoomListBloc>();
  await showDialog(
    context: ctx,
    builder: (ctx) => ClearRoomConfirmDialog(
      onClear: () {
        roomListBloc.add(RoomListClearRoomEvent(roomId: roomId));
      },
    ),
    barrierDismissible: true,
  );
}

/// Show dialog to create a new item.
void _addCustomItem(BuildContext ctx) async {
  final roomItemsListBloc = ctx.read<RoomItemsListBloc>();
  await showDialog(
    context: ctx,
    barrierDismissible: false,
    builder: (ctx) => CreateItemDialog(
      onCreate: (String itemName) {
        ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('Created item \'$itemName\'')));
        Navigator.of(ctx).pop();
        roomItemsListBloc.add(
          RoomItemsListAddCustomRoomItemEvent(
            item: RoomItem(id: -1, name: itemName),
          ),
        );
      },
    ),
  );
}
