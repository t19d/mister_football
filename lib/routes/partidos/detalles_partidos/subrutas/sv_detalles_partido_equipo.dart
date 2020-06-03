import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/conversor_imagen.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/clases/partido.dart';
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
      child: Column(
        children: <Widget>[
          Text(formacionInicialPartido),
          DetallesPartidoAlineacionFormacion(formacion: formacionInicialPartido, partido: widget.partido),
          Text("Jugadores convocados"),
          Container(
            child: mostrarJugadoresSeleccionados(widget.partido.convocatoria),
          ),
        ],
      ),
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
            Jugador jugadorBox;
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
}
