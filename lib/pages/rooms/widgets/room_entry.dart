import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/main.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/pages/room_view/room_view_page.dart';

class RoomEntry extends HookConsumerWidget {
  final int roomId;

  const RoomEntry({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomsProvider.notifier).getRoom(roomId)!;
    var statusColor = room.status == RoomStatus.Checked
        ? Colors.green
        : room.status == RoomStatus.Unchecked
            ? Colors.red
            : Colors.grey;
    return ListTile(
      title: Text(room.name),
      leading: ElevatedButton(
        child: null,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: statusColor,
        ),
        onPressed: () => toggleRoomStatus(ref),
      ),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        ElevatedButton(
            onPressed: () {
              viewRoom(context);
            },
            child: const Text("View")),
      ]),
    );
  }

  void toggleRoomStatus(WidgetRef ref) {
    ref.read(roomsProvider.notifier).toggleRoomStatus(roomId);
  }

  void viewRoom(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RoomPage(roomId: roomId)));
  }
}
