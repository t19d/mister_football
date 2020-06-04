import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/subrutas/detalles_partido_alineacion/w_detalles_partido_alineacion_formaciones.dart';

class DetallesPartidoEquipo extends StatefulWidget {
  final Partido partido;

  DetallesPartidoEquipo({Key key, @required this.partido}) : super(key: key);

  @override
  createState() => _DetallesPartidoEquipo();
}

class _DetallesPartidoEquipo extends State<DetallesPartidoEquipo> {
  @override
  Widget build(BuildContext context) {
    //Seleccionar formación inicial
    String formacionInicialPartido = "14231";
    if (widget.partido.alineacion != null) {
      if (widget.partido.alineacion['0'][0] != null) {
        formacionInicialPartido = widget.partido.alineacion['0'][0];
      }
    }
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * .03,
        ),
        child: Column(
          children: <Widget>[
            Text(
              formacionInicialPartido,
              style: TextStyle(
                decoration: TextDecoration.underline,
                //fontWeight: FontWeight.bold
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * .03,
                top: MediaQuery.of(context).size.width * .03,
              ),
              child: DetallesPartidoAlineacionFormacion(formacion: formacionInicialPartido, partido: widget.partido),
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
                  Text(
                    "Jugadores convocados",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      //fontWeight: FontWeight.bold
                    ),
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
