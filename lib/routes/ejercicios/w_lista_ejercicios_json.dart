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
/*
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
                  border: Border(
                    top: BorderSide(
                      color: MisterFootball.colorPrimario,
                      width: (iEjercicio == 0) ? .4 : 0,
                    ),
                    bottom: BorderSide(
                      color: MisterFootball.colorPrimario,
                      width: .4,
                    ),
                    left: BorderSide(
                      color: MisterFootball.colorPrimario,
                      width: .4,
                    ),
                    right: BorderSide(
                      color: MisterFootball.colorPrimario,
                      width: .4,
                    ),
                  ),
                ),
                /*margin: EdgeInsets.only(
                  top: (iEjercicio != 0) ? 2.5 : 0,
                  bottom: (iEjercicio != (ejercicios.length - 1)) ? 2.5 : 0,
                ),*/
                child: Table(
                  border: TableBorder(
                    verticalInside: BorderSide(
                      color: MisterFootball.colorPrimario,
                      width: .4,
                    ),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(),
                      children: [
                        //Título
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            ejercicios[iEjercicio]['titulo'],
                            textAlign: TextAlign.center,
                            /*style: TextStyle(
                              color: (iEjercicio.isEven) ? Colors.white : MisterFootball.colorPrimario,
                            ),*/
                          ),
                        ),
                        //Tipo
                        Text(
                          ejercicios[iEjercicio]['tipo'],
                          textAlign: TextAlign.center,
                          /*style: TextStyle(
                            color: (iEjercicio.isEven) ? Colors.white : MisterFootball.colorPrimario,
                          ),*/
                        ),
                        //Duración
                        Text(
                          "${ejercicios[iEjercicio]['duracion']} min",
                          textAlign: TextAlign.center,
                          /*style: TextStyle(
                            color: (iEjercicio.isEven) ? Colors.white : MisterFootball.colorPrimario,
                          ),*/
                        ),
                        //Dificultad
                        Text(
                          ejercicios[iEjercicio]['dificultad'],
                          textAlign: TextAlign.center,
                          /*style: TextStyle(
                            color: (iEjercicio.isEven) ? Colors.white : MisterFootball.colorPrimario,
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
*/

  LinearGradient colorearDificultad(String dificultad) {
    LinearGradient coloreado = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [const Color(0xFF000000), const Color(0xFF000000)],
    );
    switch (dificultad.toLowerCase()) {
      case "fácil":
        coloreado = LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFF64ed61), const Color(0xFF78de76)],
        );
        break;
      case "media":
        coloreado = LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFFe6a353), const Color(0xFFdeab6f)],
        );
        break;
      case "difícil":
        coloreado = LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFFeb6c60), const Color(0xFFe38178)],
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
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(ejercicios[iEjercicio]['titulo']),
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
                  border: Border(
                    top: BorderSide(
                      color: MisterFootball.colorPrimario,
                      width: (iEjercicio == 0) ? .4 : 0,
                    ),
                    bottom: BorderSide(
                      color: MisterFootball.colorPrimario,
                      width: .4,
                    ),
                    left: BorderSide(
                      color: MisterFootball.colorPrimario,
                      width: .4,
                    ),
                    right: BorderSide(
                      color: MisterFootball.colorPrimario,
                      width: .4,
                    ),
                  ),
                ),
                /*margin: EdgeInsets.only(
                  top: (iEjercicio != 0) ? 2.5 : 0,
                  bottom: (iEjercicio != (ejercicios.length - 1)) ? 2.5 : 0,
                ),*/
                child: Table(
                  border: TableBorder(
                    verticalInside: BorderSide(
                      color: MisterFootball.colorPrimario,
                      width: .4,
                    ),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(),
                      children: [
                        //Título
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            ejercicios[iEjercicio]['titulo'],
                            textAlign: TextAlign.center,
                            /*style: TextStyle(
                              color: (iEjercicio.isEven) ? Colors.white : MisterFootball.colorPrimario,
                            ),*/
                          ),
                        ),
                        //Tipo
                        Text(
                          ejercicios[iEjercicio]['tipo'],
                          textAlign: TextAlign.center,
                          /*style: TextStyle(
                            color: (iEjercicio.isEven) ? Colors.white : MisterFootball.colorPrimario,
                          ),*/
                        ),
                        //Duración
                        Text(
                          "${ejercicios[iEjercicio]['duracion']} min",
                          textAlign: TextAlign.center,
                          /*style: TextStyle(
                            color: (iEjercicio.isEven) ? Colors.white : MisterFootball.colorPrimario,
                          ),*/
                        ),
                        //Dificultad
                        Text(
                          ejercicios[iEjercicio]['dificultad'],
                          textAlign: TextAlign.center,
                          /*style: TextStyle(
                            color: (iEjercicio.isEven) ? Colors.white : MisterFootball.colorPrimario,
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
