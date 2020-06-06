import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/partidos/partidos_edicion_creacion/subrutas/detalles_partido_alineacion/w_partidos_alineacion_formaciones_edicion.dart';
import 'package:mister_football/routes/partidos/partidos_edicion_creacion/v_partidos_edicion.dart';

class PartidoEquipoEdicion extends StatefulWidget {
  final Partido partido;

  PartidoEquipoEdicion({Key key, @required this.partido}) : super(key: key);

  @override
  createState() => _PartidoEquipoEdicion();
}

class _PartidoEquipoEdicion extends State<PartidoEquipoEdicion> {
  String _formacionActual;
  List<DropdownMenuItem<String>> _formacionesDisponibles;
  List _formaciones = ["14231", "1442", "1433", "1451", "1532", "1523", "13232", "1352", "1334"];

  @override
  void initState() {
    _formacionesDisponibles = getDropDownMenuItems();
    /*Antiguo
      _formacionActual = _formacionesDisponibles[0].value;
    */
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String f in _formaciones) {
      items.add(new DropdownMenuItem(value: f, child: new Text(f)));
    }
    return items;
  }

  void cambiarFormacion(String formacionElegida) async {
    _formacionActual = formacionElegida;
  }

  void actualizarFormacionPartido(String formacionElegida) async {
    cambiarFormacion(formacionElegida);
    //Añadir lista de los jugadores convocados al partido.
    Partido partidoActual = PartidosEdicion.partidoEditado;
    Map<String, List> alineacionActualizada = {};
    if (partidoActual.alineacion != null) {
      alineacionActualizada = partidoActual.alineacion;
    }
    alineacionActualizada['0'][0] = formacionElegida;
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
    PartidosEdicion.partidoEditado = p;
  }

  Widget build(BuildContext context) {
    //Seleccionar formación inicial
    String formacionInicialPartido = "14231";
    if (widget.partido.alineacion != null) {
      if (widget.partido.alineacion['0'][0] != null) {
        formacionInicialPartido = widget.partido.alineacion['0'][0];
      }
    }
    int _posicionFormacionInicial = _formaciones.indexOf(formacionInicialPartido);
    _formacionActual = _formacionesDisponibles[_posicionFormacionInicial].value;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * .03,
        ),
        child: Column(
          children: <Widget>[
            DropdownButton(
              value: _formacionActual,
              items: _formacionesDisponibles,
              onChanged: (val) async {
                actualizarFormacionPartido(val);
                cambiarFormacion(val);
                setState(() {});
              },
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * .03,
                top: MediaQuery.of(context).size.width * .03,
              ),
              child: PartidoAlineacionFormacionEdicion(formacion: formacionInicialPartido, partido: widget.partido),
            ),
            Container(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * .03,
              ),
              decoration: BoxDecoration(
                color: MisterFootball.primarioLight2.withOpacity(.05),
                border: Border(
                  top: BorderSide(width: .4),
                  bottom: BorderSide(width: .4),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Jugadores convocados",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.lightBlueAccent,
                        ),
                        tooltip: 'Editar jugadores',
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(content: StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return listaSeleccionarJugadores(widget.partido, setState);
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
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * .03,
                    ),
                    child: mostrarJugadoresSeleccionados(widget.partido.convocatoria),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Column(
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
                    return AlertDialog(
                      content: listaSeleccionarJugadores(widget.partido, setState),
                    );
                  },
                );
                setState(() {});
              },
            ),
          ],
        ),
        Container(
          child: mostrarJugadoresSeleccionados(widget.partido.convocatoria),
        ),
      ],
    );
  }
*/
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
              if ('${jugadoresConvocados[idJugador]}' == boxJugadoresEquipo.getAt(i).id) {
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
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
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
                /*return Row(
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
                        PartidosEdicion.partidoEditado = p;
                        setState(() {});
                      },
                    ),
                  ],
                );
                */
                return CheckboxListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ConversorImagen.imageFromBase64String(jugadorBox.nombre_foto, context),
                      Text("${jugadorBox.apodo}"), //, style: TextStyle(fontSize: MediaQuery.of(context).size.width * .04)),
                      //Text("${jugadorBox.posicionFavorita}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * .05),),
                    ],
                  ),
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
                    PartidosEdicion.partidoEditado = p;
                    setState(() {});
                  },
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
