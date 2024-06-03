import 'dart:convert';
import 'package:hive_flutter/adapters.dart';
import 'room_item.dart';

part 'room.g.dart';

@HiveType(typeId: 2)
enum RoomStatus {
  @HiveField(0)
  Checked,
  @HiveField(1)
  Unchecked,
  @HiveField(2)
  Unknown
}

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

@HiveType(typeId: 0)
class Room {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  RoomStatus status;

  @HiveField(3)
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

  /// Get the room's item display text.
  String get itemDisplayString => presentItems.fold(
      '', (a, b) => '$a${a.isEmpty ? '' : ', '}${b.name.trimRight()}');
}
