import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/subrutas/detalles_partido_alineacion/w_detalles_partido_alineacion_formaciones.dart';
import 'package:share/share.dart';

class DetallesPartidoEquipo extends StatefulWidget {
  final Partido partido;

  DetallesPartidoEquipo({Key key, @required this.partido}) : super(key: key);

  @override
  createState() => _DetallesPartidoEquipo();
}

class _DetallesPartidoEquipo extends State<DetallesPartidoEquipo> {
  String formacionInicialPartido;
  String _minutoActual;
  List<DropdownMenuItem<String>> _minutosDisponibles;

  @override
  void initState() {
    super.initState();
    _minutoActual = "0";
    formacionInicialPartido = "14231";
  }

  void cambiarMinutoFormacion(String minutoElegido) async {
    _minutoActual = minutoElegido;
  }

  void actualizarMinutoFormacionPartido(String minutoElegido) async {
    cambiarMinutoFormacion(minutoElegido);
    formacionInicialPartido = widget.partido.alineacion['$minutoElegido'][0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //Seleccionar formación inicial
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

    //Añadir minutos con alineaciones guardadas
    if (widget.partido.alineacion != null) {
        List<DropdownMenuItem<String>> items = List();
        for (String f in widget.partido.alineacion.keys) {
          items.add(DropdownMenuItem(value: f, child: Text((f.length == 1) ? "0$f" : "$f")));
        }
        items.sort((a, b) => (a.child.toString().substring(a.child.toString().length - 4, a.child.toString().length - 2))
            .compareTo(b.child.toString().substring(b.child.toString().length - 4, b.child.toString().length - 2)));
      _minutosDisponibles = items;
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * .03,
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .8,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Text(
                        "Minuto:",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Formación:",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      DropdownButton(
                        value: _minutoActual,
                        items: _minutosDisponibles,
                        onChanged: (val) async {
                          actualizarMinutoFormacionPartido(val);
                          //cambiarMinutoFormacion(val);
                          setState(() {});
                        },
                      ),
                      Text(
                        formacionInicialPartido,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * .03,
                top: MediaQuery.of(context).size.width * .03,
              ),
              child: DetallesPartidoAlineacionFormacion(
                formacion: formacionInicialPartido,
                partido: widget.partido,
                minuto: _minutoActual,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * .03,
                bottom: MediaQuery.of(context).size.width * .03,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          Icons.share,
                          color: MisterFootball.primario,
                        ),
                        tooltip: 'Compartir convocatoria',
                        onPressed: () async {
                          String textoListaConvocatoria = "📢📢 Convocatoria 📢📢"
                              "\n⚽ Rival: ${widget.partido.rival} ";
                          if (widget.partido.lugar.length > 0) {
                            textoListaConvocatoria += "\n🏟️ Lugar: ${widget.partido.lugar} ";
                          }
                          textoListaConvocatoria += "\n📆 Fecha: ${widget.partido.fecha.split("-")[2]}-"
                                  "${widget.partido.fecha.split("-")[1]}-"
                                  "${widget.partido.fecha.split("-")[0]}" +
                              "\n🕑 Hora: ${widget.partido.hora}" +
                              "\n";
                          Box boxJugadoresEquipo = Hive.box('jugadores');
                          List jugadoresConvocados = widget.partido.convocatoria;
                          for (var j = 0; j < jugadoresConvocados.length; j++) {
                            if (jugadoresConvocados != null) {
                              if (jugadoresConvocados.length > 0) {
                                Jugador jugadorBox;
                                for (var i = 0; i < boxJugadoresEquipo.length; i++) {
                                  if ('${jugadoresConvocados[j]}' == boxJugadoresEquipo.getAt(i).id) {
                                    jugadorBox = boxJugadoresEquipo.getAt(i);
                                    textoListaConvocatoria += "\n✅ ${jugadorBox.nombre} ${jugadorBox.apellido1} ";
                                    if (jugadorBox.apellido2.length > 0) {
                                      textoListaConvocatoria += "${jugadorBox.apellido2} ";
                                    }
                                    textoListaConvocatoria += "(${jugadorBox.apodo})";
                                  }
                                }
                              }
                            }
                          }
                          await Share.share('$textoListaConvocatoria');
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * .03,
                      left: MediaQuery.of(context).size.width * .03,
                      right: MediaQuery.of(context).size.width * .03,
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
}
