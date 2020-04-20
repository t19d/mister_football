import 'package:hive/hive.dart';

part 'entrenamiento.g.dart';

@HiveType(typeId: 1)
class Entrenamiento {
  @HiveField(0)
  final String fecha;
  @HiveField(1)
  final String hora;
  @HiveField(2)
  //El JSON de ejercicios es estático y no dinámico.
  //Las claves no se van a repetir.
  final List<String> ejercicios;
  @HiveField(3)
  final List<dynamic> jugadoresOpiniones;
  @HiveField(4)
  final String anotaciones;

  Entrenamiento({
    this.fecha,
    this.hora,
    this.ejercicios,
    this.jugadoresOpiniones,
    this.anotaciones,
  });
}
