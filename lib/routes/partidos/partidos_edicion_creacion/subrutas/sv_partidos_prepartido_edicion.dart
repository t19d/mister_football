import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';

class PartidoDatosEdicion extends StatefulWidget {
  final Partido partido;

  PartidoDatosEdicion({Key key, @required this.partido}) : super(key: key);

  @override
  createState() => _PartidoDatosEdicion();
}

class _PartidoDatosEdicion extends State<PartidoDatosEdicion> {
  @override
  Widget build(BuildContext context) {
    //Estilo de los titulos de los eventos
    TextStyle tituloEventos = TextStyle(
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Prepartido
          Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Título prepartido
                Container(
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * .03),
                  child: Text(
                    "Datos prepartido",
                    textAlign: TextAlign.right,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
                //Rival
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .2,
                      child: Text(
                        "Rival",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: .4),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * .6,
                      child: Text(
                        "${widget.partido.rival}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .1,
                      child: IconButton(
                        icon: Icon(
                          Icons.mode_edit,
                          color: MisterFootball.primario,
                        ),
                        onPressed: () {
                          print("Editar");
                        },
                      ),
                    ),
                  ],
                ),
                //Fecha
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .2,
                      child: Text(
                        "Fecha",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: .4),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * .6,
                      child: Text(
                        "${widget.partido.fecha}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .1,
                      child: IconButton(
                        icon: Icon(
                          Icons.mode_edit,
                          color: MisterFootball.primario,
                        ),
                        onPressed: () {
                          print("Editar");
                        },
                      ),
                    ),
                  ],
                ),
                //Hora
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .2,
                      child: Text(
                        "Hora",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: .4),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * .6,
                      child: Text(
                        "${widget.partido.hora}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .1,
                      child: IconButton(
                        icon: Icon(
                          Icons.mode_edit,
                          color: MisterFootball.primario,
                        ),
                        onPressed: () {
                          print("Editar");
                        },
                      ),
                    ),
                  ],
                ),
                //Lugar
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .2,
                      child: Text(
                        "Lugar",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: .4),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * .6,
                      child: Text(
                        (widget.partido.lugar.length == 0) ? "-" : "${widget.partido.lugar}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .1,
                      child: IconButton(
                        icon: Icon(
                          Icons.mode_edit,
                          color: MisterFootball.primario,
                        ),
                        onPressed: () {
                          print("Editar");
                        },
                      ),
                    ),
                  ],
                ),
                //isLocal
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .2,
                      child: Text(
                        "Local/Visitante",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: .4),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * .6,
                      child: Text(
                        (widget.partido.isLocal) ? "Local" : "Visitante",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .1,
                      child: IconButton(
                        icon: Icon(
                          Icons.mode_edit,
                          color: MisterFootball.primario,
                        ),
                        onPressed: () {
                          print("Editar");
                        },
                      ),
                    ),
                  ],
                ),
                //Tipo de partido
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .2,
                      child: Text(
                        "Tipo de partido",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: .4),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * .6,
                      child: Text(
                        "${widget.partido.tipoPartido}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .1,
                      child: IconButton(
                        icon: Icon(
                          Icons.mode_edit,
                          color: MisterFootball.primario,
                        ),
                        onPressed: () {
                          print("Editar");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //Título postpartido
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .03,
              top: MediaQuery.of(context).size.width * .05,
            ),
            child: Text(
              "Datos postpartido",
              textAlign: TextAlign.right,
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
          //Goles a favor
          Container(
            decoration: BoxDecoration(
              color: MisterFootball.primarioLight2.withOpacity(.05),
              border: Border(
                top: BorderSide(width: .4),
                bottom: BorderSide(width: .4),
              ),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width * .03,
              top: MediaQuery.of(context).size.width * .03,
            ),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .03,
              right: MediaQuery.of(context).size.width * .03,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Goles a favor",
                      style: tituloEventos,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: MisterFootball.primario,
                      ),
                      tooltip: 'Añadir gol a favor',
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: anhadirGolAFavor(widget.partido, setState),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                mostrarListaGolesAFavor(widget.partido),
              ],
            ),
          ),
          //Goles en Contra
          Container(
            decoration: BoxDecoration(
              color: MisterFootball.primarioLight2.withOpacity(.05),
              border: Border(
                top: BorderSide(width: .4),
                bottom: BorderSide(width: .4),
              ),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width * .03,
              top: MediaQuery.of(context).size.width * .03,
            ),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .03,
              right: MediaQuery.of(context).size.width * .03,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Goles en contra",
                      style: tituloEventos,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: MisterFootball.primario,
                      ),
                      tooltip: 'Añadir gol en contra',
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: anhadirGolEnContra(widget.partido),
                            );
                          },
                        );
                        setState(() {});
                      },
                    ),
                  ],
                ),
                mostrarListaGolesEnContra(widget.partido),
              ],
            ),
          ),
          //Tarjetas
          Container(
            decoration: BoxDecoration(
              color: MisterFootball.primarioLight2.withOpacity(.05),
              border: Border(
                top: BorderSide(width: .4),
                bottom: BorderSide(width: .4),
              ),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width * .03,
              top: MediaQuery.of(context).size.width * .03,
            ),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .03,
              right: MediaQuery.of(context).size.width * .03,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Tarjetas",
                      style: tituloEventos,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: MisterFootball.primario,
                      ),
                      tooltip: 'Añadir tarjeta',
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: anhadirTarjetas(widget.partido, setState),
                            );
                          },
                        );
                        setState(() {});
                      },
                    ),
                  ],
                ),
                mostrarListaTarjetas(widget.partido),
              ],
            ),
          ),
          //Cambios
          Container(
            decoration: BoxDecoration(
              color: MisterFootball.primarioLight2.withOpacity(.05),
              border: Border(
                top: BorderSide(width: .4),
                bottom: BorderSide(width: .4),
              ),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width * .03,
              top: MediaQuery.of(context).size.width * .03,
            ),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .03,
              right: MediaQuery.of(context).size.width * .03,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Cambios",
                      style: tituloEventos,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: MisterFootball.primario,
                      ),
                      tooltip: 'Añadir cambio',
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: anhadirCambios(widget.partido, setState),
                            );
                          },
                        );
                        setState(() {});
                      },
                    ),
                  ],
                ),
                mostrarListaCambios(widget.partido),
              ],
            ),
          ),
          //Lesiones
          Container(
            decoration: BoxDecoration(
              color: MisterFootball.primarioLight2.withOpacity(.05),
              border: Border(
                top: BorderSide(width: .4),
                bottom: BorderSide(width: .4),
              ),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width * .03,
              top: MediaQuery.of(context).size.width * .03,
            ),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .03,
              right: MediaQuery.of(context).size.width * .03,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Lesiones",
                      style: tituloEventos,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: MisterFootball.primario,
                      ),
                      tooltip: 'Añadir lesiones',
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: anhadirLesion(widget.partido, setState),
                            );
                          },
                        );
                        setState(() {});
                      },
                    ),
                  ],
                ),
                mostrarListaLesion(widget.partido),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* Goles a Favor */
  //Mostrar lista [Minuto, Jugador]
  Widget mostrarListaGolesAFavor(Partido partidoActual) {
    Box boxJugadoresEquipo = Hive.box('jugadores');
    if (partidoActual.golesAFavor.length > 0) {
      return ListView(
        //Eliminar Scroll
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(partidoActual.golesAFavor.length, (iFila) {
          Jugador jugadorFila;
          Color avisoJugador = Colors.redAccent.withOpacity(.5);
          for (var i = 0; i < boxJugadoresEquipo.length; i++) {
            if (partidoActual.golesAFavor[iFila][1] == boxJugadoresEquipo.getAt(i).id) {
              jugadorFila = boxJugadoresEquipo.getAt(i);
              for (var j = 0; j < partidoActual.convocatoria.length; j++) {
                if (partidoActual.convocatoria[j] == boxJugadoresEquipo.getAt(i).id) {
                  avisoJugador = Colors.transparent;
                }
              }
            }
          }
          return Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * .03,
              bottom: MediaQuery.of(context).size.width * .03,
            ),
            decoration: BoxDecoration(
              color: avisoJugador,
              border: Border(
                bottom: BorderSide(
                  color: ((partidoActual.golesAFavor.length - 1) != iFila) ? MisterFootball.primario : Colors.transparent,
                  width: .4,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("${partidoActual.golesAFavor[iFila][0]}'"),
                if (avisoJugador == Colors.redAccent.withOpacity(.5))
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                (jugadorFila != null) ? Text("${jugadorFila.apodo}") : Text("Jugador eliminado"),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    tooltip: 'Eliminar gol',
                    onPressed: () async {
                      //Actualizar los goles a favor del partido
                      List golesAFavorActuales = partidoActual.golesAFavor;
                      //for (int i = 0; i < golesAFavorActuales.length; i++) {
                      //if (golesAFavorActuales[i][1] == jugadorFila.id) {
                      golesAFavorActuales.removeAt(iFila);
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
                          observaciones: partidoActual.observaciones,
                          isLocal: partidoActual.isLocal);
                      Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                      //boxPartidosEditarConvocatoria.putAt(widget.posicion, p);
                      setState(() {});
                    }),
              ],
            ),
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
  Widget anhadirGolAFavor(Partido partidoActual, StateSetter setState) {
    //Datos formulario
    final formKey = new GlobalKey<FormState>();
    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      //print(_idJugadorSeleccionadoGolesAFavor);
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
                //initialValue: _minutoSeleccionadoGolesAFavor,
                keyboardType: TextInputType.number,
                maxLength: 3,
                validator: (val) => (val.length == 0 || int.parse(val) < 0 || int.parse(val) > 140) ? 'Escribe el minuto del gol' : null,
                //onChanged: (val) => _minutoSeleccionadoGolesAFavor = val,
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
                  Widget itemLista = Container(
                    width: 0,
                    height: 0,
                  );
                  Jugador jugadorBox;
                  for (var i = 0; i < partidoActual.convocatoria.length; i++) {
                    if (partidoActual.convocatoria[i] == boxJugadores.getAt(iJugador).id) {
                      jugadorBox = boxJugadores.getAt(iJugador);
                      itemLista = RadioListTile(
                        //selected: _idJugadorSeleccionadoGolesAFavor == jugadorBox.id,
                        value: jugadorBox.id,
                        //groupValue: _idJugadorSeleccionadoGolesAFavor,
                        title: Text(jugadorBox.apodo),
                        subtitle: Text(jugadorBox.apodo),
                        onChanged: (idjugadorSeleccionadoAhora) async {
                          //setState(() => _idJugadorSeleccionadoGolesAFavor = idjugadorSeleccionadoAhora);
                          print("Current User ${idjugadorSeleccionadoAhora}");
                        },
                        activeColor: Colors.green,
                      );
                    }
                  }
                  return itemLista;
                }),
              ),
              RaisedButton(
                child: Text("Aceptar"),

                /*onPressed: (_idJugadorSeleccionadoGolesAFavor == "")
                    ? null
                    : () async {
                  if (formKey.currentState.validate()) {
                    print("${_minutoSeleccionadoGolesAFavor}': ${_idJugadorSeleccionadoGolesAFavor}");
                    formKey.currentState.save();
                    //Actualizar los goles a favor del partido
                    List golesAFavorActuales = partidoActual.golesAFavor;
                    golesAFavorActuales.add(["$_minutoSeleccionadoGolesAFavor", "$_idJugadorSeleccionadoGolesAFavor"]);
                    golesAFavorActuales.sort((a, b) => int.parse(a[0]).compareTo(int.parse(b[0])));
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
                        observaciones: partidoActual.observaciones,
                        isLocal: partidoActual.isLocal);
                    Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                    boxPartidosEditarConvocatoria.putAt(widget.posicion, p);

                    //Limpiar campos
                    _idJugadorSeleccionadoGolesAFavor = "";
                    _minutoSeleccionadoGolesAFavor = "";
                    Navigator.pop(context);
                  }
                },*/
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

  /* Goles en Contra */
  //Mostrar lista [Minuto]
  Widget mostrarListaGolesEnContra(Partido partidoActual) {
    if (partidoActual.golesEnContra.length > 0) {
      return ListView(
        //Eliminar Scroll
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(partidoActual.golesEnContra.length, (iFila) {
          return Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * .03,
              bottom: MediaQuery.of(context).size.width * .03,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ((partidoActual.golesEnContra.length - 1) != iFila) ? MisterFootball.primario : Colors.transparent,
                  width: .4,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "${partidoActual.golesEnContra[iFila]}'",
                  textAlign: TextAlign.center,
                ),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    tooltip: 'Eliminar gol',
                    onPressed: () async {
                      //Actualizar los goles en contra del partido
                      List golesEnContraActuales = partidoActual.golesEnContra;
                      golesEnContraActuales.removeAt(iFila);
                      Partido p = Partido(
                          fecha: partidoActual.fecha,
                          hora: partidoActual.hora,
                          lugar: partidoActual.lugar,
                          rival: partidoActual.rival,
                          tipoPartido: partidoActual.tipoPartido,
                          convocatoria: partidoActual.convocatoria,
                          alineacion: partidoActual.alineacion,
                          golesAFavor: partidoActual.golesAFavor,
                          golesEnContra: golesEnContraActuales,
                          lesiones: partidoActual.lesiones,
                          tarjetas: partidoActual.tarjetas,
                          cambios: partidoActual.cambios,
                          observaciones: partidoActual.observaciones,
                          isLocal: partidoActual.isLocal);
                      Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                      //boxPartidosEditarConvocatoria.putAt(widget.posicion, p);
                      setState(() {});
                    }),
              ],
            ),
          );
        }),
      );
    } else {
      return Center(
        child: Text("No hay goles en contra."),
      );
    }
  }

  //Mostrar formulario de añadir un nuevo gol en contra
  Widget anhadirGolEnContra(Partido partidoActual) {
    //Datos formulario
    final formKey = new GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Container(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
        child: Column(
          children: <Widget>[
            Text("Nuevo gol en contra"),
            //Minuto
            TextFormField(
              //initialValue: _minutoSeleccionadoGolesEnContra,
              keyboardType: TextInputType.number,
              maxLength: 3,
              validator: (val) => (val.length == 0 || int.parse(val) < 0 || int.parse(val) > 140) ? 'Escribe el minuto del gol' : null,
              //onChanged: (val) => _minutoSeleccionadoGolesEnContra = val,
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
            RaisedButton(
              child: Text("Aceptar"),
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  //Actualizar los goles a favor del partido
                  List golesEnContraActuales = partidoActual.golesEnContra;
                  //golesEnContraActuales.add("$_minutoSeleccionadoGolesEnContra");
                  golesEnContraActuales.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
                  Partido p = Partido(
                      fecha: partidoActual.fecha,
                      hora: partidoActual.hora,
                      lugar: partidoActual.lugar,
                      rival: partidoActual.rival,
                      tipoPartido: partidoActual.tipoPartido,
                      convocatoria: partidoActual.convocatoria,
                      alineacion: partidoActual.alineacion,
                      golesAFavor: partidoActual.golesAFavor,
                      golesEnContra: golesEnContraActuales,
                      lesiones: partidoActual.lesiones,
                      tarjetas: partidoActual.tarjetas,
                      cambios: partidoActual.cambios,
                      observaciones: partidoActual.observaciones,
                      isLocal: partidoActual.isLocal);
                  Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                  //boxPartidosEditarConvocatoria.putAt(widget.posicion, p);

                  //Limpiar campos
                  //_minutoSeleccionadoGolesEnContra = "";
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  /* Tarjetas */
  //Mostrar lista [Minuto, Color tarjeta, Jugador]
  Widget mostrarListaTarjetas(Partido partidoActual) {
    Box boxJugadoresEquipo = Hive.box('jugadores');
    if (partidoActual.tarjetas.length > 0) {
      return ListView(
        //Eliminar Scroll
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(partidoActual.tarjetas.length, (iFila) {
          Jugador jugadorFila;
          Color avisoJugador = Colors.redAccent.withOpacity(.5);
          for (var i = 0; i < boxJugadoresEquipo.length; i++) {
            if (partidoActual.tarjetas[iFila][2] == boxJugadoresEquipo.getAt(i).id) {
              jugadorFila = boxJugadoresEquipo.getAt(i);
              print(jugadorFila.apodo);
              for (var j = 0; j < partidoActual.convocatoria.length; j++) {
                if (partidoActual.convocatoria[j] == boxJugadoresEquipo.getAt(i).id) {
                  avisoJugador = Colors.transparent;
                }
              }
            }
          }
          return Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * .03,
              bottom: MediaQuery.of(context).size.width * .03,
            ),
            decoration: BoxDecoration(
              color: avisoJugador,
              border: Border(
                bottom: BorderSide(
                  color: ((partidoActual.tarjetas.length - 1) != iFila) ? MisterFootball.primario : Colors.transparent,
                  width: .4,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //Minuto
                Text("${partidoActual.tarjetas[iFila][0]}'"),
                if (avisoJugador == Colors.redAccent.withOpacity(.5))
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                //Color
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.sim_card_alert,
                      color: ("${partidoActual.tarjetas[iFila][1]}" == "Roja") ? Colors.red : Colors.yellowAccent,
                    ),
                    Text(
                      "${partidoActual.tarjetas[iFila][1]}",
                    ),
                  ],
                ),
                //Jugador
                (jugadorFila != null) ? Text("${jugadorFila.apodo}") : Text("Jugador eliminado"),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    tooltip: 'Eliminar tarjeta',
                    onPressed: () async {
                      //Actualizar las tarjetas del partido
                      List tarjetasActuales = partidoActual.tarjetas;
                      tarjetasActuales.removeAt(iFila);
                      Partido p = Partido(
                          fecha: partidoActual.fecha,
                          hora: partidoActual.hora,
                          lugar: partidoActual.lugar,
                          rival: partidoActual.rival,
                          tipoPartido: partidoActual.tipoPartido,
                          convocatoria: partidoActual.convocatoria,
                          alineacion: partidoActual.alineacion,
                          golesAFavor: partidoActual.golesAFavor,
                          golesEnContra: partidoActual.golesEnContra,
                          lesiones: partidoActual.lesiones,
                          tarjetas: tarjetasActuales,
                          cambios: partidoActual.cambios,
                          observaciones: partidoActual.observaciones,
                          isLocal: partidoActual.isLocal);
                      Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                      //boxPartidosEditarConvocatoria.putAt(widget.posicion, p);
                      setState(() {});
                    }),
              ],
            ),
          );
        }),
      );
    } else {
      return Center(
        child: Text("No hay tarjetas."),
      );
    }
  }

  //Mostrar formulario de añadir una nueva tarjeta
  Widget anhadirTarjetas(Partido partidoActual, StateSetter setState) {
    //Datos formulario
    final formKey = new GlobalKey<FormState>();
    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      return Form(
        key: formKey,
        child: Container(
          width: MediaQuery.of(context).size.width / 1,
          height: MediaQuery.of(context).size.height / 1,
          child: Column(
            children: <Widget>[
              Text("Nueva tarjeta"),
              //Minuto
              TextFormField(
                //initialValue: _minutoSeleccionadoTarjeta,
                keyboardType: TextInputType.number,
                maxLength: 3,
                validator: (val) => (val.length == 0 || int.parse(val) < 0 || int.parse(val) > 140) ? 'Escribe el minuto de la tarjeta' : null,
                //onChanged: (val) => _minutoSeleccionadoTarjeta = val,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                  labelText: 'Minuto*',
                  hintText: 'Minuto de la tarjeta',
                ),
              ),
              //Tarjeta amarilla/roja
              Column(
                children: <Widget>[
                  Text("Color"),
                  ToggleButtons(
                    borderColor: Colors.blueAccent.withOpacity(.5),
                    selectedBorderColor: Colors.blueAccent,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * .3,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(
                                Icons.sim_card_alert,
                                color: Colors.yellowAccent,
                                //size: MediaQuery.of(context).size.width * .4,
                              ),
                              new Text(
                                "AMARILLA",
                                style: TextStyle(
                                    //color: Colors.yellowAccent,
                                    //fontSize: MediaQuery.of(context).size.width * .4,
                                    ),
                              )
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.sim_card_alert,
                              color: Colors.red,
                              //size: MediaQuery.of(context).size.width * .4,
                            ),
                            Text(
                              "ROJA",
                              style: TextStyle(
                                  //color: Colors.red,
                                  //fontSize: MediaQuery.of(context).size.width * .4,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      /*setState(() {
                        for (int i = 0; i < _isSelected.length; i++) {
                          if (i == index) {
                            //Roja
                            _isSelected[i] = true;
                            _colorSeleccionadoTarjeta = "Roja";
                          } else {
                            //Amarilla
                            _isSelected[i] = false;
                            _colorSeleccionadoTarjeta = "Amarilla";
                          }
                        }
                      });*/
                    },
                    //isSelected: _isSelected,
                  ),
                ],
              ),
              //Jugadores
              ListView(
                shrinkWrap: true,
                children: List.generate(boxJugadores.length, (iJugador) {
                  Widget itemLista = Container(
                    width: 0,
                    height: 0,
                  );
                  Jugador jugadorBox;
                  for (var i = 0; i < partidoActual.convocatoria.length; i++) {
                    if (partidoActual.convocatoria[i] == boxJugadores.getAt(iJugador).id) {
                      jugadorBox = boxJugadores.getAt(iJugador);
                      itemLista = RadioListTile(
                        //selected: _idJugadorSeleccionadoTarjeta == jugadorBox.id,
                        value: jugadorBox.id,
                        //groupValue: _idJugadorSeleccionadoTarjeta,
                        title: Text(jugadorBox.apodo),
                        subtitle: Text(jugadorBox.apodo),
                        onChanged: (idjugadorSeleccionadoAhora) async {
                          //setState(() => _idJugadorSeleccionadoTarjeta = idjugadorSeleccionadoAhora);
                          print("Current User ${idjugadorSeleccionadoAhora}");
                        },
                        activeColor: Colors.green,
                      );
                    }
                  }
                  return itemLista;
                }),
              ),
              RaisedButton(
                child: Text("Aceptar"),
                /*onPressed: (_idJugadorSeleccionadoTarjeta == "")
                    ? null
                    : () async {
                  if (formKey.currentState.validate()) {
                    print("${_minutoSeleccionadoTarjeta}': ${_idJugadorSeleccionadoTarjeta}");
                    formKey.currentState.save();
                    //Actualizar los goles a favor del partido
                    List tarjetasActuales = partidoActual.tarjetas;
                    tarjetasActuales.add(["$_minutoSeleccionadoTarjeta", "$_colorSeleccionadoTarjeta", "$_idJugadorSeleccionadoTarjeta"]);
                    tarjetasActuales.sort((a, b) => int.parse(a[0]).compareTo(int.parse(b[0])));
                    Partido p = Partido(
                        fecha: partidoActual.fecha,
                        hora: partidoActual.hora,
                        lugar: partidoActual.lugar,
                        rival: partidoActual.rival,
                        tipoPartido: partidoActual.tipoPartido,
                        convocatoria: partidoActual.convocatoria,
                        alineacion: partidoActual.alineacion,
                        golesAFavor: partidoActual.golesAFavor,
                        golesEnContra: partidoActual.golesEnContra,
                        lesiones: partidoActual.lesiones,
                        tarjetas: tarjetasActuales,
                        cambios: partidoActual.cambios,
                        observaciones: partidoActual.observaciones,
                        isLocal: partidoActual.isLocal);
                    Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                    boxPartidosEditarConvocatoria.putAt(widget.posicion, p);

                    //Limpiar campos
                    _minutoSeleccionadoTarjeta = "";
                    _idJugadorSeleccionadoTarjeta = "";
                    Navigator.pop(context);
                  }
                },*/
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

  /* Cambios */
  //Mostrar lista [Minuto, Jugador entra, Jugador sale]
  Widget mostrarListaCambios(Partido partidoActual) {
    Box boxJugadoresEquipo = Hive.box('jugadores');
    if (partidoActual.cambios.length > 0) {
      return ListView(
        //Eliminar Scroll
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(partidoActual.cambios.length, (iFila) {
          Jugador jugadorFilaEntra; //[1]
          Jugador jugadorFilaSale; //[2]
          Color avisoJugador = Colors.redAccent.withOpacity(.5);
          //Asignar jugador que entra
          for (var i = 0; i < boxJugadoresEquipo.length; i++) {
            if (partidoActual.cambios[iFila][1] == boxJugadoresEquipo.getAt(i).id) {
              jugadorFilaEntra = boxJugadoresEquipo.getAt(i);
            }
          }
          //Asignar jugador que sale
          for (var i = 0; i < boxJugadoresEquipo.length; i++) {
            if (partidoActual.cambios[iFila][2] == boxJugadoresEquipo.getAt(i).id) {
              jugadorFilaSale = boxJugadoresEquipo.getAt(i);
            }
          }

          //Comprobar si está convocado
          bool _isConvocadoJugadorEntra = false;
          if (jugadorFilaEntra != null) {
            for (var j = 0; j < partidoActual.convocatoria.length; j++) {
              if (partidoActual.convocatoria[j] == jugadorFilaEntra.id) {
                _isConvocadoJugadorEntra = true;
              }
            }
          }
          if (jugadorFilaSale != null) {
            for (var j = 0; j < partidoActual.convocatoria.length; j++) {
              if (partidoActual.convocatoria[j] == jugadorFilaSale.id) {
                if (_isConvocadoJugadorEntra) {
                  avisoJugador = Colors.transparent;
                }
              }
            }
          }
          return Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * .03,
              bottom: MediaQuery.of(context).size.width * .03,
            ),
            decoration: BoxDecoration(
              color: avisoJugador,
              border: Border(
                bottom: BorderSide(
                  color: ((partidoActual.cambios.length - 1) != iFila) ? MisterFootball.primario : Colors.transparent,
                  width: .4,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //Minuto
                Text("${partidoActual.cambios[iFila][0]}'"),
                if (avisoJugador == Colors.redAccent.withOpacity(.5))
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                Column(
                  children: <Widget>[
                    //Jugador sale
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        ),
                        (jugadorFilaSale != null) ? Text("${jugadorFilaSale.apodo}") : Text("Jugador eliminado"),
                      ],
                    ),
                    //Jugador entra
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                        ),
                        (jugadorFilaEntra != null) ? Text("${jugadorFilaEntra.apodo}") : Text("Jugador eliminado"),
                      ],
                    ),
                  ],
                ),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    tooltip: 'Eliminar cambio',
                    onPressed: () async {
                      //Actualizar los cambios del partido
                      List cambiosActuales = partidoActual.cambios;
                      cambiosActuales.removeAt(iFila);
                      Partido p = Partido(
                          fecha: partidoActual.fecha,
                          hora: partidoActual.hora,
                          lugar: partidoActual.lugar,
                          rival: partidoActual.rival,
                          tipoPartido: partidoActual.tipoPartido,
                          convocatoria: partidoActual.convocatoria,
                          alineacion: partidoActual.alineacion,
                          golesAFavor: partidoActual.golesAFavor,
                          golesEnContra: partidoActual.golesEnContra,
                          lesiones: partidoActual.lesiones,
                          tarjetas: partidoActual.tarjetas,
                          cambios: cambiosActuales,
                          observaciones: partidoActual.observaciones,
                          isLocal: partidoActual.isLocal);
                      Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                      //boxPartidosEditarConvocatoria.putAt(widget.posicion, p);
                      setState(() {});
                    }),
              ],
            ),
          );
        }),
      );
    } else {
      return Center(
        child: Text("No hay cambios."),
      );
    }
  }

  //Mostrar formulario de añadir una nueva tarjeta
  Widget anhadirCambios(Partido partidoActual, StateSetter setState) {
    //Datos formulario
    final formKey = new GlobalKey<FormState>();
    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      return SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            width: MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.height / 1,
            child: Column(
              children: <Widget>[
                Text("Nuevo cambio"),
                //Minuto
                TextFormField(
                  //initialValue: _minutoSeleccionadoCambios,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  validator: (val) => (val.length == 0 || int.parse(val) < 0 || int.parse(val) > 140) ? 'Escribe el minuto del cambio' : null,
                  //onChanged: (val) => _minutoSeleccionadoCambios = val,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                    labelText: 'Minuto*',
                    hintText: 'Minuto del cambio',
                  ),
                ),
                //Jugadores
                Text("Entra:"),
                ListView(
                  shrinkWrap: true,
                  children: List.generate(boxJugadores.length, (iJugador) {
                    Widget itemLista = Container(
                      width: 0,
                      height: 0,
                    );
                    Jugador jugadorBox;
                    for (var i = 0; i < partidoActual.convocatoria.length; i++) {
                      if (partidoActual.convocatoria[i] == boxJugadores.getAt(iJugador).id) {
                        jugadorBox = boxJugadores.getAt(iJugador);
                        itemLista = RadioListTile(
                          //selected: _idJugadorEntraSeleccionadoCambios == jugadorBox.id,
                          value: jugadorBox.id,
                          //groupValue: _idJugadorEntraSeleccionadoCambios,
                          title: Text(jugadorBox.apodo),
                          subtitle: Text(jugadorBox.apodo),
                          onChanged: (idjugadorSeleccionadoAhora) async {
                            //setState(() => _idJugadorEntraSeleccionadoCambios = idjugadorSeleccionadoAhora);
                            print("Current User ${idjugadorSeleccionadoAhora}");
                          },
                          activeColor: Colors.green,
                        );
                      }
                    }
                    return itemLista;
                  }),
                ),
                //Jugadores
                Text("Sale:"),
                ListView(
                  shrinkWrap: true,
                  children: List.generate(boxJugadores.length, (iJugador) {
                    Widget itemLista = Container(
                      width: 0,
                      height: 0,
                    );
                    Jugador jugadorBox;
                    for (var i = 0; i < partidoActual.convocatoria.length; i++) {
                      if (partidoActual.convocatoria[i] == boxJugadores.getAt(iJugador).id) {
                        jugadorBox = boxJugadores.getAt(iJugador);
                        itemLista = RadioListTile(
                          //selected: _idJugadorSaleSeleccionadoCambios == jugadorBox.id,
                          value: jugadorBox.id,
                          //groupValue: _idJugadorSaleSeleccionadoCambios,
                          title: Text(jugadorBox.apodo),
                          subtitle: Text(jugadorBox.apodo),
                          onChanged: (idjugadorSeleccionadoAhora) async {
                            //setState(() => _idJugadorSaleSeleccionadoCambios = idjugadorSeleccionadoAhora);
                            print("Current User ${idjugadorSeleccionadoAhora}");
                          },
                          activeColor: Colors.green,
                        );
                      }
                    }
                    return itemLista;
                  }),
                ),
                RaisedButton(
                  child: Text("Aceptar"),
                  /*onPressed: (_idJugadorEntraSeleccionadoCambios == "" && _idJugadorSaleSeleccionadoCambios == "")
                      ? null
                      : () async {
                    if (formKey.currentState.validate()) {
                      print("${_minutoSeleccionadoCambios}': ${_idJugadorEntraSeleccionadoCambios} - ${_idJugadorSaleSeleccionadoCambios}");
                      formKey.currentState.save();
                      //Actualizar los goles a favor del partido
                      List cambiosActuales = partidoActual.cambios;
                      cambiosActuales
                          .add(["$_minutoSeleccionadoCambios", "$_idJugadorEntraSeleccionadoCambios", "$_idJugadorSaleSeleccionadoCambios"]);
                      cambiosActuales.sort((a, b) => int.parse(a[0]).compareTo(int.parse(b[0])));
                      Partido p = Partido(
                          fecha: partidoActual.fecha,
                          hora: partidoActual.hora,
                          lugar: partidoActual.lugar,
                          rival: partidoActual.rival,
                          tipoPartido: partidoActual.tipoPartido,
                          convocatoria: partidoActual.convocatoria,
                          alineacion: partidoActual.alineacion,
                          golesAFavor: partidoActual.golesAFavor,
                          golesEnContra: partidoActual.golesEnContra,
                          lesiones: partidoActual.lesiones,
                          tarjetas: partidoActual.tarjetas,
                          cambios: cambiosActuales,
                          observaciones: partidoActual.observaciones,
                          isLocal: partidoActual.isLocal);
                      Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                      boxPartidosEditarConvocatoria.putAt(widget.posicion, p);

                      //Limpiar campos
                      _idJugadorSaleSeleccionadoCambios = "";
                      _idJugadorSaleSeleccionadoCambios = "";
                      _minutoSeleccionadoCambios = "";
                      Navigator.pop(context);
                    }
                  },*/
                )
              ],
            ),
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

  /* Lesiones */
  //Mostrar lista [Minuto, Jugador]
  Widget mostrarListaLesion(Partido partidoActual) {
    Box boxJugadoresEquipo = Hive.box('jugadores');
    if (partidoActual.lesiones.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(partidoActual.lesiones.length, (iFila) {
          Jugador jugadorFila;
          Color avisoJugador = Colors.redAccent.withOpacity(.5);
          for (var i = 0; i < boxJugadoresEquipo.length; i++) {
            if (partidoActual.lesiones[iFila][1] == boxJugadoresEquipo.getAt(i).id) {
              jugadorFila = boxJugadoresEquipo.getAt(i);
              for (var j = 0; j < partidoActual.convocatoria.length; j++) {
                if (partidoActual.convocatoria[j] == boxJugadoresEquipo.getAt(i).id) {
                  avisoJugador = Colors.transparent;
                }
              }
            }
          }
          return Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * .03,
              bottom: MediaQuery.of(context).size.width * .03,
            ),
            decoration: BoxDecoration(
              color: avisoJugador,
              border: Border(
                bottom: BorderSide(
                  color: ((partidoActual.lesiones.length - 1) != iFila) ? MisterFootball.primario : Colors.transparent,
                  width: .4,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("${partidoActual.lesiones[iFila][0]}'"),
                if (avisoJugador == Colors.redAccent.withOpacity(.5))
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.healing,
                      color: Colors.red,
                    ),
                    (jugadorFila != null) ? Text("${jugadorFila.apodo}") : Text("Jugador eliminado"),
                  ],
                ),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    tooltip: 'Eliminar gol',
                    onPressed: () async {
                      //Actualizar los goles a favor del partido
                      List lesionesActuales = partidoActual.lesiones;
                      lesionesActuales.removeAt(iFila);
                      Partido p = Partido(
                          fecha: partidoActual.fecha,
                          hora: partidoActual.hora,
                          lugar: partidoActual.lugar,
                          rival: partidoActual.rival,
                          tipoPartido: partidoActual.tipoPartido,
                          convocatoria: partidoActual.convocatoria,
                          alineacion: partidoActual.alineacion,
                          golesAFavor: partidoActual.golesAFavor,
                          golesEnContra: partidoActual.golesEnContra,
                          lesiones: lesionesActuales,
                          tarjetas: partidoActual.tarjetas,
                          cambios: partidoActual.cambios,
                          observaciones: partidoActual.observaciones,
                          isLocal: partidoActual.isLocal);
                      Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                      //boxPartidosEditarConvocatoria.putAt(widget.posicion, p);
                      setState(() {});
                    }),
              ],
            ),
          );
        }),
      );
    } else {
      return Center(
        child: Text("No hay lesiones."),
      );
    }
  }

  //Mostrar formulario de añadir una nueva lesion
  Widget anhadirLesion(Partido partidoActual, StateSetter setState) {
    //Datos formulario
    final formKey = new GlobalKey<FormState>();
    final boxJugadores = Hive.box('jugadores');
    if (boxJugadores.length > 0) {
      return Form(
        key: formKey,
        child: Container(
          width: MediaQuery.of(context).size.width / 1,
          height: MediaQuery.of(context).size.height / 1,
          child: Column(
            children: <Widget>[
              Text("Nueva lesión"),
              //Minuto
              TextFormField(
                //initialValue: _minutoSeleccionadoLesiones,
                keyboardType: TextInputType.number,
                maxLength: 3,
                validator: (val) => (val.length == 0 || int.parse(val) < 0 || int.parse(val) > 140) ? 'Escribe el minuto de la lesión' : null,
                //onChanged: (val) => _minutoSeleccionadoLesiones = val,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                  labelText: 'Minuto*',
                  hintText: 'Minuto de la lesión',
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: List.generate(boxJugadores.length, (iJugador) {
                  Widget itemLista = Container(
                    width: 0,
                    height: 0,
                  );
                  Jugador jugadorBox;
                  for (var i = 0; i < partidoActual.convocatoria.length; i++) {
                    if (partidoActual.convocatoria[i] == boxJugadores.getAt(iJugador).id) {
                      jugadorBox = boxJugadores.getAt(iJugador);
                      itemLista = RadioListTile(
                        //selected: _idJugadorSeleccionadoLesiones == jugadorBox.id,
                        value: jugadorBox.id,
                        //groupValue: _idJugadorSeleccionadoLesiones,
                        title: Text(jugadorBox.apodo),
                        subtitle: Text(jugadorBox.apodo),
                        onChanged: (idjugadorSeleccionadoAhora) async {
                          //setState(() => _idJugadorSeleccionadoLesiones = idjugadorSeleccionadoAhora);
                          print("Current User ${idjugadorSeleccionadoAhora}");
                        },
                        activeColor: Colors.green,
                      );
                    }
                  }
                  return itemLista;
                }),
              ),
              RaisedButton(
                child: Text("Aceptar"),
                /*onPressed: (_idJugadorSeleccionadoLesiones == "")
                    ? null
                    : () async {
                  if (formKey.currentState.validate()) {
                    print("${_minutoSeleccionadoLesiones}': ${_idJugadorSeleccionadoLesiones}");
                    formKey.currentState.save();
                    //Actualizar los goles a favor del partido
                    List lesionesActuales = partidoActual.lesiones;
                    lesionesActuales.add(["$_minutoSeleccionadoLesiones", "$_idJugadorSeleccionadoLesiones"]);
                    lesionesActuales.sort((a, b) => int.parse(a[0]).compareTo(int.parse(b[0])));
                    Partido p = Partido(
                        fecha: partidoActual.fecha,
                        hora: partidoActual.hora,
                        lugar: partidoActual.lugar,
                        rival: partidoActual.rival,
                        tipoPartido: partidoActual.tipoPartido,
                        convocatoria: partidoActual.convocatoria,
                        alineacion: partidoActual.alineacion,
                        golesAFavor: partidoActual.golesAFavor,
                        golesEnContra: partidoActual.golesEnContra,
                        lesiones: lesionesActuales,
                        tarjetas: partidoActual.tarjetas,
                        cambios: partidoActual.cambios,
                        observaciones: partidoActual.observaciones,
                        isLocal: partidoActual.isLocal);
                    Box boxPartidosEditarConvocatoria = await Hive.openBox('partidos');
                    boxPartidosEditarConvocatoria.putAt(widget.posicion, p);

                    //Limpiar campos
                    _idJugadorSeleccionadoLesiones = "";
                    _minutoSeleccionadoLesiones = "";
                    Navigator.pop(context);
                  }
                },*/
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
