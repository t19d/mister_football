import 'package:flutter/material.dart';

class ListaGestionJugadoresLesionados extends StatefulWidget {
  @override
  createState() => _ListaGestionJugadoresLesionados();
}

class _ListaGestionJugadoresLesionados
    extends State<ListaGestionJugadoresLesionados> {
  Map jugadores = new Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    color: Colors.lightBlueAccent,
                    child: Text("Curar"),
                    onPressed: () {
                      print("Curao");
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text("Mundo"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
