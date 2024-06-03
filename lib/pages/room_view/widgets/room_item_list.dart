import 'package:flutter/material.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';

/// List items for a room with delete button and presence toggle.
class RoomItemList extends StatelessWidget {
  /// List of all room items.
  final List<RoomItem> allRoomItems;

  /// The current room.
  final Room currentRoom;

  /// Callback when delete is pressed.
  final Function(RoomItem) onDeleteItem;

  /// Callback when item presence is toggled.
  final Function(RoomItem, bool) onToggleItem;

  const RoomItemList({
    super.key,
    required this.allRoomItems,
    required this.currentRoom,
    required this.onDeleteItem,
    required this.onToggleItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: allRoomItems.length,
        itemBuilder: (context, index) {
          final item = allRoomItems[index];
          return ListTile(
            title: Text(item.name),
            leading: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.red),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () => onDeleteItem(item),
              ),
            ),
            trailing: Checkbox(
              value: currentRoom.presentItems.contains(item),
              onChanged: (isNowChecked) =>
                  onToggleItem(item, isNowChecked ?? false),
            ),
          );
        });
  }
}
