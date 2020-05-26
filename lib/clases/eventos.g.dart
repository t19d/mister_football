// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventos.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventosAdapter extends TypeAdapter<Eventos> {
  @override
  final typeId = 3;

  @override
  Eventos read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Eventos(
      listaEventos: (fields[0] as Map)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Eventos obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.listaEventos);
  }
}
