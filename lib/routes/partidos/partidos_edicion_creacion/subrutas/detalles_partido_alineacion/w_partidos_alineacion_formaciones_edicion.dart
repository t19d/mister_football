import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/routes/gestion_jugadores/detalles_jugadores/v_detalles_jugador.dart';

class PartidoAlineacionFormacionEdicion extends StatefulWidget {
  final int posicion;
  final String formacion;

  PartidoAlineacionFormacionEdicion({Key key, @required this.formacion, @required this.posicion}) : super(key: key);

  @override
  createState() => _PartidoAlineacionFormacionEdicion();
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

class _PartidoAlineacionFormacionEdicion extends State<PartidoAlineacionFormacionEdicion> {
  //Posiciones ocupadas por jugadores
  /*List<dynamic> posicionesOcupadas = [];*/

  //Posiciones ocupadas por jugadores
  Map<String, String> posicionesOcupadas = {
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

  void refreshPosicionesOcupadas(Map<String, dynamic> posOcup) {
    setState(() {
      posicionesOcupadas = posOcup;
    });
  }

  @override
  Widget build(BuildContext context) {
    //refreshList();
    /*return dibujoFormacion();*/
    return FutureBuilder(
      future: Hive.openBox('partidos'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            final boxPartidos = Hive.box('partidos');
            //final boxJugadoresEquipo = Hive.box('jugadores');
            //Añadir lista de los jugadores convocados al partido.
            Partido partidoActual = boxPartidos.getAt(widget.posicion);
            if (partidoActual.alineacion != null) {
              if (partidoActual.alineacion['0'][0] != null) {
                posicionesOcupadas = Map<String, String>.from(partidoActual.alineacion['0'][1]);
                //Comprobar si los jugadores alineados están convocados.
                for (var keyPosicion in posicionesOcupadas.keys) {
                  print('$keyPosicion was written by ${posicionesOcupadas[keyPosicion]}');
                  if (posicionesOcupadas[keyPosicion] != null) {
                    bool _isConvocado = false;
                    for (int i = 0; i < partidoActual.convocatoria.length; i++) {
                      if (posicionesOcupadas[keyPosicion] == partidoActual.convocatoria[i]) {
                        _isConvocado = true;
                      }
                    }
                    if (!_isConvocado) {
                      posicionesOcupadas[keyPosicion] = null;
                    }
                  }
                }
              }
            }
            return dibujoFormacion();
          }
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width * .9,
            child: LinearProgressIndicator(),
          );
        }
      },
    );
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

  /* CONVOCATORIA */
  //DIÁLOGO CON LOS JUGADORES CONVOCADOS

