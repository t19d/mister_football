import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/ejercicios/ejercicio/v_detalles_ejercicio_json.dart';

class ListaEjerciciosJSON extends StatefulWidget {
  @override
  createState() => _ListaEjerciciosJSON();
}

class _ListaEjerciciosJSON extends State<ListaEjerciciosJSON> {
  Future<String> cargarEjercicios() async {
    return await rootBundle.loadString('assets/json/ejercicios.json');
  }

  /*Color colorear(tipo) {
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
  }*/

  Widget itemEjercicio(String ejerciciosString) {
    List<dynamic> ejercicios = jsonDecode(ejerciciosString);
    if (ejercicios.length > 0) {
      return ListView(
        //No Scroll
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(
          ejercicios.length,
          (iEjercicio) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesEjercicioJSON(
                      datos: ejercicios[iEjercicio],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MisterFootball.primario,
                    width: .4,
                  ),
                ),
                margin: EdgeInsets.only(
                  top: (iEjercicio != 0) ? 2.5 : 0,
                  bottom: (iEjercicio != (ejercicios.length - 1)) ? 2.5 : 0,
                ),
                child: Table(
                  border: TableBorder(
                    verticalInside: BorderSide(
                      color: MisterFootball.primario,
                      width: .4,
                    ),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                          /*border: TableBorder(
                    top: BorderSide(color: MisterFootball.primario),
                    left: BorderSide(color: MisterFootball.primario),
                    right: BorderSide(color: MisterFootball.primario),
                    bottom: (iEjercicio == ejercicios.length - 1)
                        ? BorderSide(color: MisterFootball.primario)
                        : BorderSide(color: colorear(ejercicios[iEjercicio]['tipo']).withOpacity(.4)),
                  ),*/
                          /*color: colorear(ejercicios[iEjercicio]['tipo']).withOpacity(.4),*/
                          //color: (iEjercicio.isEven) ? MisterFootball.primario : MisterFootball.semiprimarioLight2.withOpacity(.25),
                          ),
                      children: [
                        //Título
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            ejercicios[iEjercicio]['titulo'],
                            textAlign: TextAlign.center,
                            /*style: TextStyle(
                              color: (iEjercicio.isEven) ? Colors.white : MisterFootball.primario,
                            ),*/
                          ),
                        ),
                        //Tipo
                        Text(
                          ejercicios[iEjercicio]['tipo'],
                          textAlign: TextAlign.center,
                          /*style: TextStyle(
                            color: (iEjercicio.isEven) ? Colors.white : MisterFootball.primario,
                          ),*/
                        ),
                        //Duración
                        Text(
                          "${ejercicios[iEjercicio]['duracion']} min",
                          textAlign: TextAlign.center,
                          /*style: TextStyle(
                            color: (iEjercicio.isEven) ? Colors.white : MisterFootball.primario,
                          ),*/
                        ),
                        //Dificultad
                        Text(
                          ejercicios[iEjercicio]['dificultad'],
                          textAlign: TextAlign.center,
                          /*style: TextStyle(
                            color: (iEjercicio.isEven) ? Colors.white : MisterFootball.primario,
                          ),*/
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            /*return Card(
            /*shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),*/
            child: new InkWell(
              splashColor: MisterFootball.complementario,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetallesEjercicioJSON(datos: ejercicios[iEjercicio],)),
                );
              },
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
                      "${ejercicios[iEjercicio]['duracion']} min",
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
          );*/
          },
        ),
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
                      return Container(
                        padding: EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Table(
                                  border: TableBorder(verticalInside: BorderSide(color: MisterFootball.primario)),
                                  children: [
                                    TableRow(
                                      children: [
                                        //Título
                                        Text(
                                          "Titulo",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        //Tipo
                                        Text(
                                          "Tipo",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        //Tiempo
                                        Text(
                                          "Duración",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        //Dificultad
                                        Text(
                                          "Dificultad",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              itemEjercicio(snapshot.data),
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
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
