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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            TextButton(
                onPressed: () => onReseedClick(context, ref),
                child: const Text('Full data reset (Reseed item list).'))
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Room Item Tracker'),
        actions: [
          IconButton(
            onPressed: () => clearAllRooms(context, ref),
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
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
      ),
    );
  }

  void onReseedClick(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text(
          'Are you sure you want to FULLY RESET all rooms and RESET the item list?',
        ),
        actions: [
          TextButton(
            onPressed: () => resetAndReseed(ctx, ref),
            child: const Text('Yes, RESET.'),
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

  void resetAndReseed(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop();
    await ref.read(roomItemsProvider.notifier).resetWithSeedItems();
    await ref.read(roomsProvider.notifier).clearAllRooms();
  }

  void clearAllRooms(BuildContext ctx, WidgetRef ref) async {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (ctx) => AlertDialog(
        content: const Text(
          'Are you sure you want to reset ALL room items and statuses?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(roomsProvider.notifier).clearAllRooms();
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
