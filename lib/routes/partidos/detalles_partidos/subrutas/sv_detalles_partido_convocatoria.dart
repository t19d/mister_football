import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';

class DetallesPartidoConvocatoria extends StatefulWidget {
  final int posicion;

  DetallesPartidoConvocatoria({Key key, @required this.posicion}) : super(key: key);

  @override
  createState() => _DetallesPartidoConvocatoria();
}

class _DetallesPartidoConvocatoria extends State<DetallesPartidoConvocatoria> {
  Partido partido = null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('partidos'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            final boxEntrenamientos = Hive.box('partidos');
            partido = boxEntrenamientos.getAt(widget.posicion);
            return Scaffold(
              body: SafeArea(
                //Jugadores
                child: Container(
                  child: FutureBuilder(
                    future: Hive.openBox('jugadores'),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          print(snapshot.error.toString());
                          return Container(
                            width: MediaQuery.of(context).size.width / 1,
                            height: MediaQuery.of(context).size.height / 1,
                            child: Text(snapshot.error.toString()),
                          );
                        } else {
                          return mostrarJugadoresSeleccionados(partido.convocatoria);
                        }
                      } else {
                        return Container(
                          width: MediaQuery.of(context).size.width / 1,
                          height: MediaQuery.of(context).size.height / 1,
                          child: LinearProgressIndicator(),
                        );
                      }
                    },
                  ),
                  /*child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Jugadores"),
                        ],
                      ),
                      FutureBuilder(
                        future: Hive.openBox('jugadores'),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              print(snapshot.error.toString());
                              return Container(
                                width: MediaQuery.of(context).size.width / 1,
                                height: MediaQuery.of(context).size.height / 1,
                                child: Text(snapshot.error.toString()),
                              );
                            } else {
                              return mostrarJugadoresSeleccionados(partido.convocatoria);
                            }
                          } else {
                            return Container(
                              width: MediaQuery.of(context).size.width / 1,
                              height: MediaQuery.of(context).size.height / 1,
                              child: LinearProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ],
                  ),*/
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

  /* Jugadores */
  //Mostrar lista de los jugadores seleccionados en la convocatoria
  mostrarJugadoresSeleccionados(List<dynamic> jugadoresConvocados) {
    if (jugadoresConvocados != null) {
      if (jugadoresConvocados.length > 0) {
        return ListView(
          shrinkWrap: true,
          children: List.generate(jugadoresConvocados.length, (iJugador) {
            final Jugador jugadorBox = jugadoresConvocados[iJugador] as Jugador;
            return Text("-${jugadorBox.nombre}");
          }),
        );
      } else {
        return Center(
          child: Text("No hay ningún jugador añadido."),
        );
      }
    } else {
      return Center(
        child: Text("Convocatoria no creada."),
      );
    }
  }
}
