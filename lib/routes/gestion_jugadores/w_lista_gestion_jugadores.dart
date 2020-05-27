import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
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
    if (boxJugadores.length > 0) {
      /*return GridView.count(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(boxJugadores.length, (iJugador) {
          final Jugador jugadorBox = boxJugadores.getAt(iJugador) as Jugador;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: InkWell(
              splashColor: Colors.lightGreen,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesJugador(
                      posicion: iJugador,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: colorear(jugadorBox.posicionFavorita),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ConversorImagen.imageFromBase64String(
                        jugadorBox.nombre_foto, context),
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
              ),
            ),
          );
        }),
      );*/
      return ListView(
        shrinkWrap: true,
        children: List.generate(boxJugadores.length, (iJugador) {
          final Jugador jugadorBox = boxJugadores.getAt(iJugador) as Jugador;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: InkWell(
              splashColor: Colors.lightGreen,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesJugador(
                      posicion: iJugador,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * .05,
                  MediaQuery.of(context).size.width * .01,
                  MediaQuery.of(context).size.width * .1,
                  MediaQuery.of(context).size.width * .01,
                ),
                //decoration: colorear(jugadorBox.posicionFavorita),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      /*child: Table(
                        children: [
                          TableRow(
                            children: [
                              ConversorImagen.imageFromBase64String(jugadorBox.nombre_foto, context),
                              Text(
                                jugadorBox.apodo,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ConversorImagen.imageFromBase64String(jugadorBox.nombre_foto, context),
                          Text(
                            jugadorBox.apodo,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .3,
                      child: Text(
                        jugadorBox.posicionFavorita,
                        textAlign: TextAlign.right,
                      ),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              /*child: FutureBuilder(
                future: jugadores,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return cartasJugadores(snapshot.data);
                  }

                  if (null == snapshot.data || snapshot.data.length == 0) {
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
          ],
        ),
      ),
    );
  }
}
