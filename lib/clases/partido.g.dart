// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partido.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartidoAdapter extends TypeAdapter<Partido> {
  @override
  final typeId = 2;

  @override
  Partido read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Partido(
      fecha: fields[0] as String,
      hora: fields[1] as String,
      lugar: fields[2] as String,
      rival: fields[3] as String,
      tipoPartido: fields[4] as String,
      convocatoria: (fields[5] as List)?.cast<Jugador>(),
      alineacion: (fields[6] as List)?.cast<dynamic>(),
      golesAFavor: (fields[7] as List)?.cast<dynamic>(),
      golesEnContra: (fields[8] as List)?.cast<dynamic>(),
      lesiones: (fields[9] as List)?.cast<dynamic>(),
      tarjetas: (fields[10] as List)?.cast<dynamic>(),
      cambios: (fields[11] as List)?.cast<dynamic>(),
      observaciones: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Partido obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.fecha)
      ..writeByte(1)
      ..write(obj.hora)
      ..writeByte(2)
      ..write(obj.lugar)
      ..writeByte(3)
      ..write(obj.rival)
      ..writeByte(4)
      ..write(obj.tipoPartido)
      ..writeByte(5)
      ..write(obj.convocatoria)
      ..writeByte(6)
      ..write(obj.alineacion)
      ..writeByte(7)
      ..write(obj.golesAFavor)
      ..writeByte(8)
      ..write(obj.golesEnContra)
      ..writeByte(9)
      ..write(obj.lesiones)
      ..writeByte(10)
      ..write(obj.tarjetas)
      ..writeByte(11)
      ..write(obj.cambios)
      ..writeByte(12)
      ..write(obj.observaciones);
  }
}
