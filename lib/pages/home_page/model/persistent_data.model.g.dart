// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistent_data.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersistentDataModelAdapter extends TypeAdapter<PersistentDataModel> {
  @override
  final int typeId = 0;

  @override
  PersistentDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersistentDataModel(
      taskList: (fields[0] as List?)?.cast<HiveTaskModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, PersistentDataModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.taskList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersistentDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveTaskModelAdapter extends TypeAdapter<HiveTaskModel> {
  @override
  final int typeId = 1;

  @override
  HiveTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTaskModel(
      id: fields[0] as int?,
      title: fields[1] as String?,
      description: fields[2] as String?,
      date: fields[3] as String?,
      priority: fields[4] as String?,
      isSynced: fields[5] as bool?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveTaskModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.isSynced)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncQueueItemAdapter extends TypeAdapter<SyncQueueItem> {
  @override
  final int typeId = 2;

  @override
  SyncQueueItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncQueueItem(
      operation: fields[0] as String,
      id: fields[1] as int,
      timestamp: fields[2] as DateTime,
      changes: fields[3] as HiveTaskModel?,
    );
  }

  @override
  void write(BinaryWriter writer, SyncQueueItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.operation)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.changes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncQueueItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
