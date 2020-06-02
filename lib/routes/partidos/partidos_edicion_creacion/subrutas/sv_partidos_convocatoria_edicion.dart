import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
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
                              await showDialog<List<dynamic>>(
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
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 1,
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height / 1,
                                                child: Text(snapshot.error.toString()),
                                              );
                                            } else {
                                              return listaSeleccionarJugadores(partido, setState);
                                            }
                                          } else {
                                            return LinearProgressIndicator();
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
                      Container(
                        child: FutureBuilder(
                          future: Hive.openBox('jugadores'),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                print(snapshot.error.toString());
                                return Text(snapshot.error.toString());
                              } else {
                                return mostrarJugadoresSeleccionados(partido.convocatoria);
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
  Widget mostrarJugadoresSeleccionados(List<String> jugadoresConvocados) {
    Box boxJugadoresEquipo = Hive.box('jugadores');
    if (jugadoresConvocados != null) {
      if (jugadoresConvocados.length > 0) {
        Widget widgetJugador = Container(height: 0);

        return ListView(
          shrinkWrap: true,
          children: List.generate(jugadoresConvocados.length, (idJugador) {
            //Buscar lista de jugadores con ese id
            Jugador jugadorBox;
            /*boxJugadoresEquipo.values.where((j) {
              print(j.apodo);
              if (j != null) {
                if (j.id == '${jugadoresConvocados[idJugador]}') {
                  jugadorBox = j;
                }
              }
            });*/
            for (var i = 0; i < boxJugadoresEquipo.length; i++) {
              if ('${jugadoresConvocados[idJugador]}' == boxJugadoresEquipo
                  .getAt(i)
                  .id) {
                jugadorBox = boxJugadoresEquipo.getAt(i);
                widgetJugador = Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ConversorImagen.imageFromBase64String("${jugadorBox.nombre_foto}", context),
                    Text("${jugadorBox.apodo}"),
                    Text("${jugadorBox.posicionFavorita}"),
                  ],
                );
              }
            }
            return widgetJugador;
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

//Mostrar lista seleccionable de jugadores
  Widget listaSeleccionarJugadores(Partido partidoActual, StateSetter setState) {
    //Almacenar el partido en la Box de 'partidos'
    Box boxPartidosEditarConvocatoria;
    List<String> postListaJugadoresConvocatoria = [];
    if (partidoActual.convocatoria != null) {
      postListaJugadoresConvocatoria = partidoActual.convocatoria;
      /*for (Jugador jugadorItemLista in partidoActual.convocatoria) {
        postListaJugadoresConvocatoria.add(jugadorItemLista);
      }*/
    }
    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 1,
        height: MediaQuery
            .of(context)
            .size
            .height / 1,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Modificar convocatoria"),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            ListView(
              shrinkWrap: true,
              children: List.generate(boxJugadores.length, (iJugador) {
                Jugador jugadorBox = boxJugadores.getAt(iJugador);
                //bool _isSeleccionado = (postListaJugadoresConvocatoria.contains(jugadorBox)) ? true : false;
                bool _isSeleccionado = false;
                for (String idJugadorItemLista in postListaJugadoresConvocatoria) {
                  if (idJugadorItemLista == jugadorBox.id) {
                    _isSeleccionado = true;
                  }
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ConversorImagen.imageFromBase64String(jugadorBox.nombre_foto, context),
                        Text("${jugadorBox.apodo}"), //, style: TextStyle(fontSize: MediaQuery.of(context).size.width * .04)),
                        //Text("${jugadorBox.posicionFavorita}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * .05),),
                      ],
                    ),
                    Checkbox(
                      value: _isSeleccionado,
                      onChanged: (bool nuevoEstado) async {
                        setState(() {
                          _isSeleccionado = nuevoEstado;
                        });
                        Map postAlineacion = partidoActual.alineacion;
                        if (_isSeleccionado) {
                          postListaJugadoresConvocatoria.add(jugadorBox.id);
                          print("Añadido");
                        } else {
                          //postListaJugadoresConvocatoria.removeWhere((j) => j == jugadorBox);
                          for (int i = 0; i < postListaJugadoresConvocatoria.length; i++) {
                            if (postListaJugadoresConvocatoria[i] == jugadorBox.id) {
                              postListaJugadoresConvocatoria.removeAt(i);
                              //Eliminar Jugador de la alineación
                              /*
                              Recorrer mapa de alineación y eliminar id coincidente
                               */
                              //partidoActual.alineacion['0'][1] //Recorrer este array
                              postAlineacion.forEach((min, alin) {
                                print("Minuto $min");
                                print("Alineacion: $alin");
                                Map postAlinPartidoActual = alin[1];
                                alin[1].forEach((posicion, jugadorIDAlineacion) {
                                  if (jugadorIDAlineacion == jugadorBox.id) {
                                    //jugadorIDAlineacion = null;
                                    postAlinPartidoActual['$posicion'] = null;
                                  }
                                });
                                print("Alineacion post: $postAlinPartidoActual");
                                alin[1] = postAlinPartidoActual;
                                print("Alineacion post: $alin");
                              });
                            }
                          }
                          print("Eliminado");
                        }
                        Partido p = Partido(
                            fecha: partidoActual.fecha,
                            hora: partidoActual.hora,
                            lugar: partidoActual.lugar,
                            rival: partidoActual.rival,
                            tipoPartido: partidoActual.tipoPartido,
                            convocatoria: postListaJugadoresConvocatoria,
                            alineacion: postAlineacion,
                            golesAFavor: partidoActual.golesAFavor,
                            golesEnContra: partidoActual.golesEnContra,
                            lesiones: partidoActual.lesiones,
                            tarjetas: partidoActual.tarjetas,
                            cambios: partidoActual.cambios,
                            observaciones: partidoActual.observaciones,
                            isLocal: partidoActual.isLocal);
                        boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                        boxPartidosEditarConvocatoria.putAt(widget.posicion, p);
                        setState(() {});
                        print(postListaJugadoresConvocatoria.length);
                      },
                    ),
                  ],
                );
              }),
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  child: Text("Aceptar"),
                  onPressed: () async {
                    Partido p = Partido(
                        fecha: partidoActual.fecha,
                        hora: partidoActual.hora,
                        lugar: partidoActual.lugar,
                        rival: partidoActual.rival,
                        tipoPartido: partidoActual.tipoPartido,
                        convocatoria: postListaJugadoresConvocatoria,
                        alineacion: partidoActual.alineacion,
                        golesAFavor: partidoActual.golesAFavor,
                        golesEnContra: partidoActual.golesEnContra,
                        lesiones: partidoActual.lesiones,
                        tarjetas: partidoActual.tarjetas,
                        cambios: partidoActual.cambios,
                        observaciones: partidoActual.observaciones);
                    boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                    boxPartidosEditarConvocatoria.putAt(widget.posicion, p);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),*/
          ],
        ),
      );
    } else {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 1,
        height: MediaQuery
            .of(context)
            .size
            .height / 1,
        child: Text("Ningún jugador creado."),
      );
    }
  }
}
