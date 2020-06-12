import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/partidos/partidos_edicion_creacion/subrutas/edicion_partido_alineacion/w_partidos_alineacion_formaciones_edicion.dart';
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

  //Alert
  String formacionAlert;
  int _minutoCambioAlineacionAlert;

  String _minutoActual;
  List<DropdownMenuItem<String>> _minutosDisponibles;

  @override
  void initState() {
    _formacionesDisponibles = getDropDownMenuItemsFormaciones();
    _minutoActual = "0";
    formacionAlert = "14231";
    //_minutoCambioAlineacionAlert = 1;
    /*Antiguo
      _formacionActual = _formacionesDisponibles[0].value;
    */
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsFormaciones() {
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
    print(_minutoActual);
    print(alineacionActualizada['$_minutoActual']);
    alineacionActualizada['$_minutoActual'][0] = formacionElegida;
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

  void cambiarMinutoFormacion(String minutoElegido) async {
    _minutoActual = minutoElegido;
  }

  void actualizarMinutoFormacionPartido(String minutoElegido) async {
    cambiarMinutoFormacion(minutoElegido);

    print('$_minutoActual');
    print(PartidosEdicion.partidoEditado.alineacion['$_minutoActual']);

    cambiarFormacion(PartidosEdicion.partidoEditado.alineacion['$minutoElegido'][0]);
    setState(() {});
    //Añadir lista de los jugadores convocados al partido.
  }

  @override
  Widget build(BuildContext context) {
    //Seleccionar formación inicial
    String formacionInicialPartido = "14231";
    print('$_minutoActual');
    if (widget.partido.alineacion != null) {
      if ('$_minutoActual'.length < 1) {
        if (widget.partido.alineacion['0'][0] != null) {
          formacionInicialPartido = widget.partido.alineacion['0'][0];
        }
      } else {
        if (widget.partido.alineacion['$_minutoActual'][0] != null) {
          formacionInicialPartido = widget.partido.alineacion['$_minutoActual'][0];
        }
      }
    }
    int _posicionFormacionInicial = _formaciones.indexOf(formacionInicialPartido);
    _formacionActual = _formacionesDisponibles[_posicionFormacionInicial].value;

    //Añadir minutos con alineaciones guardadas
    if (widget.partido.alineacion != null) {
      List<DropdownMenuItem<String>> items = new List();
      for (String f in widget.partido.alineacion.keys) {
        items.add(new DropdownMenuItem(value: f, child: new Text(f)));
      }
      _minutosDisponibles = items;
    }
    //int _posicionFormacionInicial = _formaciones.indexOf(formacionInicialPartido);
    //_formacionActual = _formacionesDisponibles[_posicionFormacionInicial].value;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * .03,
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Minuto:"),
                    DropdownButton(
                      value: _minutoActual,
                      items: _minutosDisponibles,
                      onChanged: (val) async {
                        actualizarMinutoFormacionPartido(val);
                        //cambiarMinutoFormacion(val);
                        setState(() {});
                      },
                    ),
                  ],
                ),
                RaisedButton(
                  child: Text(
                    "Añadir cambio\nde alineación",
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return anhadirCambioDeAlineacion(setState);
                            },
                          ),
                        );
                      },
                    );
                    setState(() {});
                  },
                ),
              ],
            ),
            (_minutoActual != "0")
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.transparent,
                        ),
                        onPressed: () {},
                      ),
                      DropdownButton(
                        value: _formacionActual,
                        items: _formacionesDisponibles,
                        onChanged: (val) async {
                          actualizarFormacionPartido(val);
                          //cambiarFormacion(val);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: MisterFootball.complementarioDelComplementarioLight,
                        ),
                        tooltip: "Eliminar cambio de alineación",
                        onPressed: () {
                          //print("Implementar eliminar");
                          PartidosEdicion.partidoEditado.alineacion.remove('$_minutoActual');
                          _minutoActual = '0';
                          setState(() {});
                        },
                      ),
                    ],
                  )
                : DropdownButton(
                    value: _formacionActual,
                    items: _formacionesDisponibles,
                    onChanged: (val) async {
                      actualizarFormacionPartido(val);
                      //cambiarFormacion(val);
                      setState(() {});
                    },
                  ),
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * .03,
                top: MediaQuery.of(context).size.width * .03,
              ),
              child: PartidoAlineacionFormacionEdicion(
                formacion: formacionInicialPartido,
                partido: PartidosEdicion.partidoEditado,
                minuto: _minutoActual,
              ),
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
                          color: MisterFootball.primario,
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

  /* Cambio de alineación */
  //Añadir un cambio de alineación
  Widget anhadirCambioDeAlineacion(StateSetter setState) {
    //Datos formulario
    Map alineacionActualizada = PartidosEdicion.partidoEditado.alineacion;
    final formKey = new GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Container(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
        child: Column(
          children: <Widget>[
            Text("Añadir cambio de alineacion"),
            //Minuto
            TextFormField(
              initialValue: (_minutoCambioAlineacionAlert == -1) ? "" : "$_minutoCambioAlineacionAlert",
              keyboardType: TextInputType.number,
              validator: (val) => (val.length == 0 || int.parse(val) < 0 || int.parse(val) > 140)
                  ? 'Escribe el minuto'
                  : (alineacionActualizada.containsKey('$_minutoCambioAlineacionAlert')) ? 'Minuto ya guardado' : null,
              onChanged: (val) => _minutoCambioAlineacionAlert = int.parse(val),
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(),
                ),
                labelText: 'Minuto',
                hintText: 'Minuto',
              ),
            ),
            //Formación
            DropdownButton(
              elevation: 2,
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: MediaQuery.of(context).size.width * .07,
              ),
              value: formacionAlert,
              items: _formacionesDisponibles,
              onChanged: (_formacionAlert) {
                setState(() {
                  formacionAlert = _formacionAlert;
                });
              },
            ),
            RaisedButton(
              child: Text("Aceptar"),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  alineacionActualizada['$_minutoCambioAlineacionAlert'] = [
                    formacionAlert,
                    //alineacionActualizada['0'][1],
                    {'0': null, '1': null, '2': null, '3': null, '4': null, '5': null, '6': null, '7': null, '8': null, '9': null, '10': null}
                  ];
                  Partido p = Partido(
                      fecha: PartidosEdicion.partidoEditado.fecha,
                      hora: PartidosEdicion.partidoEditado.hora,
                      lugar: PartidosEdicion.partidoEditado.lugar,
                      rival: PartidosEdicion.partidoEditado.rival,
                      tipoPartido: PartidosEdicion.partidoEditado.tipoPartido,
                      convocatoria: PartidosEdicion.partidoEditado.convocatoria,
                      alineacion: alineacionActualizada,
                      golesAFavor: PartidosEdicion.partidoEditado.golesAFavor,
                      golesEnContra: PartidosEdicion.partidoEditado.golesEnContra,
                      lesiones: PartidosEdicion.partidoEditado.lesiones,
                      tarjetas: PartidosEdicion.partidoEditado.tarjetas,
                      cambios: PartidosEdicion.partidoEditado.cambios,
                      observaciones: PartidosEdicion.partidoEditado.observaciones,
                      isLocal: PartidosEdicion.partidoEditado.isLocal);
                  PartidosEdicion.partidoEditado = p;
                  //Volver a poner el valor predefinido
                  formacionAlert = "14231";
                  _minutoCambioAlineacionAlert = -1;
                  //_minutoCambioAlineacionAlert = 1;
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  /* Jugadores */
  //Mostrar lista de los jugadores seleccionados en la convocatoria
  Widget mostrarJugadoresSeleccionados(List<String> jugadoresConvocados) {
    bool isJugadoresConvocados = false;
    Box boxJugadoresEquipo = Hive.box('jugadores');
    if (jugadoresConvocados != null) {
      if (jugadoresConvocados.length > 0) {
        Widget widgetJugador = Container(height: 0);
        return Column(
          children: <Widget>[
            ListView(
              //Eliminar Scroll
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(jugadoresConvocados.length, (idJugador) {
                Jugador jugadorBox;
                for (var i = 0; i < boxJugadoresEquipo.length; i++) {
                  if ('${jugadoresConvocados[idJugador]}' == boxJugadoresEquipo.getAt(i).id) {
                    jugadorBox = boxJugadoresEquipo.getAt(i);
                    widgetJugador = Container(
                      margin: EdgeInsets.only(
                        bottom: (idJugador != (jugadoresConvocados.length - 1)) ? MediaQuery.of(context).size.width * .03 : 0,
                        //op: MediaQuery.of(context).size.width * .03,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: (idJugador == 0) ? .4 : 0),
                          bottom: BorderSide(width: .4),
                          left: BorderSide(width: .4),
                          right: BorderSide(width: .4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ConversorImagen.imageFromBase64String("${jugadorBox.nombre_foto}", context),
                          Text("${jugadorBox.apodo}"),
                          Text("${jugadorBox.posicionFavorita}"),
                        ],
                      ),
                    );
                    isJugadoresConvocados = true;
                  }
                }
                return widgetJugador;
              }),
            ),
            if (!isJugadoresConvocados)
              Center(
                child: Text("No hay ningún jugador añadido."),
              )
          ],
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
                return CheckboxListTile(
                  title: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        ConversorImagen.imageFromBase64String(jugadorBox.nombre_foto, context),
                        Text("${jugadorBox.apodo}"),
                      ]),
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
