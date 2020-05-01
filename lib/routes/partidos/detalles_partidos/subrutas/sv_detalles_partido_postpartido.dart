import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';

class DetallesPartidoPostpartido extends StatefulWidget {
  final int posicion;

  DetallesPartidoPostpartido({Key key, @required this.posicion}) : super(key: key);

  @override
  createState() => _DetallesPartidoPostpartido();
}

class _DetallesPartidoPostpartido extends State<DetallesPartidoPostpartido> {
  Partido partido = null;

  //Goles a favor
  String _idJugadorSeleccionadoGolesAFavor = "";
  String _minutoSeleccionadoGolesAFavor = "";

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
                  child: Column(
                children: <Widget>[
                  /*
                        List<dynamic> golesAFavor;
                        List<dynamic> golesEnContra; //En este no se hace future con abrir jugadores, solo maneja partidos
                        List<dynamic> lesiones;
                        List<dynamic> tarjetas;
                        List<dynamic> cambios;
                        CAMBIAR ALINEACIÓN
                        String observaciones;
                       */
                  //Goles a Favor //[["0-0", "10", "idJugador"], ...] Resultado, Minuto, Jugador
                  Container(
                    //padding: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width * 0.05), 0, 0, MediaQuery.of(context).size.width * 0.05),
                    //width: MediaQuery.of(context).size.width * 0.9,
                    color: Colors.grey.withOpacity(.15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Goles a favor"),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.lightBlueAccent,
                              ),
                              tooltip: 'Añadir gol a favor',
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(content: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return FutureBuilder(
                                          future: Hive.openBox('jugadores'),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState == ConnectionState.done) {
                                              if (snapshot.hasError) {
                                                print(snapshot.error.toString());
                                                return Container(
                                                  width: MediaQuery.of(context).size.width * .5,
                                                  height: MediaQuery.of(context).size.height * .5,
                                                  child: Text(snapshot.error.toString()),
                                                );
                                              } else {
                                                return listaSeleccionarJugadores(partido, setState);
                                              }
                                            } else {
                                              return Container(
                                                width: MediaQuery.of(context).size.width * .5,
                                                height: MediaQuery.of(context).size.height * .5,
                                                child: LinearProgressIndicator(),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ));
                                  },
                                );
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        FutureBuilder(
                          future: Hive.openBox('jugadores'),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                print(snapshot.error.toString());
                                return Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  height: MediaQuery.of(context).size.height * .5,
                                  child: Text(snapshot.error.toString()),
                                );
                              } else {
                                return mostrarListaGolesAFavor(partido);
                              }
                            } else {
                              return Container(
                                width: MediaQuery.of(context).size.width * .5,
                                height: MediaQuery.of(context).size.height * .5,
                                child: LinearProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
/*
                      //Goles en Contra
                      Container(
                        padding: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width * 0.05), 0, 0, MediaQuery.of(context).size.width * 0.05),
                        width: MediaQuery.of(context).size.width / 1.20,
                        color: Colors.grey.withOpacity(.15),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Jugadores"),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  tooltip: 'Editar jugadores',
                                  onPressed: () async {
                                    listaJugadores = await showDialog<List<dynamic>>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(content: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return FutureBuilder(
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
                                                    return listaSeleccionarJugadores(listaJugadores, setState);
                                                  }
                                                } else {
                                                  return Container(
                                                    width: MediaQuery.of(context).size.width / 1,
                                                    height: MediaQuery.of(context).size.height / 1,
                                                    child: LinearProgressIndicator(),
                                                  );
                                                }
                                              },
                                              /*future: Hive.openBox('jugadores'),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasError) {
                                                    print(snapshot.error
                                                        .toString());
                                                    return Text(snapshot.error
                                                        .toString());
                                                  } else {
                                                    return listaSeleccionarJugadores(
                                                        listaJugadores,
                                                        setState);
                                                  }
                                                } else {
                                                  return LinearProgressIndicator();
                                                }
                                              },*/
                                            );
                                          },
                                        ));
                                      },
                                    );
                                    setState(() {});
                                  },
                                ),
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
                                    return mostrarJugadoresSeleccionados(listaJugadores);
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
                      ),

                      //Tarjetas
                      Container(
                        padding: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width * 0.05), 0, 0, MediaQuery.of(context).size.width * 0.05),
                        width: MediaQuery.of(context).size.width / 1.20,
                        color: Colors.grey.withOpacity(.15),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Jugadores"),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  tooltip: 'Editar jugadores',
                                  onPressed: () async {
                                    listaJugadores = await showDialog<List<dynamic>>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(content: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return FutureBuilder(
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
                                                    return listaSeleccionarJugadores(listaJugadores, setState);
                                                  }
                                                } else {
                                                  return Container(
                                                    width: MediaQuery.of(context).size.width / 1,
                                                    height: MediaQuery.of(context).size.height / 1,
                                                    child: LinearProgressIndicator(),
                                                  );
                                                }
                                              },
                                              /*future: Hive.openBox('jugadores'),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasError) {
                                                    print(snapshot.error
                                                        .toString());
                                                    return Text(snapshot.error
                                                        .toString());
                                                  } else {
                                                    return listaSeleccionarJugadores(
                                                        listaJugadores,
                                                        setState);
                                                  }
                                                } else {
                                                  return LinearProgressIndicator();
                                                }
                                              },*/
                                            );
                                          },
                                        ));
                                      },
                                    );
                                    setState(() {});
                                  },
                                ),
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
                                    return mostrarJugadoresSeleccionados(listaJugadores);
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
                      ),

                      //Cambios
                      Container(
                        padding: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width * 0.05), 0, 0, MediaQuery.of(context).size.width * 0.05),
                        width: MediaQuery.of(context).size.width / 1.20,
                        color: Colors.grey.withOpacity(.15),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Jugadores"),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  tooltip: 'Editar jugadores',
                                  onPressed: () async {
                                    listaJugadores = await showDialog<List<dynamic>>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(content: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return FutureBuilder(
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
                                                    return listaSeleccionarJugadores(listaJugadores, setState);
                                                  }
                                                } else {
                                                  return Container(
                                                    width: MediaQuery.of(context).size.width / 1,
                                                    height: MediaQuery.of(context).size.height / 1,
                                                    child: LinearProgressIndicator(),
                                                  );
                                                }
                                              },
                                              /*future: Hive.openBox('jugadores'),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasError) {
                                                    print(snapshot.error
                                                        .toString());
                                                    return Text(snapshot.error
                                                        .toString());
                                                  } else {
                                                    return listaSeleccionarJugadores(
                                                        listaJugadores,
                                                        setState);
                                                  }
                                                } else {
                                                  return LinearProgressIndicator();
                                                }
                                              },*/
                                            );
                                          },
                                        ));
                                      },
                                    );
                                    setState(() {});
                                  },
                                ),
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
                                    return mostrarJugadoresSeleccionados(listaJugadores);
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
                      ),

                      //Lesiones
                      Container(
                        padding: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width * 0.05), 0, 0, MediaQuery.of(context).size.width * 0.05),
                        width: MediaQuery.of(context).size.width / 1.20,
                        color: Colors.grey.withOpacity(.15),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Jugadores"),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  tooltip: 'Editar jugadores',
                                  onPressed: () async {
                                    listaJugadores = await showDialog<List<dynamic>>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(content: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return FutureBuilder(
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
                                                    return listaSeleccionarJugadores(listaJugadores, setState);
                                                  }
                                                } else {
                                                  return Container(
                                                    width: MediaQuery.of(context).size.width / 1,
                                                    height: MediaQuery.of(context).size.height / 1,
                                                    child: LinearProgressIndicator(),
                                                  );
                                                }
                                              },
                                              /*future: Hive.openBox('jugadores'),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasError) {
                                                    print(snapshot.error
                                                        .toString());
                                                    return Text(snapshot.error
                                                        .toString());
                                                  } else {
                                                    return listaSeleccionarJugadores(
                                                        listaJugadores,
                                                        setState);
                                                  }
                                                } else {
                                                  return LinearProgressIndicator();
                                                }
                                              },*/
                                            );
                                          },
                                        ));
                                      },
                                    );
                                    setState(() {});
                                  },
                                ),
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
                                    return mostrarJugadoresSeleccionados(listaJugadores);
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
                      ),

                      //Observaciones
                      Container(
                        padding: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width * 0.05), 0, 0, MediaQuery.of(context).size.width * 0.05),
                        width: MediaQuery.of(context).size.width / 1.20,
                        color: Colors.grey.withOpacity(.15),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Jugadores"),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  tooltip: 'Editar jugadores',
                                  onPressed: () async {
                                    listaJugadores = await showDialog<List<dynamic>>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(content: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return FutureBuilder(
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
                                                    return listaSeleccionarJugadores(listaJugadores, setState);
                                                  }
                                                } else {
                                                  return Container(
                                                    width: MediaQuery.of(context).size.width / 1,
                                                    height: MediaQuery.of(context).size.height / 1,
                                                    child: LinearProgressIndicator(),
                                                  );
                                                }
                                              },
                                              /*future: Hive.openBox('jugadores'),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasError) {
                                                    print(snapshot.error
                                                        .toString());
                                                    return Text(snapshot.error
                                                        .toString());
                                                  } else {
                                                    return listaSeleccionarJugadores(
                                                        listaJugadores,
                                                        setState);
                                                  }
                                                } else {
                                                  return LinearProgressIndicator();
                                                }
                                              },*/
                                            );
                                          },
                                        ));
                                      },
                                    );
                                    setState(() {});
                                  },
                                ),
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
                                    return mostrarJugadoresSeleccionados(listaJugadores);
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
                      ),
