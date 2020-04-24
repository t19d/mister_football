import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/clases/partido.dart';

class DetallesPartidoPrepartido extends StatefulWidget {
  final int posicion;

  DetallesPartidoPrepartido({Key key, @required this.posicion}) : super(key: key);

  @override
  createState() => _DetallesPartidoPrepartido();
}

class _DetallesPartidoPrepartido extends State<DetallesPartidoPrepartido> {
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
                  child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("${partido.fecha}"),
                      Text("${partido.hora}"),
                    ],
                  ),
                  Text("${partido.tipoPartido}"),
                  Text("${partido.rival}"),
                  Text("${partido.lugar}"),
                ],
              )),
            );
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }
}