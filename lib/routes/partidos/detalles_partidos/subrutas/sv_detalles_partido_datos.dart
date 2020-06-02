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
    final boxPerfil = Hive.box('perfil');
    Map<String, dynamic> perfil = {"nombre_equipo": "", "escudo": ""};
    if (boxPerfil.get(0) != null) {
      perfil = Map.from(boxPerfil.get(0));
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              (widget.partido.isLocal)
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
                              color: MisterFootball.primario,
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
                              color: MisterFootball.primario,
                              size: MediaQuery.of(context).size.width / 6,
                            ),
                            //Rival
                            Text(
                              widget.partido.rival,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "${widget.partido.golesAFavor.length}-${widget.partido.golesEnContra.length}",
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
              Container(
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    //Lugar
                    //Si no se ha completa el campo, no rellenar
                    if (widget.partido.lugar.length != 0)
                      TableRow(
                        children: [
                          Text(
                            "Lugar",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${widget.partido.lugar}",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    //Tipo
                    TableRow(
                      children: [
                        Text(
                          "Tipo",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "${widget.partido.tipoPartido}",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    //Fecha
                    TableRow(
                      children: [
                        Text(
                          "Fecha",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "${widget.partido.fecha}",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    //Hora
                    TableRow(
                      children: [
                        Text(
                          "Hora",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "${widget.partido.hora}",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.grey.withOpacity(.15),
                    child: Column(
                      children: <Widget>[
                        Text("Goles a favor"),
                        mostrarListaGolesAFavor(widget.partido),
                      ],
                    ),
                  ),
                  //Goles en Contra
                  Container(
                    color: Colors.grey.withOpacity(.15),
                    child: Column(
                      children: <Widget>[
                        Text("Goles en contra"),
                        mostrarListaGolesEnContra(widget.partido),
                      ],
                    ),
                  ),
                  //Tarjetas
                  Container(
                    color: Colors.grey.withOpacity(.15),
                    child: Column(
                      children: <Widget>[
                        Text("Tarjetas"),
                        mostrarListaTarjetas(widget.partido),
                      ],
                    ),
                  ),
                  //Cambios
                  Container(
                    color: Colors.grey.withOpacity(.15),
                    child: Column(
                      children: <Widget>[
                        Text("Cambios"),
                        mostrarListaCambios(widget.partido),
                      ],
                    ),
                  ),
                  //Lesiones
                  Container(
                    color: Colors.grey.withOpacity(.15),
                    child: Column(
                      children: <Widget>[
                        Text("Lesiones"),
                        mostrarListaLesion(widget.partido),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
            color: avisoJugador,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("${partidoActual.golesAFavor[iFila][0]}'"),
                if (avisoJugador == Colors.redAccent.withOpacity(.5))
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                Text("${jugadorFila.apodo}"),
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
          return Text(
            "${partidoActual.golesEnContra[iFila]}'",
            textAlign: TextAlign.center,
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
            color: avisoJugador,
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
                Text("${jugadorFila.apodo}"),
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
          for (var j = 0; j < partidoActual.convocatoria.length; j++) {
            if (partidoActual.convocatoria[j] == jugadorFilaEntra.id) {
              _isConvocadoJugadorEntra = true;
            }
          }
          for (var j = 0; j < partidoActual.convocatoria.length; j++) {
            if (partidoActual.convocatoria[j] == jugadorFilaSale.id) {
              if (_isConvocadoJugadorEntra) {
                avisoJugador = Colors.transparent;
              }
            }
          }
          return Container(
            color: avisoJugador,
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
                        Text("${jugadorFilaSale.apodo}"),
                      ],
                    ),
                    //Jugador entra
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                        ),
                        Text("${jugadorFilaEntra.apodo}"),
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
            color: avisoJugador,
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
                    Text("${jugadorFila.apodo}"),
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
