class RoomItem {
  final int id;
  final String name;

  RoomItem({required this.id, required this.name});

  RoomItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RoomItem && name == other.name;

  @override
  int get hashCode => id.hashCode ^ hashCode.hashCode;

  RoomItem copyWith({int? id, String? name}) {
    return RoomItem(id: id ?? this.id, name: name ?? this.name);
  }
}
