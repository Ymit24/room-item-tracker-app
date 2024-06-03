import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'room_item.g.dart';

@HiveType(typeId: 1)
class RoomItem extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  RoomItem({required this.id, required this.name});

  RoomItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  RoomItem copyWith({int? id, String? name}) {
    return RoomItem(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object> get props => [id, name];
}
