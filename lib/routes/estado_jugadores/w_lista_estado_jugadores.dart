import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/gestion_jugadores/detalles_jugadores/v_detalles_jugador.dart';

class ListaEstadoJugadores extends StatefulWidget {
  @override
  createState() => _ListaEstadoJugadores();
}

class _ListaEstadoJugadores extends State<ListaEstadoJugadores> {
  /*Future<List<Jugador>> jugadores;

  refreshList() {
    setState(() {
      //jugadores = DBHelper.getJugadoresPorPosiciones();
    });
  }*/

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  Color colorear(posicion) {
    Color coloreado = Colors.white;
    switch (posicion) {
      case "Portero":
        coloreado = Colors.orange;
        break;
      case "Lateral derecho":
        coloreado = Colors.lightBlue;
        break;
      case "Carrilero derecho":
        coloreado = Colors.indigoAccent;
        break;
      case "Central":
        coloreado = Colors.blue;
        break;
      case "Líbero":
        coloreado = Colors.lightBlueAccent;
        break;
      case "Lateral izquierdo":
        coloreado = Colors.lightBlue;
        break;
      case "Carrilero izquierdo":
        coloreado = Colors.indigoAccent;
        break;
      case "Mediocentro defensivo":
        coloreado = Colors.lightGreenAccent;
        break;
      case "Mediocentro central":
        coloreado = Colors.lightGreen;
        break;
      case "Mediocentro ofensivo":
        coloreado = Colors.green;
        break;
      case "Interior derecho":
        coloreado = Colors.greenAccent;
        break;
      case "Interior izquierdo":
        coloreado = Colors.greenAccent;
        break;
      case "Mediapunta":
        coloreado = Colors.yellow;
        break;
      case "Falso 9":
        coloreado = Colors.yellowAccent;
        break;
      case "Segundo delantero":
        coloreado = Colors.red;
        break;
      case "Delantero centro":
        coloreado = Colors.redAccent;
        break;
      case "Extremo derecho":
        coloreado = Colors.brown;
        break;
      case "Extremo izquierdo":
        coloreado = Colors.brown;
        break;
    }
    return coloreado.withOpacity(.7);
  }

  //Widget itemJugadores(List<Jugador> jugadores) {
  Widget itemJugadores() {
    /*int variable = 0;
    jugadores.forEach((f) {
      variable++;
    });
    return ListView(
      children: List.generate(variable, (iJugador) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: new InkWell(
            splashColor: MisterFootball.complementario,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetallesJugador(jugador: jugadores[iJugador], posicion: iJugador,),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                 color:colorear(jugadores[iJugador].posicionFavorita),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //Foto
                  ConversorImagen.imageFromBase64String(
                      jugadores[iJugador].nombre_foto),
                  //Nombre
                  Text(
                    jugadores[iJugador].apodo,
                    textAlign: TextAlign.center,
                  ),
                  //Estado
                  Icon(
                    Icons.check_box,
                  ),
                  //Posición
                  Text(
                    jugadores[iJugador].posicionFavorita,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10),
                  ),
                  //Edad
                  Text(
                    jugadores[iJugador].calcularEdad() + " años",
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

    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      return ListView(
        children: List.generate(boxJugadores.length, (iJugador) {
          final Jugador jugadorBox = boxJugadores.getAt(iJugador) as Jugador;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new InkWell(
              splashColor: MisterFootball.colorComplementario,
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
                decoration: BoxDecoration(
                    color: colorear(jugadorBox.posicionFavorita),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //Foto
                    ConversorImagen.imageFromBase64String(
                        jugadorBox.nombre_foto, context),
                    //Nombre
                    Text(
                      jugadorBox.apodo,
                      textAlign: TextAlign.center,
                    ),
                    //Estado
                    Icon(
                      Icons.check_box,
                    ),
                    //Posición
                    Text(
                      jugadorBox.posicionFavorita,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                    //Edad
                    Text(
                      jugadorBox.calcularEdad() + " años",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
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
                    return itemJugadores(snapshot.data);
                  }

                  if (null == snapshot.data || snapshot.data.length == 0) {
                    return Text("No hay jugadores guardados.");
                  }

                  return CircularProgressIndicator();
                },
              ),
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
                      return itemJugadores();
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
