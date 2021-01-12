import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mister_football/animaciones/animacion_detalles.dart';
import 'package:mister_football/clases/jugador.dart';
import 'package:mister_football/main.dart';
import 'package:mister_football/routes/gestion_jugadores/detalles_jugadores/v_detalles_jugador.dart';

class ListaGestionJugadores extends StatefulWidget {
  @override
  createState() => _ListaGestionJugadores();
}

class _ListaGestionJugadores extends State<ListaGestionJugadores> {
  String valorOrdenarPor = "Posición";
  List<String> elementosOrdenarPor = ["Posición", "Edad", "Apodo"];

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  Widget cartasJugadores() {
    final boxJugadores = Hive.box('jugadores');

    String acortarPosicion(String posicion) {
      String respuesta = "";
      switch (posicion.toLowerCase()) {
        case "por":
        case "portero":
          respuesta = "PT";
          break;
        case "def":
        case "central":
        case "líbero":
          respuesta = "DF";
          break;
        case "lateral derecho":
          respuesta = "LD";
          break;
        case "lateral izquierdo":
          respuesta = "LI";
          break;
        case "carrilero derecho":
          respuesta = "CD";
          break;
        case "carrilero izquierdo":
          respuesta = "CI";
          break;
        case "med":
        case "mediocentro defensivo":
        case "mediocentro central":
        case "mediocentro ofensivo":
          respuesta = "MC";
          break;
        case "interior derecho":
          respuesta = "MD";
          break;
        case "interior izquierdo":
          respuesta = "MI";
          break;
        case "mediapunta":
          respuesta = "MP";
          break;
        case "del":
        case "falso 9":
        case "segundo delantero":
        case "delantero centro":
          respuesta = "DL";
          break;
        case "extremo derecho":
          respuesta = "ED";
          break;
        case "extremo izquierdo":
          respuesta = "EI";
          break;
      }
      return respuesta;
    }

    LinearGradient colorearPosicion(String posicion) {
      LinearGradient coloreado = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [const Color(0xFF000000), const Color(0xFF000000)],
      );
      switch (posicion.toLowerCase()) {
        case "por":
        case "portero":
          coloreado = LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [const Color(0xFFe39520), const Color(0xFFe38520)],
          );
          break;
        case "def":
        case "central":
        case "líbero":
        case "lateral derecho":
        case "lateral izquierdo":
        case "carrilero derecho":
        case "carrilero izquierdo":
          coloreado = LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [const Color(0xFF0fa8db), const Color(0xFF0e8fcf)],
          );
          break;
        case "med":
        case "mediocentro defensivo":
        case "mediocentro central":
        case "mediocentro ofensivo":
        case "interior derecho":
        case "interior izquierdo":
        case "mediapunta":
          coloreado = LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [const Color(0xFF14cf11), const Color(0xFF22b317)],
          );
          break;
        case "del":
        case "falso 9":
        case "segundo delantero":
        case "delantero centro":
        case "extremo derecho":
        case "extremo izquierdo":
          coloreado = LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [const Color(0xFFf53625), const Color(0xFFc72412)],
          );
          break;
      }
      return coloreado;
    }

    List jugadoresOrdenados = [];
    for (var i = 0; i < boxJugadores.length; i++) {
      if (boxJugadores.getAt(i).habilitado) {
        jugadoresOrdenados.add([i, boxJugadores.getAt(i).apodo, boxJugadores.getAt(i).posicionFavorita]);
      }
    }
    //Ordenar por apodo
    jugadoresOrdenados.sort((a, b) => (a[1].toString().toLowerCase()).compareTo(b[1].toString().toLowerCase()));

    //Jugadores deshabilitados
    List jugadoresDeshabilitados = [];
    for (var i = 0; i < boxJugadores.length; i++) {
      if (!boxJugadores.getAt(i).habilitado) {
        jugadoresDeshabilitados.add([i, boxJugadores.getAt(i).apodo, boxJugadores.getAt(i).posicionFavorita]);
      }
    }
    //Ordenar por apodo
    jugadoresDeshabilitados.sort((a, b) => (a[1].toString().toLowerCase()).compareTo(b[1].toString().toLowerCase()));

    //Añadir jugadores deshabilitados a la lista
    jugadoresOrdenados.addAll(jugadoresDeshabilitados);

    if (boxJugadores.length > 0) {
      return ListView(
        shrinkWrap: true,
        children: List.generate(boxJugadores.length, (iJugador) {
          final Jugador jugadorBox = boxJugadores.getAt(jugadoresOrdenados[iJugador][0]) as Jugador;
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
                    AnimacionDetalles(
                      widget: DetallesJugador(
                        posicion: jugadoresOrdenados[iJugador][0],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .03,
                  ),
                  decoration: (jugadorBox.habilitado)
                      ? BoxDecoration()
                      : BoxDecoration(
                          color: MisterFootball.colorSemiprimarioLight2,
                        ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          (jugadorBox.habilitado)
                              ? Container(
                                  width: 40.0,
                                  height: 40.0,
                                  margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width * .03,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(gradient: colorearPosicion(jugadorBox.posicionFavorita)),
                                  child: Text(
                                    acortarPosicion(jugadorBox.posicionFavorita),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 40.0,
                                  height: 40.0,
                                  margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width * .03,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.visibility_off,
                                    color: MisterFootball.colorPrimario,
                                  ),
                                ),
                          Container(
                            width: MediaQuery.of(context).size.width * .32,
                            child: Text(
                              jugadorBox.apodo,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * .3,
                            margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * .03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  jugadorBox.nombre,
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  (jugadorBox.apellido2.length > 0)
                                      ? ("${jugadorBox.apellido1} ${jugadorBox.apellido2}")
                                      : ("${jugadorBox.apellido1}"),
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "${jugadorBox.calcularEdad()} años",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  (jugadorBox.piernaBuena == "Derecha") ? "Diestro" : "Zurdo",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Image.asset('assets/img/icono_persona.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      );
    } else {
      return Center(
        child: Text("No hay ningún jugador creado."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //refreshList();
    return Scaffold(
      backgroundColor: MisterFootball.colorFondo,
      body: SafeArea(
        child: FutureBuilder(
          future: Hive.openBox('jugadores'),
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
                                      child: Text(value, textAlign: TextAlign.center,),
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
                      child: cartasJugadores(),
                    )
                  ],
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
