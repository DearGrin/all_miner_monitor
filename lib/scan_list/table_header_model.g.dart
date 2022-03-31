// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_header_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TableHeaderModelAdapter extends TypeAdapter<TableHeaderModel> {
  @override
  final int typeId = 2;

  @override
  TableHeaderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TableHeaderModel(
      label: fields[0] as String?,
      width: fields[1] as double?,
      isVisible: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TableHeaderModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.isVisible);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableHeaderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
