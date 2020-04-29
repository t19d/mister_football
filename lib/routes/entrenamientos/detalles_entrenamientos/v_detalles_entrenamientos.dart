import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/entrenamiento.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mister_football/clases/jugador.dart';

class DetallesEnternamiento extends StatefulWidget {
  final int posicion;

  DetallesEnternamiento({Key key, @required this.posicion}) : super(key: key);

  @override
  _DetallesEnternamiento createState() => _DetallesEnternamiento();
}

class _DetallesEnternamiento extends State<DetallesEnternamiento> {
  Entrenamiento entrenamiento = null;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('entrenamientos'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            final boxEntrenamientos = Hive.box('entrenamientos');
            entrenamiento = boxEntrenamientos.getAt(widget.posicion);
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Detalles",
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.lightGreen,
                      ),
                      tooltip: 'Editar jugador',
                      onPressed: () {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GestionJugadoresEdicion(jugador: jugador, posicion: widget.posicion,),
                          ),
                        );*/
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
                        var boxEntrenamientos = await Hive.openBox('entrenamientos');
                        print(widget.posicion);
                        boxEntrenamientos.deleteAt(widget.posicion);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //Fecha y hora
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(entrenamiento.fecha),
                          Text(entrenamiento.hora),
                        ],
                      ),
                      //Ejercicios
                      Column(
                        children: <Widget>[
                          Text("Ejercicios"),
                          FutureBuilder(
                            future: cargarEjercicios(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasError) {
                                  print(snapshot.error.toString());
                                  return Text(snapshot.error.toString());
                                } else {
                                  return mostrarEjerciciosSeleccionados(snapshot.data, entrenamiento.ejercicios);
                                }
                              } else {
                                return LinearProgressIndicator();
                              }
                            },
                          ),
                        ],
                      ),
                      //Jugadores
                      Column(
                        children: <Widget>[
                          Text("Jugadores"),
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
                                  return mostrarJugadoresSeleccionados(entrenamiento.jugadoresOpiniones);
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

  /* Ejercicios */
  //Cargar lista de ejercicios desde JSON
  Future<String> cargarEjercicios() async {
    return await rootBundle.loadString('assets/json/ejercicios.json');
  }

  //Mostrar ejercicios seleccionados
  mostrarEjerciciosSeleccionados(String ejerciciosString, List<String> ejercicios) {
    List<dynamic> listaEjerciciosJSON = jsonDecode(ejerciciosString);
    if (ejercicios.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(ejercicios.length, (iEjercicio) {
          return Text("${iEjercicio + 1}-${listaEjerciciosJSON[int.parse(ejercicios[iEjercicio]) - 1]['titulo']}");
        }),
      );
    } else {
      return Center(
        child: Text("No hay ningún ejercicio añadido."),
      );
    }
  }

  /*  */

  /* Jugadores */
  //Mostrar jugadores seleccionados

  mostrarJugadoresSeleccionados(List<dynamic> jugadoresElegidos) {
    Box boxJugadoresEquipo = Hive.box('jugadores');
    if (jugadoresElegidos.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(jugadoresElegidos.length, (iFila) {
          Jugador jugadorFila;
          for (var i = 0; i < boxJugadoresEquipo.length; i++) {
            if (jugadoresElegidos[iFila]['idJugador'] == boxJugadoresEquipo.getAt(i).id) {
              jugadorFila = boxJugadoresEquipo.getAt(i);
            }
          }
          return Text("-${jugadorFila.nombre}");
        }),
      );
    } else {
      return Center(
        child: Text("No hay ningún jugador añadido."),
      );
    }
  }
  /*mostrarJugadoresSeleccionados(List<dynamic> jugadoresElegidos) {
    if (jugadoresElegidos.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(jugadoresElegidos.length, (iJugador) {
          final Jugador jugadorBox = jugadoresElegidos[iJugador] as Jugador;
          return Text("-${jugadorBox.nombre}");
        }),
      );
    } else {
      return Center(
        child: Text("No hay ningún jugador añadido."),
      );
    }
  }*/
/*  */
}
