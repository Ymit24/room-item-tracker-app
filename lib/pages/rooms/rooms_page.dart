import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/pages/rooms/widgets/room_entry.dart';
import 'package:room_item_tracker/utils/providers.dart';

class RoomsPage extends HookConsumerWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(roomsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Item Tracker'),
        actions: [
          IconButton(
            onPressed: () => clearAllRooms(context, ref),
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          ),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clearAllRooms(BuildContext ctx, WidgetRef ref) async {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (ctx) => AlertDialog(
        content: const Text(
            'Are you sure you want to reset ALL room items and statuses?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(roomsProvider.notifier).clearAllRooms();
            },
            child: const Text('Yes, clear!'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
