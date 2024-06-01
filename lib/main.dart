import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:room_item_tracker/injection.dart';
import 'package:room_item_tracker/pages/rooms/rooms_page.dart';
import 'package:room_item_tracker/providers.dart';

void main() {
  setupServiceLocators();
  runApp(const ProviderScope(child: RoomItemTrackerApp()));
}

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
