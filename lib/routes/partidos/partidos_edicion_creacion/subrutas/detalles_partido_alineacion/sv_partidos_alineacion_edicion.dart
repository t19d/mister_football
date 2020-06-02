import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/routes/partidos/detalles_partidos/subrutas/detalles_partido_alineacion/w_detalles_partido_alineacion_campo_jugadores.dart';

class DetallesPartidoAlineacion extends StatefulWidget {
  final int posicion;

  DetallesPartidoAlineacion({Key key, @required this.posicion}) : super(key: key);

  @override
  createState() => _DetallesPartidoAlineacion();
}

class _DetallesPartidoAlineacion extends State<DetallesPartidoAlineacion> {
  Partido partido = null;

  @override
  Widget build(BuildContext context) {
    /*return FutureBuilder(
      future: Hive.openBox('partidos'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            final boxPartidos = Hive.box('partidos');
            partido = boxPartidos.getAt(widget.posicion);
            //Seleccionar formación inicial
            String formacionInicialPartido = "14231";
            if(partido.alineacion != null){
              if(partido.alineacion['0'][0] != null) {
                formacionInicialPartido = partido.alineacion['0'][0];
              }
            }
            return Scaffold(
              body: SafeArea(
                child: DetallesPartidoAlineacionCampoJugadores(posicion: widget.posicion, formacionPartido: formacionInicialPartido),
              ),
            );
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );*/
    return Scaffold(
      body: SafeArea(
        child: DetallesPartidoAlineacionCampoJugadores(posicion: widget.posicion),
      ),
    );
  }
}
