import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/database/DBHelper.dart';

class DetallesJugador extends StatefulWidget {
  final Jugador jugador;
  final int posicion;

  DetallesJugador({Key key, @required this.jugador, @required this.posicion}) : super(key: key);

  @override
  _DetallesJugador createState() => _DetallesJugador();
}

class _DetallesJugador extends State<DetallesJugador> {

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.jugador.nombre,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.lightGreen,
              ),
              tooltip: 'Editar jugador',
              onPressed: () {
                print("Editar");
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
              ConversorImagen.imageFromBase64String(widget.jugador.nombre_foto),
              //Nombre
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.jugador.nombre +
                        " " +
                        widget.jugador.apellido1 +
                        " " +
                        widget.jugador.apellido2),
                  ],
                ),
              ),
              //Apodo
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.jugador.apodo),
                  ],
                ),
              ),
              //Edad / Fecha de nacimiento
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.jugador.calcularEdad() +
                        " años / " +
                        widget.jugador.fechaNacimiento),
                  ],
                ),
              ),
              //Pierna buena
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Pierna buena: " + widget.jugador.piernaBuena),
                  ],
                ),
              ),
              //Posición favorita
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Posición favorita: " +
                        widget.jugador.posicionFavorita),
                  ],
                ),
              ),
              //Anotaciones
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Anotaciones: " + widget.jugador.anotaciones),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
