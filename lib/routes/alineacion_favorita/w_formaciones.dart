import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/routes/gestion_jugadores/detalles_jugadores/v_detalles_jugador.dart';

class Formacion extends StatefulWidget {
  final String formacion;

  Formacion({Key key, @required this.formacion}) : super(key: key);

  @override
  createState() => _Formacion();
}

Color colorear(String posicion) {
  Color coloreado = Colors.white;
  switch (posicion.toLowerCase()) {
    case "por":
    case "portero":
      coloreado = Colors.orange;
      break;
    case "def":
    case "central":
    case "líbero":
    case "lateral derecho":
    case "lateral izquierdo":
    case "carrilero derecho":
    case "carrilero izquierdo":
      coloreado = Colors.blue;
      break;
    case "med":
    case "mediocentro defensivo":
    case "mediocentro central":
    case "mediocentro ofensivo":
    case "interior derecho":
    case "interior izquierdo":
    case "mediapunta":
      coloreado = Colors.green;
      break;
    case "del":
    case "falso 9":
    case "segundo delantero":
    case "delantero centro":
    case "extremo derecho":
    case "extremo izquierdo":
      coloreado = Colors.red;
      break;
  }
  return coloreado.withOpacity(.7);
}

class _Formacion extends State<Formacion> {
  //Future<List<Jugador>> jugadores;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  //Posiciones ocupadas por jugadores
  Map<String, dynamic> posicionesOcupadas = {
    '0': null,
    '1': null,
    '2': null,
    '3': null,
    '4': null,
    '5': null,
    '6': null,
    '7': null,
    '8': null,
    '9': null,
    '10': null
  };

/*refreshList() {
    setState(() {
      //jugadores = DBHelper.getJugadoresPorPosiciones();
    });
  }*/

  refreshPosicionesOcupadas(Map<String, dynamic> posOcup) {
    setState(() {
      posicionesOcupadas = posOcup;
    });
  }

  @override
  Widget build(BuildContext context) {
    //refreshList();
    return dibujoFormacion();
  }

  Widget dibujoFormacion() {
    Widget dibujo;
    switch (widget.formacion) {
      case "14231":
        dibujo = Dibujo14231();
        break;
      case "1442":
        dibujo = Dibujo1442();
        break;
      case "1433":
        dibujo = Dibujo1433();
        break;
      case "1451":
        dibujo = Dibujo1451();
        break;
      case "1532":
        dibujo = Dibujo1532();
        break;
      case "1523":
        dibujo = Dibujo1523();
        break;
      case "13232":
        dibujo = Dibujo13232();
        break;
      case "1352":
        dibujo = Dibujo1352();
        break;
      case "1334":
        dibujo = Dibujo1334();
        break;
    }

    return dibujo;
  }

