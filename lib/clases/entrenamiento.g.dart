// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entrenamiento.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntrenamientoAdapter extends TypeAdapter<Entrenamiento> {
  @override
  final typeId = 1;

  @override
  Entrenamiento read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Entrenamiento(
      fecha: fields[0] as String,
      hora: fields[1] as String,
      ejercicios: (fields[2] as List)?.cast<String>(),
      jugadoresOpiniones: (fields[3] as List)?.cast<dynamic>(),
      anotaciones: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Entrenamiento obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fecha)
      ..writeByte(1)
      ..write(obj.hora)
      ..writeByte(2)
      ..write(obj.ejercicios)
      ..writeByte(3)
      ..write(obj.jugadoresOpiniones)
      ..writeByte(4)
      ..write(obj.anotaciones);
  }
}
