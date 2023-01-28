import 'dart:convert';

import 'room_item.dart';

class Room {
  final int id;
  final String name;
  bool status;
  final List<RoomItem> presentItems;

  Room(
      {required this.id,
      required this.name,
      required this.status,
      required this.presentItems});

  Room.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        status = json['status'],
        presentItems = (jsonDecode(json['presentItems']) as List)
            .map((raw) => RoomItem.fromJson(raw))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'presentItems': jsonEncode(presentItems),
      };

  Room copyWith(
      {int? id, String? name, bool? status, List<RoomItem>? presentItems}) {
    return Room(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        presentItems: presentItems ?? this.presentItems);
  }
}
