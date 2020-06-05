import 'package:flutter/material.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/routes/partidos/partidos_edicion_creacion/subrutas/detalles_partido_alineacion/w_partidos_alineacion_campo_jugadores_edicion.dart';

class PartidoAlineacionEdicion extends StatefulWidget {
  final Partido partido;

  PartidoAlineacionEdicion({Key key, @required this.partido}) : super(key: key);

  @override
  createState() => _PartidoAlineacionEdicion();
}

class _PartidoAlineacionEdicion extends State<PartidoAlineacionEdicion> {
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
        child: PartidoAlineacionCampoJugadoresEdicion(partido: widget.partido),
      ),
    );
  }
}
