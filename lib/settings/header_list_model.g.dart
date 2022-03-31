// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HeadersListModelAdapter extends TypeAdapter<HeadersListModel> {
  @override
  final int typeId = 3;

  @override
  HeadersListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HeadersListModel(
      headers: (fields[0] as List?)?.cast<TableHeaderModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, HeadersListModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.headers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeadersListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
