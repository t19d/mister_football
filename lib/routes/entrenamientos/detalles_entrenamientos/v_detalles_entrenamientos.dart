import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/entrenamiento.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mister_football/clases/eventos.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/entrenamientos/entrenamientos_edicion_creacion/v_entrenamientos_edicion.dart';
import 'package:mister_football/routes/entrenamientos/v_entrenamientos.dart';

class DetallesEnternamiento extends StatefulWidget {
  final int posicion;

  DetallesEnternamiento({Key key, @required this.posicion}) : super(key: key);

  @override
  _DetallesEnternamiento createState() => _DetallesEnternamiento();
}

class _DetallesEnternamiento extends State<DetallesEnternamiento> {
  Entrenamiento entrenamiento;
  String ejerciciosFuture;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  Future<void> _openBox() async {
    await Hive.openBox("entrenamientos");
    await Hive.openBox("jugadores");
    //Ejercicios del JSON
    ejerciciosFuture = await cargarEjercicios();
  }

  @override
  Widget build(BuildContext context) {
    /*return FutureBuilder(
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
                      tooltip: 'Editar entrenamiento',
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
                      tooltip: 'Eliminar entrenamiento',
                      onPressed: () async {
                        //DBHelper.delete(widget.jugador.id);
                        var boxEntrenamientos = await Hive.openBox('entrenamientos');
                        print(widget.posicion);
                        var boxEventos = await Hive.openBox('eventos');
                        Eventos eventosActuales = boxEventos.get(0);
                        //Eliminar evento
                        eventosActuales.listaEventos.remove("${entrenamiento.fecha}/${entrenamiento.hora}");
                        boxEntrenamientos.deleteAt(widget.posicion);
                        boxEventos.putAt(0, eventosActuales);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Entrenamientos()),
                        );
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
    */
    return FutureBuilder(
      future: _openBox(),
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
                  /*title: Text("Detalles"),*/
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      tooltip: 'Editar entrenamiento',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EntrenamientosEdicion(
                              entrenamiento: entrenamiento,
                              posicion: widget.posicion,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: MisterFootball.colorComplementarioDelComplementarioLight,
                      ),
                      tooltip: 'Eliminar entrenamiento',
                      onPressed: () async {
                        var boxEntrenamientos = await Hive.openBox('entrenamientos');
                        print(widget.posicion);
                        var boxEventos = await Hive.openBox('eventos');
                        Eventos eventosActuales = boxEventos.get(0);
                        //Eliminar evento
                        eventosActuales.listaEventos.remove("${entrenamiento.fecha}/${entrenamiento.hora}");
                        boxEntrenamientos.deleteAt(widget.posicion);
                        boxEventos.putAt(0, eventosActuales);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Entrenamientos()),
                        );
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //Personas, fecha, hora
                      Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
                        decoration: BoxDecoration(
                          color: MisterFootball.colorPrimarioLight2.withOpacity(.25),
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                bottom: (MediaQuery.of(context).size.width * .03),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "${entrenamiento.jugadoresOpiniones.length}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.person),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //Fecha
                                Text(
                                  "${entrenamiento.fecha.split("-")[2]}-${entrenamiento.fecha.split("-")[1]}-${entrenamiento.fecha.split("-")[0]}",
                                  textAlign: TextAlign.center,
                                ),
                                //Hora
                                Text(
                                  entrenamiento.hora,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //Ejercicios
                      Container(
                        margin: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.width * 0.05),
                        ),
                        padding: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.width * 0.025),
                          bottom: (MediaQuery.of(context).size.width * 0.05),
                          left: (MediaQuery.of(context).size.width * 0.05),
                          right: (MediaQuery.of(context).size.width * 0.05),
                        ),
                        decoration: BoxDecoration(
                          color: MisterFootball.colorPrimarioLight2.withOpacity(.05),
                          border: Border(
                            top: BorderSide(width: .4),
                            bottom: BorderSide(width: .4),
                            left: BorderSide(width: .4),
                            right: BorderSide(width: .4),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 1.20,
                        //height: (ejercicios.length * 180).toDouble(),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Ejercicios",
                              style: TextStyle(decoration: TextDecoration.underline),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: (MediaQuery.of(context).size.width * 0.025),
                              ),
                              child: mostrarEjerciciosSeleccionados(ejerciciosFuture, entrenamiento.ejercicios),
                            ),
                          ],
                        ),
                      ),
                      //Jugadores
                      Container(
                        margin: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.width * 0.05),
                        ),
                        padding: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.width * 0.025),
                          bottom: (MediaQuery.of(context).size.width * 0.05),
                          left: (MediaQuery.of(context).size.width * 0.05),
                          right: (MediaQuery.of(context).size.width * 0.05),
                        ),
                        decoration: BoxDecoration(
                          color: MisterFootball.colorPrimarioLight2.withOpacity(.05),
                          border: Border(
                            top: BorderSide(width: .4),
                            bottom: BorderSide(width: .4),
                            left: BorderSide(width: .4),
                            right: BorderSide(width: .4),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 1.20,
                        //height: (ejercicios.length * 180).toDouble(),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Jugadores",
                              style: TextStyle(decoration: TextDecoration.underline),
                            ),
                            mostrarJugadoresSeleccionados(entrenamiento.jugadoresOpiniones),
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
          return Center(
            child: CircularProgressIndicator(),
          );
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
  Widget mostrarEjerciciosSeleccionados(String ejerciciosString, List<String> ejercicios) {
    List<dynamic> listaEjerciciosJSON = jsonDecode(ejerciciosString);
    if (ejercicios.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(ejercicios.length, (iEjercicio) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: .4),
                bottom: BorderSide(width: .4),
                left: BorderSide(width: .4),
                right: BorderSide(width: .4),
              ),
            ),
            margin: EdgeInsets.only(
              top: (iEjercicio != 0) ? 2.5 : 0,
              bottom: (iEjercicio != (ejercicios.length - 1)) ? 2.5 : 0,
              right: 0,
              left: 0,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width * .63),
                  padding: EdgeInsets.all((MediaQuery.of(context).size.width * 0.025)),
                  child: Text(
                    "${listaEjerciciosJSON[int.parse(ejercicios[iEjercicio]) - 1]['titulo']}",
                  ),
                ),
                Text(
                  "${iEjercicio + 1}º",
                ),
              ],
            ),
          );
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
  Widget mostrarJugadoresSeleccionados(List<dynamic> jugadoresElegidos) {
    Box boxJugadoresEquipo = Hive.box('jugadores');
    if (jugadoresElegidos.length > 0) {
      return ListView(
        //No Scroll
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(jugadoresElegidos.length, (iFila) {
          Jugador jugadorFila;
          for (var i = 0; i < boxJugadoresEquipo.length; i++) {
            if (jugadoresElegidos[iFila]['idJugador'] == boxJugadoresEquipo.getAt(i).id) {
              jugadorFila = boxJugadoresEquipo.getAt(i);
            }
          }
          //Jugador
          return (jugadorFila != null) ? Text("-${jugadorFila.apodo}") : Text("-Jugador eliminado");
        }),
      );
    } else {
      return Center(
        child: Text("No hay ningún jugador añadido."),
      );
    }
  }
}
