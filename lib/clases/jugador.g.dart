// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jugador.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JugadorAdapter extends TypeAdapter<Jugador> {
  @override
  final typeId = 0;

  @override
  Jugador read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Jugador(
      nombre: fields[0] as String,
      apellido1: fields[1] as String,
      apellido2: fields[2] as String,
      apodo: fields[3] as String,
      fechaNacimiento: fields[4] as String,
      piernaBuena: fields[5] as String,
      posicionFavorita: fields[6] as String,
      anotaciones: fields[13] as String,
      nombre_foto: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Jugador obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.nombre)
      ..writeByte(1)
      ..write(obj.apellido1)
      ..writeByte(2)
      ..write(obj.apellido2)
      ..writeByte(3)
      ..write(obj.apodo)
      ..writeByte(4)
      ..write(obj.fechaNacimiento)
      ..writeByte(5)
      ..write(obj.piernaBuena)
      ..writeByte(6)
      ..write(obj.posicionFavorita)
      ..writeByte(7)
      ..write(obj.otrasPosiciones)
      ..writeByte(8)
      ..write(obj.lesion)
      ..writeByte(9)
      ..write(obj.lesiones)
      ..writeByte(10)
      ..write(obj.sancion)
      ..writeByte(11)
      ..write(obj.tarjetas)
      ..writeByte(12)
      ..write(obj.partidos)
      ..writeByte(13)
      ..write(obj.anotaciones)
      ..writeByte(14)
      ..write(obj.nombre_foto);
  }
}
