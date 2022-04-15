// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constructor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LayoutAdapter extends TypeAdapter<Layout> {
  @override
  final int typeId = 5;

  @override
  Layout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Layout(
      tag: fields[0] as String?,
      rigs: (fields[1] as List?)?.cast<Rig>(),
      counter: fields[2] as int?,
      ips: (fields[3] as List?)?.cast<String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, Layout obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tag)
      ..writeByte(1)
      ..write(obj.rigs)
      ..writeByte(2)
      ..write(obj.counter)
      ..writeByte(3)
      ..write(obj.ips);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RigAdapter extends TypeAdapter<Rig> {
  @override
  final int typeId = 6;

  @override
  Rig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rig(
      fields[0] as int,
      shelves: (fields[1] as List?)?.cast<Shelf>(),
    );
  }

  @override
  void write(BinaryWriter writer, Rig obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.shelves);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShelfAdapter extends TypeAdapter<Shelf> {
  @override
  final int typeId = 7;

  @override
  Shelf read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Shelf(
      fields[0] as int,
      places: (fields[1] as List?)?.cast<Place>(),
    );
  }

  @override
  void write(BinaryWriter writer, Shelf obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.places);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShelfAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaceAdapter extends TypeAdapter<Place> {
  @override
  final int typeId = 8;

  @override
  Place read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Place(
      fields[0] as int,
      fields[2] as String,
      ip: fields[1] as String?,
      aucN: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Place obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ip)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.aucN);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
