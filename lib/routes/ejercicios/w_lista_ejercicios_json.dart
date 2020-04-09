import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mister_football/main.dart';

class ListaEjerciciosJSON extends StatefulWidget {
  @override
  createState() => _ListaEjerciciosJSON();
}

class _ListaEjerciciosJSON extends State<ListaEjerciciosJSON> {
  Future<String> cargarEjercicios() async {
    return await rootBundle.loadString('assets/json/ejercicios.json');
  }

  Color colorear(tipo) {
    Color coloreado = Colors.white;
    switch (tipo) {
      case "Físico":
        coloreado = Colors.orange;
        break;
      case "Táctico":
        coloreado = Colors.lightBlue;
        break;
      case "Técnico":
        coloreado = Colors.red;
        break;
    }
    return coloreado.withOpacity(.7);
  }

  Widget itemEjercicio(String ejerciciosString) {
    List<dynamic> ejercicios = jsonDecode(ejerciciosString);
    if (ejercicios.length > 0) {
      return ListView(
        children: List.generate(ejercicios.length, (iEjercicio) {
          //print(ejercicios[iEjercicio].runtimeType);
          return Card(
            /*shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),*/
            child: new InkWell(
              splashColor: MisterFootball.complementario,
              /*onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesJugador(
                      jugador: jugadorBox,
                      posicion: iJugador,
                    ),
                  ),
                );
              },*/
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: colorear(ejercicios[iEjercicio]['tipo']),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //Título
                    Text(
                      ejercicios[iEjercicio]['titulo'],
                      textAlign: TextAlign.center,
                    ),
                    //Tipo
                    Text(
                      ejercicios[iEjercicio]['tipo'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                    //Tiempo
                    Text(
                      ejercicios[iEjercicio]['duracion'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                    //Dificultad
                    Text(
                      ejercicios[iEjercicio]['dificultad'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              //),
            ),
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: cargarEjercicios(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text(snapshot.error.toString());
                    } else {
                      return itemEjercicio(snapshot.data);
                    }
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
