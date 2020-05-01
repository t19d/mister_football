import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/main.dart';
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
    Divider divisorGrupos = Divider(
      height: MediaQuery.of(context).size.height * .025,
      color: MisterFootball.complementarioLight,
    );
    Divider divisorElementos = Divider(
      height: MediaQuery.of(context).size.height * .01,
      color: MisterFootball.primarioLight,
    );

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
                  title: Text(jugador.apodo),
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
                            builder: (context) => GestionJugadoresEdicion(
                              jugador: jugador,
                              posicion: widget.posicion,
                            ),
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
                body: Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * .025),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Apodo
                      /*Text(jugador.apodo, style: TextStyle(fontSize: MediaQuery.of(context).size.width * .05),),*/
                      //Foto  | Nombre  | Apellido1 | Apellido2
                      //Foto  | Edad
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Foto
                          ConversorImagen.imageFromBase64String(jugador.nombre_foto, context),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //Nombre  | Apellido1 | Apellido2
                              Text(jugador.nombre + " " + jugador.apellido1 + " " + jugador.apellido2),
                              //Edad
                              Text(jugador.calcularEdad() + " años (${jugador.fechaNacimiento})"),
                            ],
                          ),
                        ],
                      ),
                      divisorGrupos,
                      //Nombre
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Nombre:"),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              jugador.nombre,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      //Text("Nombre: " + jugador.nombre),
                      divisorElementos,
                      //Primer apellido
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Primer apellido:"),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              jugador.apellido1,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      //Text("Primer apellido: " + jugador.apellido1),
                      divisorElementos,
                      //Segundo apellido
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Segundo apellido:"),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              jugador.apellido2,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      //Text("Segundo apellido: " + jugador.apellido2),
                      divisorElementos,
                      //Apodo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Apodo:"),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              jugador.apodo,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      //Text("Apodo: " + jugador.apodo),
                      divisorElementos,
                      //Pierna buena
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Pierna buena:"),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              jugador.piernaBuena,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      //Text("Pierna buena: " + jugador.piernaBuena),
                      divisorElementos,
                      //Posición favorita
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Posición favorita:"),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              jugador.posicionFavorita,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      //Text("Posición favorita: " + jugador.posicionFavorita),
                      divisorElementos,
                      //Anotaciones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Anotaciones:"),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              jugador.anotaciones,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      //Text("Anotaciones: " + jugador.anotaciones),
                      divisorGrupos,
                      //Historial y medias
                      Text("Histórico"),
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
