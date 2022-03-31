// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PoolAdapter extends TypeAdapter<Pool> {
  @override
  final int typeId = 1;

  @override
  Pool read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pool(
      addr: fields[0] as String?,
      port: fields[1] as String?,
      passwd: fields[2] as String?,
      worker: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Pool obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.addr)
      ..writeByte(1)
      ..write(obj.port)
      ..writeByte(2)
      ..write(obj.passwd)
      ..writeByte(3)
      ..write(obj.worker);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoolAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
