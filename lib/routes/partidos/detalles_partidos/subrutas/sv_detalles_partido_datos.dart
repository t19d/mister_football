import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';

class DetallesPartidoDatos extends StatefulWidget {
  final Partido partido;

  DetallesPartidoDatos({Key key, @required this.partido}) : super(key: key);

  @override
  createState() => _DetallesPartidoDatos();
}

class _DetallesPartidoDatos extends State<DetallesPartidoDatos> {
  @override
  Widget build(BuildContext context) {
    //Estilo de los titulos de los eventos
    TextStyle tituloEventos = TextStyle(
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );
    final boxPerfil = Hive.box('perfil');
    Map<String, dynamic> perfil = {"nombre_equipo": "", "escudo": ""};
    if (boxPerfil.get(0) != null) {
      perfil = Map.from(boxPerfil.get(0));
    }
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
            decoration: BoxDecoration(
              color: MisterFootball.colorPrimarioLight2.withOpacity(.25),
              border: Border(bottom: BorderSide(width: 1)),
            ),
            child: (widget.partido.isLocal)
                //Partido de local
                ? Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          //Nuestro Escudo
                          ConversorImagen.devolverEscudoImageFromBase64String(perfil['escudo'], context),
                          //Nosotros
                          Text(
                            (perfil['nombre_equipo'].length == 0) ? "Mi equipo" : perfil['nombre_equipo'],
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${widget.partido.golesAFavor.length}-${widget.partido.golesEnContra.length}",
                            textAlign: TextAlign.center,
                          ),
                          //Rival
                          Text(
                            widget.partido.rival,
                            textAlign: TextAlign.center,
                          ),
                          //Escudo Rival
                          Icon(
                            Icons.security,
                            color: MisterFootball.colorPrimario,
                            size: MediaQuery.of(context).size.width / 6,
                          ),
                        ],
                      ),
                    ],
                  )
                //Partido de visitante
                : Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          //Escudo Rival
                          Icon(
                            Icons.security,
                            color: MisterFootball.colorPrimario,
                            size: MediaQuery.of(context).size.width / 6,
                          ),
                          //Rival
                          Text(
                            widget.partido.rival,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${widget.partido.golesEnContra.length}-${widget.partido.golesAFavor.length}",
                            textAlign: TextAlign.center,
                          ),
                          //Nosotros
                          Text(
                            (perfil['nombre_equipo'].length == 0) ? "Mi equipo" : perfil['nombre_equipo'],
                            textAlign: TextAlign.center,
                          ),
                          //Nuestro Escudo
                          ConversorImagen.devolverEscudoImageFromBase64String(perfil['escudo'], context),
                        ],
                      ),
                    ],
                  ),
          ),
          //Datos prepartido
          Container(
            /*margin: EdgeInsets.only(
                  //bottom: MediaQuery.of(context).size.width * .03,
                  //top: MediaQuery.of(context).size.width * .03,
                ),*/
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .03,
              right: MediaQuery.of(context).size.width * .03,
            ),
            child: Table(
              border: TableBorder(
                verticalInside: BorderSide(
                  color: MisterFootball.colorPrimario,
                  width: .4,
                ),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                //Lugar
                //Si no se ha completa el campo, no rellenar
                if (widget.partido.lugar.length != 0)
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        //top: BorderSide(color: MisterFootball.colorPrimario, width: .4),
                        bottom: BorderSide(color: MisterFootball.colorPrimario, width: .4),
                      ),
                    ),
                    children: [
                      Text(
                        "Lugar",
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * .03,
                          bottom: MediaQuery.of(context).size.width * .03,
                        ),
                        child: Text(
                          "${widget.partido.lugar}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                //Tipo
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: MisterFootball.colorPrimario, width: .4),
                    ),
                  ),
                  children: [
                    Text(
                      "Tipo",
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * .03,
                        bottom: MediaQuery.of(context).size.width * .03,
                      ),
                      child: Text(
                        "${widget.partido.tipoPartido}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                //Fecha
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: MisterFootball.colorPrimario, width: .4),
                    ),
                  ),
                  children: [
                    Text(
                      "Fecha",
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * .03,
                        bottom: MediaQuery.of(context).size.width * .03,
                      ),
                      child: Text(
                        "${widget.partido.fecha.split("-")[2]}-${widget.partido.fecha.split("-")[1]}-${widget.partido.fecha.split("-")[0]}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                //Hora
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: MisterFootball.colorPrimario, width: .4),
                    ),
                  ),
                  children: [
                    Text(
                      "Hora",
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * .03,
                        bottom: MediaQuery.of(context).size.width * .03,
                      ),
                      child: Text(
                        "${widget.partido.hora}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //Datos eventos
          Container(
            decoration: BoxDecoration(
              color: MisterFootball.colorPrimarioLight2.withOpacity(.05),
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
                Text(
                  "Goles a favor",
                  style: tituloEventos,
                ),
                mostrarListaGolesAFavor(widget.partido),
              ],
            ),
          ),
          //Goles en Contra
          Container(
            decoration: BoxDecoration(
              color: MisterFootball.colorPrimarioLight2.withOpacity(.05),
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
                Text(
                  "Goles en contra",
                  style: tituloEventos,
                ),
                mostrarListaGolesEnContra(widget.partido),
              ],
            ),
          ),
          //Tarjetas
          Container(
            decoration: BoxDecoration(
              color: MisterFootball.colorPrimarioLight2.withOpacity(.05),
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
                Text(
                  "Tarjetas",
                  style: tituloEventos,
                ),
                mostrarListaTarjetas(widget.partido),
              ],
            ),
          ),
          //Cambios
          Container(
            decoration: BoxDecoration(
              color: MisterFootball.colorPrimarioLight2.withOpacity(.05),
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
                Text(
                  "Cambios",
                  style: tituloEventos,
                ),
                mostrarListaCambios(widget.partido),
              ],
            ),
          ),
          //Lesiones
          Container(
            decoration: BoxDecoration(
              color: MisterFootball.colorPrimarioLight2.withOpacity(.05),
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
                Text(
                  "Lesiones",
                  style: tituloEventos,
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
                  color: ((partidoActual.golesAFavor.length - 1) != iFila) ? MisterFootball.colorPrimario : Colors.transparent,
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
                  color: ((partidoActual.golesEnContra.length - 1) != iFila) ? MisterFootball.colorPrimario : Colors.transparent,
                  width: .4,
                ),
              ),
            ),
            child: Text(
              "${partidoActual.golesEnContra[iFila]}'",
              textAlign: TextAlign.center,
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
                  color: ((partidoActual.tarjetas.length - 1) != iFila) ? MisterFootball.colorPrimario : Colors.transparent,
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
                  color: ((partidoActual.cambios.length - 1) != iFila) ? MisterFootball.colorPrimario : Colors.transparent,
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
                  color: ((partidoActual.lesiones.length - 1) != iFila) ? MisterFootball.colorPrimario : Colors.transparent,
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
}
