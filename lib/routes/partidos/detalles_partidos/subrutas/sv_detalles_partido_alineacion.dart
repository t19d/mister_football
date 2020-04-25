import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/partido.dart';
import 'package:mister_football/routes/alineacion_favorita/w_campo_jugadores.dart';

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
    return FutureBuilder(
      future: Hive.openBox('partidos'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            final boxEntrenamientos = Hive.box('partidos');
            partido = boxEntrenamientos.getAt(widget.posicion);
            return Scaffold(
              body: SafeArea(
                child: CampoJugadores(),
              ),
            );
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }
}
