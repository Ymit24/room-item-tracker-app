import 'dart:convert';

import 'room_item.dart';

enum RoomStatus { Checked, Unchecked, Unknown }

extension RoomStatusExt on RoomStatus {
  RoomStatus nextToggleState() {
    switch (this) {
      case RoomStatus.Checked:
        return RoomStatus.Unchecked;
      case RoomStatus.Unchecked:
        return RoomStatus.Unknown;
      case RoomStatus.Unknown:
        return RoomStatus.Checked;
      default:
        return RoomStatus.Checked;
    }
  }
}

class Room {
  final int id;
  final String name;
  RoomStatus status;
  final List<RoomItem> presentItems;

  Room({
    required this.id,
    required this.name,
    required this.presentItems,
    this.status = RoomStatus.Unknown,
  });

  Room.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        status = RoomStatus.values[json['status']],
        presentItems = (jsonDecode(json['presentItems']) as List)
            .map((raw) => RoomItem.fromJson(raw))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status.index,
        'presentItems': jsonEncode(presentItems),
      };

  Room copyWith(
      {int? id,
      String? name,
      RoomStatus? status,
      List<RoomItem>? presentItems}) {
    return Room(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        presentItems: presentItems ?? this.presentItems);
  }
}
