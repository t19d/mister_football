import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/animaciones/animacion_detalles.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/gestion_jugadores/detalles_jugadores/v_detalles_jugador.dart';

class ListaGestionJugadores extends StatefulWidget {
  @override
  createState() => _ListaGestionJugadores();
}

class _ListaGestionJugadores extends State<ListaGestionJugadores> {
  //Future<List<Jugador>> jugadores;

  /*refreshList() {
    setState(() {
      //jugadores = DBHelper.getJugadoresPorPosiciones();
    });
  }*/

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  BoxDecoration colorear(posicion) {
    Color coloreado1 = Colors.white;
    Color coloreado2 = Colors.white70;
    switch (posicion) {
      case "Portero":
        coloreado1 = Colors.lightGreen;
        coloreado2 = Colors.redAccent;
        break;
      case "Lateral derecho":
      /*coloreado1 = Colors.lightBlue;
        coloreado2 = Colors.lightBlueAccent;
        break;*/
      case "Carrilero derecho":
      /*coloreado1 = Colors.indigo;
        coloreado2 = Colors.indigoAccent;
        break;*/
      case "Central":
      /*coloreado1 = Colors.blue;
        coloreado2 = Colors.blueAccent;
        break;*/
      case "Líbero":
      /*coloreado1 = Colors.lightBlue;
        coloreado2 = Colors.lightBlueAccent;
        break;*/
      case "Lateral izquierdo":
      /*coloreado1 = Colors.lightBlue;
        coloreado2 = Colors.lightBlueAccent;
        break;*/
      case "Carrilero izquierdo":
        /*coloreado1 = Colors.indigo;
        coloreado2 = Colors.indigoAccent;
        break;*/
        coloreado1 = Colors.yellow;
        coloreado2 = Colors.purpleAccent;
        break;
      case "Mediocentro defensivo":
      /*coloreado1 = Colors.lightGreen;
        coloreado2 = Colors.lightGreenAccent;
        break;*/
      case "Mediocentro central":
      /*coloreado1 = Colors.lightGreen;
        coloreado2 = Colors.lightGreenAccent;
        break;*/
      case "Mediocentro ofensivo":
      /*coloreado1 = Colors.green;
        coloreado2 = Colors.greenAccent;
        break;*/
      case "Interior derecho":
      /*coloreado1 = Colors.green;
        coloreado2 = Colors.greenAccent;
        break;*/
      case "Interior izquierdo":
      /*coloreado1 = Colors.green;
        coloreado2 = Colors.greenAccent;
        break;*/
      case "Mediapunta":
      /*coloreado1 = Colors.yellow;
        coloreado2 = Colors.yellowAccent;
        break;*/
      case "Falso 9":
        /*coloreado1 = Colors.lightGreenAccent;
        coloreado2 = Colors.redAccent;
        break;*/
        coloreado1 = Colors.orangeAccent;
        coloreado2 = Colors.lightBlueAccent;
        break;
      case "Segundo delantero":
      /*coloreado1 = Colors.red;
        coloreado2 = Colors.redAccent;
        break;*/
      case "Delantero centro":
      /*coloreado1 = Colors.red;
        coloreado2 = Colors.redAccent;
        break;*/
      case "Extremo derecho":
      /*coloreado1 = Colors.brown;
        coloreado2 = Colors.brown.withOpacity(.2);
        break;*/
      case "Extremo izquierdo":
        /*coloreado1 = Colors.brown;
        coloreado2 = Colors.brown.withOpacity(.2);
        break;*/
        coloreado1 = Colors.red;
        coloreado2 = Colors.purpleAccent;
        break;
    }
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [coloreado1, coloreado2],
      ),
      border: Border.all(width: 1, color: coloreado1),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
  }

/*
  SingleChildScrollView dataTable(List<Jugador> jugadores) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('NAME'),
          ),
          DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: jugadores
            .map(
              (jugador) => DataRow(cells: [
            DataCell(
              Text(jugador.nombre),
              onTap: () {
                setState(() {
                  isUpdating = true;
                  curUserId = jugador.id;
                });
              },
            ),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                DBHelper.delete(jugador.id);
                refreshList();
              },
            )),
          ]),
        )
            .toList(),
      ),
    );
  }
 */

  Widget cartasJugadores() {
    final boxJugadores = Hive.box('jugadores');

    List jugadoresOrdenados = [];
    for (var i = 0; i < boxJugadores.length; i++) {
      if (boxJugadores.getAt(i).habilitado) {
        jugadoresOrdenados.add([i, boxJugadores.getAt(i).apodo, boxJugadores.getAt(i).posicionFavorita]);
      }
    }
    //Ordenar por apodo
    jugadoresOrdenados.sort((a, b) => (a[1].toString().toLowerCase()).compareTo(b[1].toString().toLowerCase()));

    //Jugadores deshabilitados
    List jugadoresDeshabilitados = [];
    for (var i = 0; i < boxJugadores.length; i++) {
      if (!boxJugadores.getAt(i).habilitado) {
        jugadoresDeshabilitados.add([i, boxJugadores.getAt(i).apodo, boxJugadores.getAt(i).posicionFavorita]);
      }
    }
    //Ordenar por apodo
    jugadoresDeshabilitados.sort((a, b) => (a[1].toString().toLowerCase()).compareTo(b[1].toString().toLowerCase()));

    //Añadir jugadores deshabilitados a la lista
    jugadoresOrdenados.addAll(jugadoresDeshabilitados);
    if (boxJugadores.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(boxJugadores.length, (iJugador) {
          final Jugador jugadorBox = boxJugadores.getAt(jugadoresOrdenados[iJugador][0]) as Jugador;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: InkWell(
              splashColor: Colors.lightGreen,
              onTap: () {
                Navigator.push(
                  context,
                  /*MaterialPageRoute(
                    builder: (context) => DetallesJugador(
                      posicion: jugadoresOrdenados[iJugador][0],
                    ),
                  ),*/
                  AnimacionDetalles(
                    widget: DetallesJugador(
                      posicion: jugadoresOrdenados[iJugador][0],
                    ),
                  ),
                );
              },
              child: Container(
                /*padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * .05,
                  MediaQuery.of(context).size.width * .01,
                  MediaQuery.of(context).size.width * .1,
                  MediaQuery.of(context).size.width * .01,
                ),*/
                //decoration: colorear(jugadorBox.posicionFavorita),
                decoration: (jugadorBox.habilitado)
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: MisterFootball.primario),
                      )
                    : BoxDecoration(
                        color: MisterFootball.complementarioDelComplementarioLight2,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: MisterFootball.primario),
                      ),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        ConversorImagen.imageFromBase64String(jugadorBox.nombre_foto, context),
                        Text(
                          jugadorBox.apodo,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                        ),
                        (jugadorBox.habilitado)
                            ? Text(
                                jugadorBox.posicionFavorita,
                                textAlign: TextAlign.center,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: MisterFootball.primario,
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

  @override
  Widget build(BuildContext context) {
    //refreshList();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Hive.openBox('jugadores'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text(snapshot.error.toString());
              } else {
                return cartasJugadores();
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