*/
                ],
              )),
            );
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  /* Goles a Favor */
  //Mostrar lista [Resultado, Minuto, Jugador]
  mostrarListaGolesAFavor(Partido partidoActual) {
    Box boxJugadoresEquipo = Hive.box('jugadores');
    if (partidoActual.golesAFavor.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(partidoActual.golesAFavor.length, (iFila) {
          Jugador jugadorFila;
          for (var i = 0; i < boxJugadoresEquipo.length; i++) {
            if (partidoActual.golesAFavor[iFila][2] == boxJugadoresEquipo.getAt(i).id) {
              jugadorFila = boxJugadoresEquipo.getAt(i);
            }
          }
          return Row(
            children: <Widget>[
              Text("${partidoActual.golesAFavor[iFila][0]}"),
              Spacer(flex: 1,),
              Text("${partidoActual.golesAFavor[iFila][1]}'"),
              Spacer(flex: 1,),
              Text("${jugadorFila.nombre}"),
            ],
          );
        }),
      );
    } else {
      return Center(
        child: Text("No hay goles a favor."),
      );
    }
  }

  //Mostrar formulario de añadir un nuevo gol
  Widget listaSeleccionarJugadores(Partido partidoActual,StateSetter setState) {
    //Datos formulario
    final formKey = new GlobalKey<FormState>();
    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      print(_idJugadorSeleccionadoGolesAFavor);
      return Form(
        key: formKey,
        child: Container(
          width: MediaQuery.of(context).size.width / 1,
          height: MediaQuery.of(context).size.height / 1,
          child: Column(
            children: <Widget>[
              Text("Nuevo gol a favor"),
              //Minuto
              TextFormField(
                initialValue: _minutoSeleccionadoGolesAFavor,
                keyboardType: TextInputType.number,
                maxLength: 3,
                validator: (val) => (val.length == 0 || int.parse(val) < 0 || int.parse(val) > 140) ? 'Escribe el minuto del gol' : null,
                onChanged: (val) => _minutoSeleccionadoGolesAFavor = val,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                  labelText: 'Minuto*',
                  hintText: 'Minuto del gol',
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: List.generate(boxJugadores.length, (iJugador) {
                  Jugador jugadorBox = boxJugadores.getAt(iJugador);
                  return RadioListTile(
                    selected: _idJugadorSeleccionadoGolesAFavor == jugadorBox.id,
                    value: jugadorBox.id,
                    groupValue: _idJugadorSeleccionadoGolesAFavor,
                    title: Text(jugadorBox.apodo),
                    subtitle: Text(jugadorBox.apodo),
                    onChanged: (idjugadorSeleccionadoAhora) async {
                      setState(() => _idJugadorSeleccionadoGolesAFavor = idjugadorSeleccionadoAhora);
                      print("Current User ${idjugadorSeleccionadoAhora}");
                    },
                    activeColor: Colors.green,
                  );
                }),
              ),
              RaisedButton(
                child: Text("Aceptar"),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    print("${_minutoSeleccionadoGolesAFavor}': ${_idJugadorSeleccionadoGolesAFavor}");
                    formKey.currentState.save();
                    //Actualizar los goles a favor del partido
                    List golesAFavorActuales = partidoActual.golesAFavor;
                    golesAFavorActuales.add(["0-0", "$_minutoSeleccionadoGolesAFavor", "$_idJugadorSeleccionadoGolesAFavor"]);
                    Partido p = Partido(
                        fecha: partidoActual.fecha,
                        hora: partidoActual.hora,
                        lugar: partidoActual.lugar,
                        rival: partidoActual.rival,
                        tipoPartido: partidoActual.tipoPartido,
                        convocatoria: partidoActual.convocatoria,
                        alineacion: partidoActual.alineacion,
                        golesAFavor: golesAFavorActuales,
                        golesEnContra: partidoActual.golesEnContra,
                        lesiones: partidoActual.lesiones,
                        tarjetas: partidoActual.tarjetas,
                        cambios: partidoActual.cambios,
                        observaciones: partidoActual.observaciones);
                    Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                    boxPartidosEditarConvocatoria.putAt(widget.posicion, p);

                    //Limpiar campos
                    _idJugadorSeleccionadoGolesAFavor = "";
                    _minutoSeleccionadoGolesAFavor = "";
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
        child: Text("Ningún jugador creado."),
      );
    }
  }
}
