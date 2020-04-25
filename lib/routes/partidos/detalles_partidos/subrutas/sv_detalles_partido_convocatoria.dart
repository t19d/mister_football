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
                                                width: MediaQuery.of(context).size.width / 1,
                                                height: MediaQuery.of(context).size.height / 1,
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

//Mostrar lista seleccionable de jugadores
  listaSeleccionarJugadores(Partido partidoActual, StateSetter setState) {
    //Almacenar el partido en la Box de 'partidos'
    Box boxPartidosEditarConvocatoria = null;
    List<Jugador> postListaJugadoresConvocatoria = [];
    if (partidoActual.convocatoria != null) {
      postListaJugadoresConvocatoria = partidoActual.convocatoria;
      /*for (Jugador jugadorItemLista in partidoActual.convocatoria) {
        postListaJugadoresConvocatoria.add(jugadorItemLista);
      }*/
    }

    print(postListaJugadoresConvocatoria);
    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      return Container(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Modificar convocatoria"),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red,),
                  onPressed: (){
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
                for (Jugador jugadorItemLista in postListaJugadoresConvocatoria) {
                  if (jugadorItemLista.nombre == jugadorBox.nombre &&
                      jugadorItemLista.apellido1 == jugadorBox.apellido1 &&
                      jugadorItemLista.apellido2 == jugadorBox.apellido2 &&
                      jugadorItemLista.apodo == jugadorBox.apodo &&
                      jugadorItemLista.fechaNacimiento == jugadorBox.fechaNacimiento &&
                      jugadorItemLista.piernaBuena == jugadorBox.piernaBuena &&
                      jugadorItemLista.posicionFavorita == jugadorBox.posicionFavorita &&
                      jugadorItemLista.anotaciones == jugadorBox.anotaciones &&
                      jugadorItemLista.nombre_foto == jugadorBox.nombre_foto) {
                    _isSeleccionado = true;
                  }
                }
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("-${jugadorBox.nombre}"),
                    ),
                    Checkbox(
                      value: _isSeleccionado,
                      onChanged: (bool nuevoEstado) async {
                        setState(() {
                          _isSeleccionado = nuevoEstado;
                        });
                        if (_isSeleccionado) {
                          postListaJugadoresConvocatoria.add(jugadorBox);
                          print("Añadido");
                        } else {
                          //postListaJugadoresConvocatoria.removeWhere((j) => j == jugadorBox);
                          for (int i = 0; i < postListaJugadoresConvocatoria.length; i++) {
                            if (postListaJugadoresConvocatoria[i].nombre == jugadorBox.nombre &&
                                postListaJugadoresConvocatoria[i].apellido1 == jugadorBox.apellido1 &&
                                postListaJugadoresConvocatoria[i].apellido2 == jugadorBox.apellido2 &&
                                postListaJugadoresConvocatoria[i].apodo == jugadorBox.apodo &&
                                postListaJugadoresConvocatoria[i].fechaNacimiento == jugadorBox.fechaNacimiento &&
                                postListaJugadoresConvocatoria[i].piernaBuena == jugadorBox.piernaBuena &&
                                postListaJugadoresConvocatoria[i].posicionFavorita == jugadorBox.posicionFavorita &&
                                postListaJugadoresConvocatoria[i].anotaciones == jugadorBox.anotaciones &&
                                postListaJugadoresConvocatoria[i].nombre_foto == jugadorBox.nombre_foto) {
                              postListaJugadoresConvocatoria.removeAt(i);
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
                            alineacion: partidoActual.alineacion,
                            golesAFavor: partidoActual.golesAFavor,
                            golesEnContra: partidoActual.golesEnContra,
                            lesiones: partidoActual.lesiones,
                            tarjetas: partidoActual.tarjetas,
                            cambios: partidoActual.cambios,
                            observaciones: partidoActual.observaciones);
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
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
        child: Text("Ningún jugador creado."),
      );
    }
  }
}
