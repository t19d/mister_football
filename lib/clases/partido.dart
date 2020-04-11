import 'package:hive/hive.dart';
import 'package:mister_football/clases/jugador.dart';

part 'partido.g.dart';

@HiveType(typeId: 2)
class Partido {
  @HiveField(0)
  final String fecha;
  @HiveField(1)
  final String hora;
  @HiveField(2)
  final String lugar;
  @HiveField(3)
  final String rival;
  @HiveField(4)
  final String tipoPartido;
  @HiveField(5)
  final List<Jugador> convocatoria;
  @HiveField(6)
  final List<dynamic> alineacion;
  @HiveField(7)
  final List<dynamic> golesAFavor;
  @HiveField(8)
  final List<dynamic> golesEnContra;
  @HiveField(9)
  final List<dynamic> lesiones;
  @HiveField(10)
  final List<dynamic> tarjetas;
  @HiveField(11)
  final List<dynamic> cambios;
  @HiveField(12)
  final String observaciones;

  Partido(
      {this.fecha,
      this.hora,
      this.lugar,
      this.rival,
      this.tipoPartido,
      this.convocatoria,
      this.alineacion,
      this.golesAFavor,
      this.golesEnContra,
      this.lesiones,
      this.tarjetas,
      this.cambios,
      this.observaciones});
}