  Widget cartasJugadores(String posicionAlineacion) {
    final boxPartidos = Hive.box('partidos');
    final boxJugadoresEquipo = Hive.box('jugadores');
    //Añadir lista de los jugadores convocados al partido.
    Partido partidoActual = boxPartidos.getAt(widget.posicion);
    List<String> jugadoresConvocados = [];
    //Si la lista es null
    if (partidoActual.convocatoria != null) {
      jugadoresConvocados = partidoActual.convocatoria;
    }
    if (jugadoresConvocados.length > 0) {
      return ListView(
        children: List.generate(jugadoresConvocados.length, (idJugador) {
          Jugador jugadorBox;
          for (var i = 0; i < boxJugadoresEquipo.length; i++) {
            if ('${jugadoresConvocados[idJugador]}' == boxJugadoresEquipo.getAt(i).id) {
              jugadorBox = boxJugadoresEquipo.getAt(i);
            }
          }
          return Card(
            child: new InkWell(
              splashColor: Colors.lightGreen,
              onTap: () async {
                //Guardar y actualizar
                //Actualizar contenido
                for (var keyPosicion in posicionesOcupadas.keys) {
                  print('$keyPosicion was written by ${posicionesOcupadas[keyPosicion]}');
                  if (posicionesOcupadas[keyPosicion] != null) {
                    bool _isRepetido = false;
                    for (int i = 0; i < partidoActual.convocatoria.length; i++) {
                      if (posicionesOcupadas[keyPosicion] == jugadorBox.id) {
                        _isRepetido = true;
                      }
                    }
                    if (_isRepetido) {
                      posicionesOcupadas[keyPosicion] = null;
                    }
                  }
                }

                posicionesOcupadas['${posicionAlineacion}'] = jugadorBox.id;
                refreshPosicionesOcupadas(posicionesOcupadas);
                //Guardar partido
                Map<String, List> alineacionActualizada = {};
                if (partidoActual.alineacion != null) {
                  alineacionActualizada = await partidoActual.alineacion;
                  alineacionActualizada['0'][1] = posicionesOcupadas;
                  print(alineacionActualizada['0'][1]);
                } else {
                  alineacionActualizada['0'] = [widget.formacion, posicionAlineacion];
                }
                Partido p = Partido(
                    fecha: partidoActual.fecha,
                    hora: partidoActual.hora,
                    lugar: partidoActual.lugar,
                    rival: partidoActual.rival,
                    tipoPartido: partidoActual.tipoPartido,
                    convocatoria: partidoActual.convocatoria,
                    alineacion: alineacionActualizada,
                    golesAFavor: partidoActual.golesAFavor,
                    golesEnContra: partidoActual.golesEnContra,
                    lesiones: partidoActual.lesiones,
                    tarjetas: partidoActual.tarjetas,
                    cambios: partidoActual.cambios,
                    observaciones: partidoActual.observaciones,
                    isLocal: partidoActual.isLocal);
                Box boxPartidosEditarAlineacion = await Hive.openBox('partidos');
                await boxPartidosEditarAlineacion.putAt(widget.posicion, p);
                setState(() {});
                Navigator.pop(context, jugadorBox);
              },
              child: Container(
                color: colorear(jugadorBox.posicionFavorita),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ConversorImagen.imageFromBase64String(jugadorBox.nombre_foto, context),
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
        child: Text("No hay ningún jugador convocado."),
      );
    }
  }

  /*  */

  /* ALINEACIÓN */
  //CONTENIDO DEL ITEM DE CADA FILA CON EL JUGADOR SELECCIONADO
  Widget jugadorElegidoContainer(String idJugador, String posicion) {
    /*final boxPartidos = Hive.box('partidos');
    //Añadir lista de los jugadores convocados al partido.
    Partido partidoActual = boxPartidos.getAt(widget.posicion);
    List<Jugador> jugadoresConvocados = [];
    //Si la lista es null
    if(partidoActual.convocatoria != null){
      jugadoresConvocados = partidoActual.convocatoria;
    }*/
    final boxJugadoresEquipo = Hive.box('jugadores');
    Jugador j;
    for (var i = 0; i < boxJugadoresEquipo.length; i++) {
      if ('${idJugador}' == boxJugadoresEquipo.getAt(i).id) {
        j = boxJugadoresEquipo.getAt(i);
      }
    }
    if (j != null && j is Jugador) {
      return Container(
        width: MediaQuery.of(context).size.width / 6,
        decoration: BoxDecoration(
          color: colorear(posicion),
          border: Border.all(width: .5),
        ),
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
        width: MediaQuery.of(context).size.width / 6,
        //width: MediaQuery.of(context).size.width * .1,
        decoration: BoxDecoration(border: Border.all(width: .5)),
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

  //ITEM DE CADA FILA CON EL JUGADOR SELECCIONADO
  /*
  @posicion = Posición del jugador, se utiliza para el color y el nombre del
    jugador (no elegido).
  @numAlineacion = Posición del jugador respecto al número que ocupa.
   */
  Widget jugadorFormacion(String posicion, int numAlineacion) {
    Jugador jugadorElegido = null;
    /*return FutureBuilder(
      future: Hive.openBox('partidos'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
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
                      child: FutureBuilder(
                        future: Hive.openBox('partidos'),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              print(snapshot.error.toString());
                              return Text(snapshot.error.toString());
                            } else {
                              return cartasJugadores('${numAlineacion}');
                            }
                          } else {
                            return Container(
                              height: MediaQuery.of(context).size.height * .5,
                              width: MediaQuery.of(context).size.width * .9,
                              child: LinearProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
                child: jugadorElegidoContainer(posicionesOcupadas["$numAlineacion"], posicion),
              ),
            );
          }
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width * .9,
            child: LinearProgressIndicator(),
          );
        }
      },
    );*/
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
              child: FutureBuilder(
                future: Hive.openBox('partidos'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Container(
                        height: MediaQuery.of(context).size.height * .015,
                        width: MediaQuery.of(context).size.width * .015,
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return cartasJugadores('${numAlineacion}');
                    }
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height * .015,
                      width: MediaQuery.of(context).size.width * .015,
                      child: LinearProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        },
        child: FutureBuilder(
          future: Hive.openBox('jugadores'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Container(
                  height: MediaQuery.of(context).size.height * .5,
                  width: MediaQuery.of(context).size.width * .9,
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return jugadorElegidoContainer(posicionesOcupadas["$numAlineacion"], posicion);
              }
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * .05,
                width: MediaQuery.of(context).size.width * .0225,
                child: LinearProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

/*  */
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
