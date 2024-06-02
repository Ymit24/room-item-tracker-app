import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_bloc.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_events.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_state.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_bloc.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_events.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/models/room_item.dart';
import 'package:room_item_tracker/pages/rooms/rooms_page.dart';
import 'package:room_item_tracker/utils/injection.dart';

void main() async {
  await setupHive();
  setupServiceLocators();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => RoomListBloc()
            ..add(
              RoomListLoadEvent(),
            ),
        ),
        BlocProvider(
          create: (ctx) => RoomItemsListBloc()
            ..add(
              RoomItemsListLoadEvent(),
            ),
        ),
      ],
      child: const RoomItemTrackerApp(),
    ),
  );
}

Future<void> setupHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(RoomAdapter());
  Hive.registerAdapter(RoomItemAdapter());
  Hive.registerAdapter(RoomStatusAdapter());

  await Hive.openBox<Room>('rooms');
  await Hive.openBox<RoomItem>('items');
}

class RoomItemTrackerApp extends StatelessWidget {
  const RoomItemTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Room Item Tracker',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: const RoomsPage(),
    );
  }
}
