// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip_range_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IpRangeModelAdapter extends TypeAdapter<IpRangeModel> {
  @override
  final int typeId = 0;

  @override
  IpRangeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IpRangeModel(
      rawIpRange: fields[0] as String?,
      startIp: fields[1] as String?,
      endIp: fields[2] as String?,
      comment: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IpRangeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.rawIpRange)
      ..writeByte(1)
      ..write(obj.startIp)
      ..writeByte(2)
      ..write(obj.endIp)
      ..writeByte(3)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IpRangeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
