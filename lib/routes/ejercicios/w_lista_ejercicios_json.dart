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
  String valorOrdenarPor = "Duración";
  List<String> elementosOrdenarPor = ["Duración", "Tipo", "Dificultad"];

  Future<String> cargarEjercicios() async {
    return await rootBundle.loadString('assets/json/ejercicios.json');
  }

  LinearGradient colorearDificultad(String dificultad) {
    LinearGradient coloreado = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [const Color(0xFF000000), const Color(0xFF000000)],
    );
    switch (dificultad.toLowerCase()) {
      case "fácil":
        coloreado = LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
          colors: [const Color(0xFFFFFFFF), const Color(0xFFefffe6)],
        );
        break;
      case "media":
        coloreado = LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
          colors: [const Color(0xFFFFFFFF), const Color(0xFFfff7e6)],
        );
        break;
      case "difícil":
        coloreado = LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
          colors: [const Color(0xFFFFFFFF), const Color(0xFFffe6e6)],
        );
        break;
    }
    return coloreado;
  }

  Widget itemEjercicio(String ejerciciosString) {
    List<dynamic> ejercicios = jsonDecode(ejerciciosString);
    if (ejercicios.length > 0) {
      return ListView(
        //No Scroll
        //physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(
          ejercicios.length,
          (iEjercicio) {
            return Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .03,
                right: MediaQuery.of(context).size.width * .03,
                bottom: 2,
                top: 2,
              ),
              child: Card(
                elevation: 2.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                child: InkWell(
                  splashColor: Colors.black12,
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
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * .025,
                    ),
                    decoration: BoxDecoration(
                      gradient: colorearDificultad(ejercicios[iEjercicio]['dificultad']),
                      //border: Border.all(color: MisterFootball.colorPrimarioLight2, width: .2),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 10
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ejercicios[iEjercicio]['titulo'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(ejercicios[iEjercicio]['tipo']),
                            Text("${ejercicios[iEjercicio]['duracion']} min"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MisterFootball.colorFondo,
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
                      return Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: MisterFootball.colorSemiprimarioLight2),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * .04,
                              right: MediaQuery.of(context).size.width * .04,
                              top: 10,
                              bottom: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text("Filtrar"),
                                      Icon(Icons.filter_list),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    DropdownButton<String>(
                                      value: valorOrdenarPor,
                                      icon: Icon(
                                        Icons.import_export,
                                      ),
                                      underline: Container(
                                        height: 2,
                                        color: MisterFootball.colorPrimarioLight2,
                                      ),
                                      onChanged: (String v) {
                                        setState(() {
                                          valorOrdenarPor = v;
                                        });
                                      },
                                      items: elementosOrdenarPor.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context).size.width * .03,
                                              left: MediaQuery.of(context).size.width * .02,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: itemEjercicio(snapshot.data),
                          )
                        ],
                      );
                      /*return Container(
                        padding: EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Table(
                                  border: TableBorder(verticalInside: BorderSide(color: MisterFootball.colorPrimario)),
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
                      );*/
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