  //cartasJugadores(List<Jugador> jugadores) {
  cartasJugadores() {
    /*int variable = 0;
    jugadores.forEach((f) {
      variable++;
    });
    return ListView(
      children: List.generate(variable, (iJugador) {
        return Card(
          child: new InkWell(
            splashColor: Colors.lightGreen,
            onTap: () {
              Navigator.pop(context, jugadores[iJugador]);
            },
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetallesJugador(jugador: jugadores[iJugador]),
                ),
              );
            },
            child: Container(
              color: colorear(jugadores[iJugador].posicionFavorita),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ConversorImagen.imageFromBase64String(
                      jugadores[iJugador].nombre_foto),
                  Column(
                    children: <Widget>[
                      Text(
                        jugadores[iJugador].apodo,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        jugadores[iJugador].posicionFavorita,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );*/

    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      return ListView(
        children: List.generate(boxJugadores.length, (iJugador) {
          final Jugador jugadorBox = boxJugadores.getAt(iJugador) as Jugador;
          return Card(
            child: new InkWell(
              splashColor: Colors.lightGreen,
              onTap: () {
                Navigator.pop(context, jugadorBox);
              },
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetallesJugador(posicion: iJugador,),
                  ),
                );
              },
              child: Container(
                color: colorear(jugadorBox.posicionFavorita),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ConversorImagen.imageFromBase64String(
                        jugadorBox.nombre_foto, context),
                    Column(
                      children: <Widget>[
                        Text(
                          jugadorBox.apodo,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          jugadorBox.posicionFavorita,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    } else {
      return Center(
        child: Text("No hay ningún jugador creado."),
      );
    }
  }

  Widget jugadorElegidoContainer(Jugador j, String posicion) {
    if (j != null && j is Jugador) {
      return Container(
        color: colorear(posicion),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConversorImagen.imageFromBase64String(j.nombre_foto, context),
            Text(j.apodo),
          ],
        ),
      );
    } else {
      return Container(
        color: colorear(posicion),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConversorImagen.imageFromBase64String("", context),
            Text(posicion),
          ],
        ),
      );
    }
  }

  /*
  @posicion = Posición del jugador, se utiliza para el color y el nombre del
    jugador (no elegido).
  @numAlineacion = Posición del jugador respecto al número que ocupa.
   */
  Widget jugadorFormacion(String posicion, int numAlineacion) {
    Jugador jugadorElegido = null;
    return Card(
      child: new InkWell(
        splashColor: Colors.lightGreen,
        onTap: () async {
          jugadorElegido = await showDialog<Jugador>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              //this right here
              /*child: FutureBuilder(
                      future: jugadores,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return cartasJugadores(snapshot.data);
                        }

                        if (null == snapshot.data ||
                            snapshot.data.length == 0) {
                          return Text("No hay jugadores guardados.");
                        }

                        return CircularProgressIndicator();
                      },
                    ),*/
              child: FutureBuilder(
                future: Hive.openBox('jugadores'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text(snapshot.error.toString());
                    } else {
                      //return cartasJugadores(snapshot.data);
                      return cartasJugadores();
                    }
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              ),
            ),
          );
          if (jugadorElegido != null && jugadorElegido is Jugador) {
            //Actualizar contenido
            posicionesOcupadas['$numAlineacion'] = jugadorElegido;
            refreshPosicionesOcupadas(posicionesOcupadas);
          }
        },
        //Esto se puede quitar
        /*onLongPress: () {
          if (posicionesOcupadas['$numAlineacion'] != null &&
              posicionesOcupadas['$numAlineacion'] is Jugador) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetallesJugador(
                    jugador: posicionesOcupadas['$numAlineacion']),
              ),
            );
          }
        },*/
        child: jugadorElegidoContainer(
            posicionesOcupadas["$numAlineacion"], posicion),
      ),
    );
  }

  /*----------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  ----------------------------Dibujos de formaciones----------------------------
  ------------------------------------------------------------------------------
  ----------------------------------------------------------------------------*/

  Widget Dibujo14231() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("del", 10),
          ],
        ),
        //Medios 2
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 9),
            jugadorFormacion("med", 8),
            jugadorFormacion("med", 7),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 6),
            jugadorFormacion("med", 5),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("def", 4),
            jugadorFormacion("def", 3),
            jugadorFormacion("def", 2),
            jugadorFormacion("def", 1),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("por", 0),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1442() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("del", 10),
            jugadorFormacion("del", 9),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 8),
            jugadorFormacion("med", 7),
            jugadorFormacion("med", 6),
            jugadorFormacion("med", 5),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("def", 4),
            jugadorFormacion("def", 3),
            jugadorFormacion("def", 2),
            jugadorFormacion("def", 1),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("por", 0),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1433() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("del", 10),
            jugadorFormacion("del", 9),
            jugadorFormacion("del", 8),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 7),
            jugadorFormacion("med", 6),
            jugadorFormacion("med", 5),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("def", 4),
            jugadorFormacion("def", 3),
            jugadorFormacion("def", 2),
            jugadorFormacion("def", 1),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("por", 0),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1451() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("del", 10),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 9),
            jugadorFormacion("med", 8),
            jugadorFormacion("med", 7),
            jugadorFormacion("med", 6),
            jugadorFormacion("med", 5),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("def", 4),
            jugadorFormacion("def", 3),
            jugadorFormacion("def", 2),
            jugadorFormacion("def", 1),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("por", 0),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1532() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("del", 10),
            jugadorFormacion("del", 9),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 8),
            jugadorFormacion("med", 7),
            jugadorFormacion("med", 6),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("def", 5),
            jugadorFormacion("def", 4),
            jugadorFormacion("def", 3),
            jugadorFormacion("def", 2),
            jugadorFormacion("def", 1),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("por", 0),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1523() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("del", 10),
            jugadorFormacion("del", 9),
            jugadorFormacion("del", 8),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 7),
            jugadorFormacion("med", 6),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("def", 5),
            jugadorFormacion("def", 4),
            jugadorFormacion("def", 3),
            jugadorFormacion("def", 2),
            jugadorFormacion("def", 1),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("por", 0),
          ],
        ),
      ],
    );
  }

  Widget Dibujo13232() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("del", 10),
            jugadorFormacion("del", 9),
          ],
        ),
        //Medios 2
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 8),
            jugadorFormacion("med", 7),
            jugadorFormacion("med", 6),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 5),
            jugadorFormacion("med", 4),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("def", 3),
            jugadorFormacion("def", 2),
            jugadorFormacion("def", 1),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("por", 0),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1352() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("del", 10),
            jugadorFormacion("del", 9),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 8),
            jugadorFormacion("med", 7),
            jugadorFormacion("med", 6),
            jugadorFormacion("med", 5),
            jugadorFormacion("med", 4),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("def", 3),
            jugadorFormacion("def", 2),
            jugadorFormacion("def", 1),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("por", 0),
          ],
        ),
      ],
    );
  }

  Widget Dibujo1334() {
    return Column(
      children: <Widget>[
        //Delanteros
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("del", 10),
            jugadorFormacion("del", 9),
            jugadorFormacion("del", 8),
            jugadorFormacion("del", 7),
          ],
        ),
        //Medios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("med", 6),
            jugadorFormacion("med", 5),
            jugadorFormacion("med", 4),
          ],
        ),
        //Defensas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("def", 3),
            jugadorFormacion("def", 2),
            jugadorFormacion("def", 1),
          ],
        ),
        //Portero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jugadorFormacion("por", 0),
          ],
        ),
      ],
    );
  }
}
