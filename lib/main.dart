import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/pages/rooms/rooms_page.dart';
import 'package:room_item_tracker/utils/injection.dart';
import 'package:room_item_tracker/utils/providers.dart';

void main() async {
  await setupHive();
  setupServiceLocators();

  runApp(const ProviderScope(child: RoomItemTrackerApp()));
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RoomAdapter());
  Hive.registerAdapter(RoomItemAdapter());
  Hive.registerAdapter(RoomStatusAdapter());
  await Hive.openBox<Room>('rooms');
  await Hive.openBox<RoomItem>('items');
}

class RoomItemTrackerApp extends HookConsumerWidget {
  const RoomItemTrackerApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loadDataFromFile(ref);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Room Item Tracker',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: const SafeArea(child: RoomsPage()),
    );
  }

  void loadDataFromFile(WidgetRef ref) async {
    await Future.delayed(const Duration(milliseconds: 10), () {
      ref.watch(roomsProvider.notifier).loadFromFile();
      ref.watch(roomItemsProvider.notifier).loadFromFile();
    });
  }
}
