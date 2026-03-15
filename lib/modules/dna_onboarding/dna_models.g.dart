// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dna_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorPrefsAdapter extends TypeAdapter<ColorPrefs> {
  @override
  final int typeId = 1;

  @override
  ColorPrefs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColorPrefs(
      favorites: (fields[0] as List).cast<String>(),
      avoided: (fields[1] as List).cast<String>(),
      dominant: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ColorPrefs obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.favorites)
      ..writeByte(1)
      ..write(obj.avoided)
      ..writeByte(2)
      ..write(obj.dominant);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorPrefsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StylePrefsAdapter extends TypeAdapter<StylePrefs> {
  @override
  final int typeId = 2;

  @override
  StylePrefs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StylePrefs(
      scores: (fields[0] as Map).cast<String, double>(),
      top: (fields[1] as List).cast<String>(),
      dominant: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StylePrefs obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.scores)
      ..writeByte(1)
      ..write(obj.top)
      ..writeByte(2)
      ..write(obj.dominant);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StylePrefsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmotionPrefsAdapter extends TypeAdapter<EmotionPrefs> {
  @override
  final int typeId = 3;

  @override
  EmotionPrefs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmotionPrefs(
      frequency: (fields[0] as Map).cast<String, double>(),
      dominant: (fields[1] as List).cast<String>(),
      updated: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EmotionPrefs obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.frequency)
      ..writeByte(1)
      ..write(obj.dominant)
      ..writeByte(2)
      ..write(obj.updated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionPrefsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
