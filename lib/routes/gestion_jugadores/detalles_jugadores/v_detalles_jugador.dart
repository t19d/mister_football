import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/routes/gestion_jugadores/gestion_jugadores_edicion_creacion/v_gestion_jugadores_edicion.dart';

class DetallesJugador extends StatefulWidget {
  final int posicion;

  DetallesJugador({Key key, @required this.posicion}) : super(key: key);

  @override
  _DetallesJugador createState() => _DetallesJugador();
}

class _DetallesJugador extends State<DetallesJugador> {
  Jugador jugador = null;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('jugadores'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            final boxJugadores = Hive.box('jugadores');
            jugador = boxJugadores.getAt(widget.posicion);
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    jugador.nombre,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.lightGreen,
                      ),
                      tooltip: 'Editar jugador',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GestionJugadoresEdicion(jugador: jugador, posicion: widget.posicion,),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      tooltip: 'Eliminar jugador',
                      onPressed: () async {
                        //DBHelper.delete(widget.jugador.id);
                        var boxJugadores = await Hive.openBox('jugadores');
                        print(widget.posicion);
                        boxJugadores.deleteAt(widget.posicion);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      //Foto
                      ConversorImagen.imageFromBase64String(jugador.nombre_foto),
                      //Nombre
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(jugador.nombre +
                                " " +
                                jugador.apellido1 +
                                " " +
                                jugador.apellido2),
                          ],
                        ),
                      ),
                      //Apodo
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(jugador.apodo),
                          ],
                        ),
                      ),
                      //Edad / Fecha de nacimiento
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(jugador.calcularEdad() +
                                " años / " +
                                jugador.fechaNacimiento),
                          ],
                        ),
                      ),
                      //Pierna buena
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Pierna buena: " + jugador.piernaBuena),
                          ],
                        ),
                      ),
                      //Posición favorita
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Posición favorita: " +
                                jugador.posicionFavorita),
                          ],
                        ),
                      ),
                      //Anotaciones
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Anotaciones: " + jugador.anotaciones),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }
}
