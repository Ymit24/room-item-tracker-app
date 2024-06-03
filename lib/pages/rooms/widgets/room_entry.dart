import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_bloc.dart';
import 'package:room_item_tracker/bloc/rooms/rooms_events.dart';
import 'package:room_item_tracker/models/room.dart';
import 'package:room_item_tracker/pages/room_view/room_view_page.dart';

class RoomEntry extends StatelessWidget {
  /// The room which this entry represents.
  final Room room;

  const RoomEntry({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
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
        onPressed: () => toggleRoomStatus(context),
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

  void toggleRoomStatus(BuildContext ctx) {
    final roomListBloc = ctx.read<RoomListBloc>();
    roomListBloc.add(RoomListToggleRoomStatusEvent(roomId: room.id));
  }

  void viewRoom(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RoomPage(roomId: room.id)));
  }
}
