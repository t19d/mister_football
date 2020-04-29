import 'package:hive/hive.dart';
part 'jugador.g.dart';

@HiveType(typeId: 0)
class Jugador {
  @HiveField(0)
  final String nombre;
  @HiveField(1)
  final String apellido1;
  @HiveField(2)
  final String apellido2;
  //Opcional. En caso de estar vacío, se pone el apellido1
  @HiveField(3)
  final String apodo;// = "";
  @HiveField(4)
  final String fechaNacimiento;
  @HiveField(5)
  final String piernaBuena;
  @HiveField(6)
  final String posicionFavorita;
  @HiveField(7)
  final List otrasPosiciones = [];
  @HiveField(8)
  final bool lesion = false;
  @HiveField(9)
  final List lesiones = [];
  @HiveField(10)
  final bool sancion = false;
  @HiveField(11)
  final List tarjetas = [];
  @HiveField(12)
  final List partidos = [];
  @HiveField(13)
  final String anotaciones;
  @HiveField(14)
  final String nombre_foto;
  @HiveField(15)
  final String id;

  Jugador(
      {this.nombre,
      this.apellido1,
      this.apellido2,
      this.apodo,
      this.fechaNacimiento,
      this.piernaBuena,
      this.posicionFavorita,
      this.anotaciones,
      this.nombre_foto,
      this.id});
/*
  Jugador.sinApodo(
      {
      this.nombre,
      this.apellido1,
      this.apellido2,
      this.fechaNacimiento,
      this.piernaDerechaBuena,
      this.posicionFavorita,
      this.anotaciones,
      this.nombre_foto});

  Jugador.sinAnotaciones(
      {this.id,
      this.nombre,
      this.apellido1,
      this.apellido2,
      this.apodo,
      this.fechaNacimiento,
      this.piernaDerechaBuena,
      this.posicionFavorita,
      this.nombre_foto});

  Jugador.sinFoto(
      {this.id,
      this.nombre,
      this.apellido1,
      this.apellido2,
      this.apodo,
      this.fechaNacimiento,
      this.piernaDerechaBuena,
      this.posicionFavorita,
      this.anotaciones});

  Jugador.sinApodoNiAnotaciones(
      {this.id,
      this.nombre,
      this.apellido1,
      this.apellido2,
      this.fechaNacimiento,
      this.piernaDerechaBuena,
      this.posicionFavorita,
      this.nombre_foto});

  Jugador.sinFotoNiAnotaciones(
      {this.id,
      this.nombre,
      this.apellido1,
      this.apellido2,
      this.apodo,
      this.fechaNacimiento,
      this.piernaDerechaBuena,
      this.posicionFavorita});

  Jugador.sinApodoNiFoto(
      {this.id,
      this.nombre,
      this.apellido1,
      this.apellido2,
      this.fechaNacimiento,
      this.piernaDerechaBuena,
      this.posicionFavorita,
      this.anotaciones});

  Jugador.sinApodoNiAnotacionesNiFoto(
      {this.id,
      this.nombre,
      this.apellido1,
      this.apellido2,
      this.fechaNacimiento,
      this.piernaDerechaBuena,
      this.posicionFavorita});
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nombre': nombre,
      'apellido1': apellido1,
      'apellido2': apellido2,
      'apodo': apodo,
      'fechaNacimiento': fechaNacimiento,
      'piernaDerechaBuena': piernaDerechaBuena,
      'posicionFavorita': posicionFavorita,
      'anotaciones': anotaciones,
      'nombre_foto': nombre_foto
    };
    return map;
  }

  Jugador.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nombre = map['nombre'];
    apellido1 = map['apellido1'];
    apellido2 = map['apellido2'];
    apodo = map['apodo'];
    fechaNacimiento = map['fechaNacimiento'];
    if (map['piernaDerechaBuena'] == "1") {
      piernaBuena = "Derecha";
      piernaDerechaBuena = true;
    } else {
      piernaBuena = "Izquierda";
      piernaDerechaBuena = false;
    }
    posicionFavorita = map['posicionFavorita'];
    anotaciones = map['anotaciones'];
    nombre_foto = map['nombre_foto'];
  }
  */

  String calcularEdad() {
    int edad = 0;
    List<String> hoy =
        DateTime.now().toLocal().toString().split(' ')[0].split('-');
    List<String> nacimiento = this.fechaNacimiento.split('-');
    edad = int.parse(hoy[0]) - int.parse(nacimiento[0]);
    //Si es el mes de nacimiento se comprueba si ya ha pasado el día o estamos en él
    if ((int.parse(hoy[1]) - int.parse(nacimiento[1])) == 0) {
      if ((int.parse(hoy[2]) - int.parse(nacimiento[2])) < 0) {
        edad -= 1;
      }
    } else {
      if ((int.parse(hoy[1]) - int.parse(nacimiento[1])) < 0) {
        edad -= 1;
      }
    }
    return "$edad";
  }
}
