// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomAdapter extends TypeAdapter<Room> {
  @override
  final int typeId = 0;

  @override
  Room read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Room(
      id: fields[0] as int,
      name: fields[1] as String,
      presentItems: (fields[3] as List).cast<RoomItem>(),
      status: fields[2] as RoomStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Room obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.presentItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoomStatusAdapter extends TypeAdapter<RoomStatus> {
  @override
  final int typeId = 2;

  @override
  RoomStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RoomStatus.Checked;
      case 1:
        return RoomStatus.Unchecked;
      case 2:
        return RoomStatus.Unknown;
      default:
        return RoomStatus.Checked;
    }
  }

  @override
  void write(BinaryWriter writer, RoomStatus obj) {
    switch (obj) {
      case RoomStatus.Checked:
        writer.writeByte(0);
        break;
      case RoomStatus.Unchecked:
        writer.writeByte(1);
        break;
      case RoomStatus.Unknown:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
