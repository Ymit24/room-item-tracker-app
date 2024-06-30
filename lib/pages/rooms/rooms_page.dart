import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_bloc.dart';
import 'package:room_item_tracker/bloc/room_items/room_items_events.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_bloc.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_events.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_state.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/pages/rooms/widgets/room_entry.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
//      drawer: Drawer(
//        child: ListView(
//          padding: EdgeInsets.zero,
//          children: [
//            const DrawerHeader(
//              child: Center(
//                child: Text(
//                  'Settings',
//                  style: TextStyle(fontSize: 24),
//                ),
//              ),
//            ),
//            TextButton(
//                onPressed: () => onReseedClick(context),
//                child: const Text('Full data reset (Reseed item list).'))
//          ],
//        ),
//      ),
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.settings,
              ),
              label: 'Settings',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          if (index == 1) {
            return CupertinoTabView(builder: (context) {
              return SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Text('Page $index'),
                      CupertinoButton(
                          child: Text('delete room'),
                          color: CupertinoColors.systemRed,
                          onPressed: () {}),
                    ],
                  ),
                ),
              );
            });
          }

          return CupertinoTabView(
            builder: (context) => SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: BlocBuilder<RoomListBloc, RoomListState>(
                      builder: (ctx, state) {
                        if (state is RoomListLoadedData) {
                          return SingleChildScrollView(
                            child: CupertinoListSection.insetGrouped(
                              header: Text('Rooms'),
                              children: List.generate(
                                state.rooms.length,
                                (i) => CupertinoListTile(
                                  leading: Icon(
                                    Icons.circle,
                                    color: state.rooms[i].status ==
                                            RoomStatus.Checked
                                        ? CupertinoColors.activeGreen
                                        : (state.rooms[i].status ==
                                                RoomStatus.Unchecked
                                            ? CupertinoColors.systemRed
                                            : CupertinoColors.systemGrey),
                                  ),
                                  title: Text('${state.rooms[i].name}'),
                                  onTap: () {},
                                  trailing: CupertinoListTileChevron(),
                                ),
                              ),
//                        padding: const EdgeInsets.all(8),
//                        itemCount: state.rooms.length,
//                        itemBuilder: (BuildContext context, int index) {
//                          return RoomEntry(room: state.rooms[index]);
//                        },
                            ),
                          );
                        } else if (state is RoomListLoading) {
                          return const CupertinoActivityIndicator();
                        } else {
                          return Text('Unknown state $state');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

//      navigationBar: CupertinoNavigationBar(
//        middle: const Text('Room Item Tracker'),
//        trailing: CupertinoButton(
//          onPressed: () => clearAllRooms(context),
//          child: const Icon(
//            CupertinoIcons.delete,
//            color: CupertinoColors.destructiveRed,
//          ),
//        ),
//      ),
          );
        });
  }

  void onReseedClick(BuildContext context) {
    //showDialog(
    //  context: context,
    //  builder: (ctx) => AlertDialog(
    //    content: const Text(
    //      'Are you sure you want to FULLY RESET all rooms and RESET the item list?',
    //    ),
    //    actions: [
    //      TextButton(
    //        onPressed: () => resetAndReseed(ctx),
    //        child: const Text('Yes, RESET.'),
    //      ),
    //      TextButton(
    //        onPressed: () {
    //          Navigator.of(ctx).pop();
    //        },
    //        child: const Text('Cancel'),
    //      ),
    //    ],
    //  ),
    //);
  }

  void resetAndReseed(BuildContext context) async {
    Navigator.of(context).pop();
    final roomListBloc = context.read<RoomListBloc>();
    final roomItemsListBloc = context.read<RoomItemsListBloc>();

    roomListBloc.add(RoomListClearAllRoomsEvent());
    roomItemsListBloc.add(RoomItemsListResetWithSeedItemsEvent());
  }

  void clearAllRooms(BuildContext ctx) async {
    //showDialog(
    //  barrierDismissible: false,
    //  context: ctx,
    //  builder: (context) => AlertDialog(
    //    content: const Text(
    //      'Are you sure you want to reset ALL room items and statuses?',
    //    ),
    //    actions: [
    //      TextButton(
    //        onPressed: () async {
    //          Navigator.of(context).pop();

    //          final roomListBloc = context.read<RoomListBloc>();
    //          roomListBloc.add(RoomListClearAllRoomsEvent());
    //        },
    //        child: const Text('Yes, clear!'),
    //      ),
    //      TextButton(
    //        onPressed: () {
    //          Navigator.of(context).pop();
    //        },
    //        child: const Text('Cancel'),
    //      ),
    //    ],
    //  ),
    //);
  }
}
